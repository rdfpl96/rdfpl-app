
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/res/components/app_button.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/view_models/delivery_options_viewmodel.dart';

class Delivery_Options extends StatefulWidget {

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Delivery_Options> {

  final ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    DeliveryOptionsViewModel provider=Provider.of(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var green = Color(0xFF689f39);
    var darkgrey = Color(0xFF7b7c7a);
    var red = Color(0xFFf17523);

    String address = provider.add_list==null?"":"${provider.add_list['address1']}, ${provider.add_list['address2']}, ${provider.add_list['area']}, ${provider.add_list['landmark']}, ${provider.add_list['city']}, ${provider.add_list['state']}- ${provider.add_list['pincode']}";
    print('Sssssssssslot=${provider.selected_slot==null?"null":provider.selected_slot['date_title']}');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(onTap: (){Navigator.pop(context);},child: Container(color: green,child: Icon(CupertinoIcons.back,))),
        backgroundColor: green,
        title: Text('Delivery Options',style: TextStyle(fontSize: 16,color: Colors.white)),
        centerTitle: true,
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.yellow.withOpacity(0.2),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                         SvgPicture.asset('assests/images/navigation.svg',width: 30,height: 30,color: Colors.black.withOpacity(0.7),),
                          SizedBox(width: 5,),
                          Text('Delivery to: ${provider.add_list==null?"":(provider.add_list['nick_name']==null?"":provider.add_list['nick_name'])}',style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.7))),
                          Text('(Default)',style: TextStyle(color: Colors.black.withOpacity(0.5))),
                        ],
        ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, RouteNames.route_delivery_address_screen).then((value) => provider.getDefaultAddress());
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20,4,20,4),
                              margin: EdgeInsets.fromLTRB(10,4,10,4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: green.withOpacity(0.5),
                                  width: 1,

                                ),
                              ),
                              child: Text('Change',style: TextStyle(color: green),),
                            ),
                          )


                    ],
                  ),
                  SizedBox(height: 2,),
                  Text(address,
                    style: TextStyle(color: darkgrey,fontSize: 12),),

                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0,15,0,15),
                    child: Row(
                      children: [
                        Expanded(child: Container(
                          //  alignment:Alignment.center,
                            margin: EdgeInsets.fromLTRB(20,0,0,0),
                            child: Text('Default Delivery Option',
                              style: TextStyle(fontSize: 15,color: Colors.black.withOpacity(0.6)),))),
                        Container(
                          margin: EdgeInsets.fromLTRB(10,0,20,0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Delivery Charges:',style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6)),),
                              Text('FREE',style: TextStyle(fontSize: 12,color: red),),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                  Container(
                    height: 0.7,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(0,15,0,15),
                    child: Row(
                      children: [
                        Expanded(child: Container(
                            margin: EdgeInsets.fromLTRB(20,0,0,0),
                            child: Text('Shipment 1: Express Delivery',
                              style: TextStyle(fontSize: 13,color: darkgrey.withOpacity(0.7)),))),
                        Container(
                          margin: EdgeInsets.fromLTRB(10,0,20,0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: darkgrey.withOpacity(0.5),
                              width: 1
                            )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(padding: EdgeInsets.fromLTRB(20,4,20,4),
                                    child: Text('View ${(provider.cart_list as List).length} items',style: TextStyle(fontSize: 12,color: darkgrey.withOpacity(0.7)),)),
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),


                  GestureDetector(
                    onTap: (){
                      BtmSheet_DateTime(provider);
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20,5,20,5),
                      padding: EdgeInsets.fromLTRB(5,5,20,5),
                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                              color: darkgrey.withOpacity(0.7),
                              width: 1
                          )
                      ),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.clock,color: darkgrey.withOpacity(0.9),size: 20,),
                          SizedBox(width: 5,),
                          Text('${(provider.selected_slot==null?"Select Slot":'${provider.selected_slot['date_title']} ${provider.selected_slot['slots']['start_time']} - ${provider.selected_slot['slots']['end_time']}')}',style: TextStyle(fontSize: 12,color: darkgrey.withOpacity(0.7)),),
                          Expanded(child: Container(alignment: Alignment.centerRight,child: Icon(CupertinoIcons.chevron_down,color: darkgrey.withOpacity(0.9),size: 20,)),)
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child:ExpansionTile(

                    title: Row(
                      children: [
                        Checkbox(value: provider.is_gst_detsails, onChanged: (value) =>provider.setIsGst(value!) ,),
                        Text('Enter GST Details')
                      ],
                    ),
                    children:  [
                      SizedBox(height: 20,),
                        Container(
                          child: TextFormField(
                            enabled: provider.is_gst_detsails,
                            controller: provider.tecGst,
                            // keyboardType: authViewmodel.isemail_login?TextInputType.emailAddress:TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                              hintText: 'GST No',
                              label: Text('GST No'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          child: TextFormField(
                            enabled: provider.is_gst_detsails,
                            controller: provider.tecGstCompName,
                            // keyboardType: authViewmodel.isemail_login?TextInputType.emailAddress:TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                              hintText: 'Registered Company Name',
                              label: Text('Registered Company Name'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          child: TextFormField(
                            enabled: provider.is_gst_detsails,
                            controller: provider.tecGstCompAddress,
                            // keyboardType: authViewmodel.isemail_login?TextInputType.emailAddress:TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                              hintText: 'Registered Company Address',
                              label: Text('Registered Company Address'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          child: TextFormField(
                            enabled: provider.is_gst_detsails,
                            controller: provider.tecPincode,
                            // keyboardType: authViewmodel.isemail_login?TextInputType.emailAddress:TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                              hintText: 'Pincode',
                              label: Text('Pincode'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          child: TextFormField(
                            enabled: provider.is_gst_detsails,
                            controller: provider.tecFssaiNo,
                            // keyboardType: authViewmodel.isemail_login?TextInputType.emailAddress:TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                              hintText: 'FSSAI NO',
                              label: Text('FSSAI NO'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          child: TextFormField(
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            enabled: provider.is_gst_detsails,
                            controller: provider.tecMobileNo,
                            // keyboardType: authViewmodel.isemail_login?TextInputType.emailAddress:TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                              hintText: 'Mobile No',
                              label: Text('Mobile No'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            enabled: provider.is_gst_detsails,
                            controller: provider.tecEmail,
                            // keyboardType: authViewmodel.isemail_login?TextInputType.emailAddress:TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                              hintText: 'Email',
                              label: Text('Email'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      SizedBox(height: 10,),
                      AppButton(title: "Save",loading: provider.is_loading_add_gst, onTap: () {
                        provider.saveGSTDetails();

                      },),
                      SizedBox(height: 10,),
                      ],

                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                provider.next();
              },
              child: Container(
                  width: width,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: red,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Text(
                    'PROCEED TO PAY',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  )),
            ),
            ],
        ),
      )
      );
  }

  void BtmSheet_DateTime(DeliveryOptionsViewModel provider) {

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Use MediaQuery to access screen dimensions
        double screenHeight = MediaQuery.of(context).size.height;

        return Container(
          width: double.infinity,
          height: screenHeight * 0.6, // Set the height as needed
          child: ListView.builder(
            itemCount: provider.slots_list.length,
            itemBuilder:(context, index) {
              return Container(

                child:

                    Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text('${provider.slots_list[index]['date_title']}'),
                      tileColor: Colors.lightGreen,
                    ),
                    for(int i=0;i<(provider.slots_list[index]['slots'] as List).length;i++)...{
                      InkWell(
                        onTap: () {
                          print('changing slot');
                         // provider.changeSlot(provider.slots_list[index]);
                        },
                        child:ListTile(
                        leading: Icon(CupertinoIcons.clock),
                        title: Text('${provider.slots_list[index]['slots'][i]['start_time']} - ${provider.slots_list[index]['slots'][i]['end_time']}'),
                        onTap: () {
                          // Add your action here
                          var _model=Map<String, dynamic>.from(provider.slots_list[index]);
                          _model['slots']=provider.slots_list[index]['slots'][i];
                          provider.changeSlot(_model);
                          Navigator.pop(context);
                        },
                      ),
                      ),
                    },


                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}






