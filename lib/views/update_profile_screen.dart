import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../res/components/app_button.dart';
import '../utils/routes/routes_name.dart';
import '../view_models/update_userdet_viewmodel.dart';
enum VIEW_TYPE{FIRST_VISIT,UPDATE}
class UpdateProfileScreen extends StatelessWidget {
  var data;
  /***********
   * Below is the Structure of Data
      {
      "email": null,
      "mobile": "9773038331",
      "name": null
      }
      ****************/
   VIEW_TYPE? view_type;
  UpdateProfileScreen({super.key,this.data,this.view_type}){
    print("ZZzZZzz:$data");
    nameController.text=data['name']==null?"":data['name'];
    lnameController.text=data['lname']==null?"":data['lname'];
    emailController.text=data['email']==null?"":data['email'];
    mobileController.text=data['mobile']==null?"":data['mobile'];
    if(view_type==VIEW_TYPE.FIRST_VISIT){
    is_mobile_enable=data['mobile']==null?true:false;
    is_email_enable=data['email']==null?true:false;
    }else{
      is_mobile_enable=true;
      is_email_enable=true;
    }

  }


  var green = Color(0xFF689f39);
  var darkgrey = Color(0xFF7b7c7a);
  var red = Color(0xFFf17523);

  TextEditingController pinEditingController = TextEditingController();

  TextEditingController nameController=TextEditingController();
  TextEditingController lnameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController mobileController=TextEditingController();

  late bool is_mobile_enable,is_email_enable;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    UpdateUserDetailViewModel viewModel=Provider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
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
                      view_type==VIEW_TYPE.FIRST_VISIT?'Almost There!':"My Profile",
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
                            TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Your Name',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.5)),),
                            ),
                            Container(height: 1,width: width,
                              color: Colors.black.withOpacity(0.2),),
                            TextFormField(
                              controller: lnameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Last Name',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.5)),),
                            ),
                            Container(height: 1,width: width,
                              color: Colors.black.withOpacity(0.2),),
                            TextFormField(
                              controller: mobileController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Mobile No',
                                enabled: is_mobile_enable,
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                            ),
                            Container(height: 1,width: width,
                              color: Colors.black.withOpacity(0.2),),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabled: is_email_enable,
                                hintText: 'Email Address',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                            ),
                            Container(height: 1,width: width,
                              color: Colors.black.withOpacity(0.2),),
                            SizedBox(
                              height: 40,
                            ),

                            AppButton(title: view_type==VIEW_TYPE.FIRST_VISIT?'Start Shopping':'Update',loading: viewModel.loading, onTap: () {
                              //Direct passing to home
                              // if(true) {
                              //   Navigator.pushNamed(context, RouteNames.route_home);
                              // }
                              Map _data={
                                // "email_mobi": pinEditingController.text,
                                // "customer_id":data['customer_id'],
                                "name": nameController.text,
                                "lname": lnameController.text,
                                "email":emailController.text,
                                "mobile":mobileController.text,

                              };

                              var field_type="";
                              var raw_data= {};
                              print('Tyyyyyp:$view_type');
                              if(view_type==VIEW_TYPE.FIRST_VISIT) {
                                if (data['email'] == null) {
                                  field_type = "2";
                                }
                                else if (data['mobile'] == null) {
                                  field_type = "3";
                                } else if (data['name'] == null) {
                                  field_type = "1";
                                }
                                //1- name,2-email,3-mobile

                                raw_data = {
                                  "fname": _data['name'],
                                  "lname": _data['lname'],
                                  "email": data['email'] == null? _data['email'] : data['email'],
                                  "mobile": data['mobile'] == null? _data['mobile'] : data['mobile'],
                                  "field_type": field_type
                                };
                              }else{
                                if(data['email']==emailController.text.toString() && data['mobile']==mobileController.text.toString()){
                                  field_type="1";
                                }
                                else if(data['email']!=emailController.text){
                                  field_type="2";
                                }
                                else if(data['mobile']!=mobileController.text){
                                  field_type="3";
                                }


                                raw_data = {
                                  "fname": _data['name'],
                                  "lname": _data['lname'],
                                  "email":  _data['email'],
                                  "mobile": _data['mobile'],
                                  "field_type": field_type
                                };
                              }
                              viewModel.updateuserdetails(raw_data,context );



                            },),

                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            if(view_type==VIEW_TYPE.UPDATE)...{
              IconButton(onPressed: () => Navigator.pop(context),
                  icon: Icon(CupertinoIcons.back,color: Colors.white,))
            },
          ],
        ),
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
