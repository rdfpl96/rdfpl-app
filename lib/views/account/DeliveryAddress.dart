import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/view_models/delivery_address_viewmodel.dart';
import '../../view_models/current_location_viewmodel.dart';

class DeliveryAddress extends StatefulWidget{
  @override
  DA_State  createState() => DA_State();
}

class DA_State extends State<DeliveryAddress> {
  var green = Color(0xFF689f39);
  var darkgrey = Color(0xFF7b7c7a);
  var red = Color(0xFFf17523);


  @override
  void initState() {
    Future.microtask(()  {
    DeliveryAddressViewModel provider=Provider.of(context,listen: false);
        provider.getDefaultAddress(context);
    });

  }

  @override
  Widget build(BuildContext context) {
    DeliveryAddressViewModel provider=Provider.of(context);
    LocationViewModel location_provider=Provider.of(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(title: Text("Choose Delivery Address"),centerTitle: true,
      //   //leading: Icon(CupertinoIcons.profile_circled),
      // ),
      appBar: AppBar(toolbarHeight: 0,elevation: 0,),
      body:  Container(
        color: Colors.grey.withOpacity(0.2),
        child: Column(
          children: [
            //AppBar
            Container(
              color: green,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    GestureDetector(onTap: (){ Navigator.pop(context);},child: Container(width: 30,height: 30,child: Icon(CupertinoIcons.back,color: Colors.white,size: 30,))),
                    Text('Choose Delivery Address',style: TextStyle(color: Colors.white,fontSize: 18),),
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(CupertinoIcons.profile_circled,color: Colors.white,size: 30)),
                  ],),
                  SizedBox(height: 14,),
                  GestureDetector(
                    onTap: () {
                      //Navigator.pushNamed(context, RouteNames.route_search_location_screen,arguments: ['']);
                    },
                    child: Container(
                      height: 40,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4),
                        ),
                      ),
                      child: TextFormField(
                        onTap: ()=>Navigator.pushNamed(context, RouteNames.route_search_address_screen),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                     icon: Container(padding: EdgeInsets.fromLTRB(10,0,0,0),child: Icon(Icons.search,)),
                          hintText: "Search for area ,apartment or pin code",
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 14),

                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      location_provider.getCurrentLocation(context,null,true);
                    },
                    child:Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // color: Colors.black,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_searching,color: Colors.grey,),
                          Text("  Choose Current Location",style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                    ),
                  ),
                 // Text('${location_provider.location}'),
                //  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(padding: EdgeInsets.fromLTRB(10,10,10,15),child:
                      Text('SAVED ADDRESSES',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Colors.black.withOpacity(0.7),),)),

                      Container(padding: EdgeInsets.fromLTRB(10,10,10,15),child:
                      GestureDetector(onTap: () {
                        // Navigator.push(context, MaterialPageRoute(
                        //     builder: ((context) => AddAddressScreen()))
                        // );
                        Navigator.pushNamed(context, RouteNames.route_search_address_screen);

                        // Navigator.pushNamed(context, RouteNames.route_add_del_address_screen,arguments: '').then((value) => provider.getDefaultAddress(context));
                      }, child: Text('+ADD NEW ADDRESS', style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: red,),))),

                    ],
                  ),
                  SizedBox(height: 5,),
                ],
              ),
            ),

            SizedBox(height: 10,),
            provider.loading_address?Center(child: CircularProgressIndicator(),):
            provider.add_list==null?Container():
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.add_list==null?0:(provider.add_list as List).length,
                    itemBuilder: (context, index) {
                    var e=provider.add_list[index];
                    return Column(
                      children: [
                        SizedBox(height: 10,),

                        Container(
                          color: Colors.white,
                          width: width,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(width: 40,height: 40,child:  Radio(value:e['addr_id'], groupValue: provider.default_add,onChanged: ( value) {
                                        provider.setDefaultAddress(context,e['addr_id']);
                                      },)
                                      ),
                                      Text(e['setAddressDefault']=='1'?"Default Address: ":"Address: ",style: TextStyle(color: red,fontSize: 15),),
                                      Text('${e['nick_name']==null?'':e['nick_name']}',style: TextStyle(fontSize: 16),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap:()async{
                                          // await Navigator.pushNamed(context, RouteNames.route_add_del_address_screen,arguments: e['addr_id']).whenComplete(() => provider.getDefaultAddress(context));
                                          print('Edit Address Id:${e['addr_id']}');
                                         Navigator.pushNamed(context, RouteNames.route_search_address_screen,arguments: [e['addr_id']]);

                                        },
                                        child: Container(margin: EdgeInsets.all(10),child: Icon(CupertinoIcons.pen)),
                                      ),
                                      Text("  |  ",style: TextStyle(fontSize: 22,color: darkgrey ),),
                                      GestureDetector(
                                          onTap:(){
                                            provider.deleteAddress(context, e['addr_id']);
                                          },
                                          child: provider.loading_delete &&( provider.address_delete!=null && e['addr_id']==provider.address_delete)?CircularProgressIndicator():Container(margin: EdgeInsets.all(10),child: Icon(CupertinoIcons.delete_simple))),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                // color: Colors.blue.shade50,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                      ),
                                      Expanded(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              Text("${e['fname']} ${e['lname']}",style: TextStyle(color: Colors.grey),),
                                              Text("${e['address1']}, ${e['address2']}, ${e['area']} ${e['landmark']}, ${e['city']}, ${e['state']}- ${e['pincode']}",style: TextStyle(color: Colors.grey),maxLines: 4,),
                                              Container(width: width,child: Text("Ph: ${e['mobile']}",style: TextStyle(color: Colors.grey))),
                                            ]
                                        ),

                                      )
                                    ]
                                ),
                              ),
                              SizedBox(height: 10,)
                            ],
                          ),
                        ),
                      ],
                    );
                  },),
                )
            // SingleChildScrollView(
            //   child: Column(
            //       children:(provider.add_list as List).map((e) => Column(
            //         children: [
            //           SizedBox(height: 10,),
            //
            //           Container(
            //             color: Colors.white,
            //             width: width,
            //             child:Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Row(
            //                       children: [
            //                         Container(width: 40,height: 40,child:  Radio(value:e['addr_id'], groupValue: provider.default_add,onChanged: ( value) {
            //                           provider.setDefaultAdd(value);
            //                         },)
            //                         ),
            //                         Text(e['setAddressDefault']=='1'?"Default Address: ":"Address: ",style: TextStyle(color: red,fontSize: 15),),
            //                         Text(e['nick_name'],style: TextStyle(fontSize: 16),),
            //                       ],
            //                     ),
            //                     Row(
            //                       children: [
            //                         GestureDetector(
            //                             onTap:(){
            //                               Navigator.pushNamed(context, RouteNames.route_add_del_address_screen,arguments: e['addr_id']);
            //                             },
            //                             child: Container(margin: EdgeInsets.all(10),child: Icon(CupertinoIcons.pen)),
            //                         ),
            //                         Text("  |  ",style: TextStyle(fontSize: 22,color: darkgrey ),),
            //                         Container(margin: EdgeInsets.all(10),child: Icon(CupertinoIcons.delete_simple)),
            //                       ],
            //                     )
            //                   ],
            //                 ),
            //                 Container(
            //                   // color: Colors.blue.shade50,
            //                   child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       children: [
            //                         Container(
            //                           width: 40,
            //                         ),
            //                         Expanded(
            //                           child: Column(
            //                               mainAxisAlignment: MainAxisAlignment.start,
            //                               crossAxisAlignment: CrossAxisAlignment.start,
            //                               children:[
            //                                 Text("${e['fname']} ${e['lname']}",style: TextStyle(color: Colors.grey),),
            //                                 Text("${e['address1']}, ${e['address2']}, ${e['area']} ${e['landmark']},  ${e['landmark']}, ${e['city']},${e['state']}- ${e['pincode']}",style: TextStyle(color: Colors.grey),maxLines: 4,),
            //                                 Container(width: width,child: Text("Ph: ${e['mobile1']}",style: TextStyle(color: Colors.grey))),
            //                               ]
            //                           ),
            //
            //                         )
            //                       ]
            //                   ),
            //                 ),
            //                 SizedBox(height: 10,)
            //               ],
            //             ),
            //           ),
            //         ],
            //       )).toList()
            //
            //   ),
            // )
          ],
        ),
      ),
    );
  }


}