import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../res/colors.dart';
import '../res/components/app_button.dart';
import '../view_models/auth_viewmodel.dart';

class LoginSignUpScreen extends StatelessWidget {
  LoginSignUpScreen({super.key});

  TextEditingController pinEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewmodel = Provider.of(context);
    double sHeight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kGreen, // Color 1
                  kGreen, // Color 1 (same as color 1)
                  Colors.white, // Color 2
                  Colors.white, // Color 2 (same as color 2)
                ],
                stops: [0.35, 0.35, 0.35, 0.35],
                // Equal stops create a hard color split
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Container(
              width: width - 40,
              child: Column(
                children: [
                  SizedBox(height: 60),
                  SizedBox(
                    height: 80,
                    child: Image.asset("assests/images/rd_logo.png",
                        fit: BoxFit.cover),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Login/Sign Up',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: width,
                    height: 350,
                    decoration: cardview(),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              // if (authViewmodel.isemail_login) ...{
                              //   Expanded(
                              //     flex: 7,
                              //     child: Container(
                              //       child: TextFormField(
                              //         controller: emailEditingController,
                              //         keyboardType: TextInputType.text,
                              //         decoration: InputDecoration(
                              //           contentPadding:
                              //               EdgeInsets.fromLTRB(2, 0, 0, 0),
                              //           hintText: 'Enter Email',
                              //           // label: Text(
                              //           //     '${authViewmodel.isemail_login}'),
                              //           border: InputBorder.none,
                              //           hintStyle: TextStyle(
                              //               fontSize: 14,
                              //               color:
                              //                   Colors.black.withOpacity(0.5)),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // } else ...{
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    child: TextFormField(
                                      key: ValueKey(authViewmodel.isemail_login),
                                      controller: pinEditingController,
                                      keyboardType:
                                      authViewmodel.isemail_login
                                          ? TextInputType.text :
                                      TextInputType.phone,


                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(2, 0, 0, 0),
                                        hintText:
                                        authViewmodel.isemail_login
                                            ? 'Enter Email':
                                             'Enter Mobile Number',
                                        // label: Text(
                                        //     '${authViewmodel.isemail_login}'),
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                              // },
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => EmailSignUpScreen()),
                                    // );


                                    pinEditingController.text = "";
                                    authViewmodel.setEmailLogin(
                                        !authViewmodel.isemail_login);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black.withOpacity(0.2),
                                          width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                    ),
                                    child: SizedBox(
                                        height: 30,
                                        child: Center(
                                            child: Text(
                                                '${authViewmodel.isemail_login ? 'Use Mob No' : 'Use Email'}',
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5))))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 1,
                            width: width,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          AppButton(
                            title: 'Continue',
                            loading: authViewmodel.loading,
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Upload_ProfileDet()),
                              // );
                              Map data = {
                                "email_mobi": pinEditingController.text,
                                // "password": "krishna009300"
                              };
                              authViewmodel.login(data, context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration cardview() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 4,
          blurRadius: 8,
          offset: Offset(0, 4), // changes position of shadow
        ),
      ],
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
  }
}
