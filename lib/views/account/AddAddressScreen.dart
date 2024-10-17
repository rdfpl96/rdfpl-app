import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/res/components/drp_button.dart';

import '../../view_models/add_edit_address_viewmodel.dart';
import '../../view_models/delivery_address_viewmodel.dart';

class AddAddressScreen extends StatefulWidget{
  String? address;

  AddAddressScreen({this.address});

  @override
  AddAddressScreenState createState() => AddAddressScreenState();

}

class AddAddressScreenState extends State<AddAddressScreen>{

  var skin = Color(0xFFfbffe0);
  bool isFocus_AptHno = false;
  late AddEditAddressViewModel provider;
  @override
  void initState() {
    // AddEditAddressViewModel pro=Provider.of(context,listen: false);
    // pro.getAddressFromLatLng(lat, lng)
    // pro.getAddress(context,widget.address!);
    // pro.getStateList(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider=Provider.of(context);

    print('data:${provider.add_list}');
    print('provider.loading_state:${provider.loading_state} loading:${provider.loading_address} loading g add:${provider.is_load_gaddress}');
    var green = Color(0xFF689f39);
    var darkgrey = Color(0xFF7b7c7a);
    var red = Color(0xFFf17523);

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(toolbarHeight: 0,elevation: 0,),
      appBar: AppBar(leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(color: green,width: 30,height: 30,child: Icon(CupertinoIcons.back))),
        title: Text("Add Address"),centerTitle: true,shadowColor: Colors.transparent,),
      body: (provider.loading_address || provider.loading_state || provider.is_load_gaddress)?Center(
        child: CircularProgressIndicator(),
      ):SingleChildScrollView(
        child: Container(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
           color: Colors.white,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 0,
                width: width,
                child: Text("Google Map"),
              ),
              Container(
                color: skin,
                padding:EdgeInsets.fromLTRB(10,20,10,20),
                width: width,
                child: Column(
                  children: [
                    // provider.loading_address?Center(child: CircularProgressIndicator(),):
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Container(
                            padding: EdgeInsets.only(left: 6, right: 6),
                            child: SvgPicture.asset("assests/images/navigation.svg",color: Colors.black,),
                          ),
                        ),
                        Expanded(
                          child: /*(provider.add_list==null||(provider.add_list as List).isEmpty)?Center(child: Container()):*/
                          Column(
                            children: [
                              Container(width: width,child: Text('${provider.address}',style: TextStyle(fontSize: 16))),
                              Container(width: width,child: Text('',style: TextStyle(fontSize: 16))),
                              // Container(width: width,child: Text('${provider.add_list[0]['area']}',style: TextStyle(fontSize: 16))),
                              // Container(width: width,child: Text('${provider.add_list[0]['address1']} ${provider.add_list[0]['address2']} ${provider.add_list[0]['landmark']} ${provider.add_list[0]['state']} ${provider.add_list[0]['city']}- ${provider.add_list[0]['pincode']}',style: TextStyle(color: Colors.grey),)),
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap:() => Navigator.pop(context),child: Container(padding: EdgeInsets.all(10),child: Text('Change',style: TextStyle(color: Colors.green),))),
                      ],
                    ),

                  ],
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(20,0,20,0),
                child: Column(
                  children: [
                    TextFormField(
                      controller:provider.tec_HoNo,
                      decoration: InputDecoration(
                        labelText: '*Apartment / House No.',
                        labelStyle: TextStyle(
                          color: Colors.grey,  // Set the color of the label text
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller:provider.tec_AprtName,
                      decoration: InputDecoration(
                        labelText: '*Apartment Name/ House Name',
                        labelStyle: TextStyle(
                          color: Colors.grey,  // Set the color of the label text
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller:provider.tec_Area,
                      decoration: InputDecoration(
                        labelText: 'Area',
                        labelStyle: TextStyle(
                          color: Colors.grey,  // Set the color of the label text
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller:provider.tec_Street,
                      decoration: InputDecoration(
                        labelText: 'Street Details/ Landmark',
                        labelStyle: TextStyle(
                          color: Colors.grey,  // Set the color of the label text
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('State',style: TextStyle(
                        color: Colors.grey,  // Set the color of the label text
                      ),),
                    ),
                    // provider.loading_state?Container(child:Center(child: CircularProgressIndicator(),)):
                    (provider.state_list!=null &&(provider.state_list as List).length>0)?
                    DrpButton(provider.selected_state, (provider.state_list as List).map((e) => (e as Map<String,dynamic>)).toList(),
                        (selected_val){
                          provider.changeState(selected_val);
                          //provider.getCityList(context);
                        },
                        "Select State"):Container(child: Text('State List Not Found'),),
                    SizedBox(height: 10,),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text('City',style: TextStyle(
                    //     color: Colors.grey,  // Set the color of the label text
                    //   ),),
                    // ),
                    // provider.loading_city?Center(child: CircularProgressIndicator(),):
                    // (provider.city_list!=null &&(provider.city_list as List).length>0)?DrpButton(provider.selected_city, (provider.city_list as List).map((e) => (e as Map<String,dynamic>)).toList(),
                    //         (selected_val){
                    //       provider.changeCity(selected_val);
                    //     },
                    //     "Select City"):Container(child: Text('City List Not Found'),),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller:provider.tec_city,
                      decoration: InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(
                          color: Colors.grey,  // Set the color of the label text
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller:provider.tec_Pincode,
                      decoration: InputDecoration(
                        labelText: 'Pin Code',
                        labelStyle: TextStyle(
                          color: Colors.grey,  // Set the color of the label text
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller:provider.tec_Name,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        labelStyle: TextStyle(
                          color: Colors.grey,  // Set the color of the label text
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller:provider.tec_LName,
                      decoration: InputDecoration(
                        labelText: 'Your Last Name',
                        labelStyle: TextStyle(
                          color: Colors.grey,  // Set the color of the label text
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller:provider.tec_Mobile,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: 'Mobile',
                        labelStyle: TextStyle(
                          color: Colors.grey,  // Set the color of the label text
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    Container(width: width,child: Text('Address Type',style: TextStyle(fontSize: 16,color: Colors.grey),)),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        btn('Home'),
                        btn('Office'),
                        btn('Other'),
                      ],
                    ),
                    if(provider.addType!=null && provider.addType=='Other')...{
                      SizedBox(height: 10,),
                      TextFormField(
                        controller:provider.tec_Other,
                        decoration: InputDecoration(
                          labelText: 'Other',
                          labelStyle: TextStyle(
                            color: Colors.grey,  // Set the color of the label text
                          ),
                        ),

                      ),
                    },
                    SizedBox(height: 10,),
                    Row(
                      children: [
                       Checkbox(value: provider.chk_set_as_default, onChanged: (bool? value) {
                         provider.chk_set_as_default=(value!);
                       },),
                        Text('Set as default Address',style:  TextStyle(
                            color: Colors.grey,),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    provider.loading?Center(child: CircularProgressIndicator(),):GestureDetector(
                      onTap: () => provider.saveOrEditAddress(context),
                      child: Container(
                        alignment: Alignment.center,

                       // margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: red,
                        ),
                        width: width,
                        padding: EdgeInsets.fromLTRB(0,15,0,15),
                        child: Text('Save Address',style: TextStyle(color: Colors.white),),

                      ),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  btn(String s) {

    return  GestureDetector(
      onTap: (){
        String type='';
        if(s=='Home') {
          type="Home";
        }else if(s=='Office'){
          type="Office";
        }else{
          type="Other";
        }
        provider.addType = type;
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.fromLTRB(20,5,20,5),
        decoration: BoxDecoration(
          color: provider.addType==s?Colors.green.shade100:Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(
              color: provider.addType==s?Colors.blue:Colors.grey,
              width: 1
          ),
        ),child: Text(s,style: /*provider.addType==s?*/TextStyle(color: Colors.grey),),)
    );
  }



}
