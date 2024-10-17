import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/view_models/auth2_viewmodel.dart';

import '../res/components/app_button.dart';



class ReVerifyOtpScreen extends StatelessWidget {
  var data; //{"email":""} or{"mobile":""}
  ReVerifyOtpScreen({super.key,this.data}){
     //pinEditingController.text=data['otp'];
   }
   var green = Color(0xFF689f39);
   var darkgrey = Color(0xFF7b7c7a);
   var red = Color(0xFFf17523);

  TextEditingController pinEditingController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    Auth2ViewModel authViewmodel=Provider.of(context);

    double sHeight=MediaQuery.of(context).size.height;
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
                  green, // Color 1
                  green, // Color 1 (same as color 1)
                  Colors.white, // Color 2
                  Colors.white, // Color 2 (same as color 2)
                ],
                stops: [0.35, 0.35, 0.35, 0.35], // Equal stops create a hard color split
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
                    child: Image.asset("assests/images/rd_logo.png",fit: BoxFit.cover),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Verify Using OTP',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: width,
                    height: 350,
                    decoration: BoxDecoration(
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
                    ),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 20,),
                              Text('Please Check OTP sent to your ${(data['mobile']==null || data['mobile']==''?'email':'mobile number')}',style: TextStyle(fontSize: 13,color: Colors.grey),),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${data['mobile']==null || data['mobile']==''?data['email']:data['mobile'] }',
                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                          Colors.grey.withOpacity(0.5 ),
                                          width: 1.5),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                    ),
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: SizedBox(
                                          height: 25,
                                          child: Center(
                                              child: Text('  Change  ',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey)))),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10,0,10,0),
                            child: Column(
                              children: [
                                Container(width: width,child: Text('Enter OTP',
                                  style: TextStyle(fontSize: 13,color: Colors.grey,),)),
                                SizedBox(
                                  height: 80,
                                  child: PinCodeTextField(
                                    textStyle: TextStyle(color: Colors.black54.withOpacity(0.70),fontWeight: FontWeight.w200),
                                    appContext: context,
                                    controller: pinEditingController,
                                    keyboardType: TextInputType.number,
                                    length: 6,
                                    onChanged: (value) {
                                      // Handle value change
                                    },
                                    cursorColor: Colors.green,
                                    cursorHeight: 30,
                                    pinTheme: PinTheme(
                                      activeColor:green ,
                                      selectedColor:green,
                                      inactiveColor:Colors.grey,
                                      inactiveFillColor:green,
                                      errorBorderColor:green,
                                      borderWidth :1,
                                      shape: PinCodeFieldShape.underline, // Use underline style
                                      // activeColor: Colors.green,
                                      activeFillColor: Colors.transparent,
                                      selectedFillColor: Colors.transparent,
                                      // inactiveColor: Colors.grey,
                                      // selectedColor: green,
                                    ),
                                  ),
                                ),
                                authViewmodel.isButtonVisible?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap:(){
                                        Map _data;
                                        if(data['mobile']==null || data['mobile']==''){
                                          _data = {
                                            "email": data['email'],

                                          };
                                        }else {
                                          _data = {
                                            "mobile": data['mobile'],
                                          };
                                        }
                                        authViewmodel.reSendOtp(_data, context );
                                      },
                                      child: authViewmodel.loading_resend?
                                      Center(child:CircularProgressIndicator())
                                          :Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                              Colors.grey.withOpacity(0.5 ),
                                              width: 1.5),
                                          borderRadius: BorderRadius.all(Radius.circular(2)),
                                        ),
                                        child: SizedBox(
                                            height: 25,
                                            child: Center(
                                                child: Text('  Resend OTP  ',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey)))),
                                      ),
                                    ),
                                  ],
                                ):
                                Text(
                                  'Resend OTP in: ${authViewmodel.timeRemaining} seconds',
                                  style: TextStyle(fontSize: 18,color: Colors.grey.shade600),
                                ),
                                SizedBox(height: 15,),
                                AppButton(title: 'Continue',loading: authViewmodel.loading, onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => Upload_ProfileDet()),
                                  // );
                                  Map _data;
                                  if(data['mobile']==null || data['mobile']==''){
                                    _data = {
                                      "email": data['email'],
                                      "otp": pinEditingController.text
                                          .toString()
                                    };
                                  }else {
                                     _data = {
                                      "mobile": data['mobile'],
                                      "otp": pinEditingController.text
                                          .toString()
                                    };
                                  }
                                  authViewmodel.verifyotp(_data, context );
                                },),
                                SizedBox(height: 5,),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 25),
              child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(CupertinoIcons.back,color: Colors.white,))),
        ],
      ),
    );
  }
}
