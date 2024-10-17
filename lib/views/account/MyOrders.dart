
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';

import '../../utils/Utils.dart';
import '../../view_models/my_order_viewmodel.dart';


class MyOrders extends StatefulWidget{
  @override
  MyOrdersState createState()=> MyOrdersState();

}

class MyOrdersState extends State<MyOrders>{

  var green = Color(0xFF689f39);
  var darkgrey = Color(0xFF7b7c7a);
  var red = Color(0xFFf17523);
  late MyOrderViewModel provider;
  int activeStep=3;
  @override
  Widget build(BuildContext context) {
    provider=Provider.of(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(color: green,width: 30,height: 30,child: Icon(CupertinoIcons.back))),
        title: Text("My Orders"),centerTitle: true,shadowColor: Colors.transparent,),
      body: Container(
        width: width,
        color: Colors.grey.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: EdgeInsets.fromLTRB(10,10,0,0),
                child: Text('Recent Orders',style: TextStyle(fontSize: 14,color: darkgrey),)),
            Expanded(
              child: ListView.builder(
                // primary: false,
                // controller: scrollController,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: provider.data_list.length,
                itemBuilder: (context, index) {
                  active=0;
                  return  GestureDetector(
                    onTap: () => provider.onOrderClick(provider.data_list[index]),
                    child: Container(
                      // height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.fromLTRB(0,5,0,5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0,2),
                          ),
                        ],
                      ),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(margin: EdgeInsets.fromLTRB(10,10,0,0),child: Image.asset('assests/images/rd_logo.png',height:40,width: 40,)),
                          Row(
                            children: [
                              Container(margin: EdgeInsets.fromLTRB(10,10,0,0),
                                  child: Text('Order no: ',
                                    style: TextStyle(fontSize: 14,color: darkgrey),)),

                              Container(margin: EdgeInsets.fromLTRB(10,10,0,0),
                                  child: Text('${provider.data_list[index]['order_no']}',
                                    style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.7)),)),
                            ],
                          ),
                          // Container(
                          //   padding: EdgeInsets.all(10),
                          //   child: SingleChildScrollView(
                          //     scrollDirection: Axis.horizontal,
                          //     child: Row(
                          //       children: [
                          //         for(int i = 0;i <10;i++)...{
                          //           Container(child: Image.asset('assests/images/apple.jpg',height: 40,)),
                          //           Container(height:30,width:2,color: Colors.grey.withOpacity(0.2),),}
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // Stepper(
                          //     // type:StepperType.horizontal,
                          //     steps:( provider.data_list[index]['delivery_steps'] as List).map((e) => Step(title: Text('${e['step']}'), content: Container(),),
                          //
                          //     ).toList()),
                          // Container(
                          //   width:MediaQuery.of(context).size.width,
                          //   child: Align(
                          //     alignment:Alignment.centerLeft,
                          //     child: EasyStepper(
                          //       fitWidth: true,
                          //       activeStep: 1,
                          //       lineStyle: LineStyle(lineWidth: 1,lineSpace: 0,),
                          //       borderThickness: 1,
                          //       // lineLength: 70,
                          //       // lineSpace: 0,
                          //       // lineType: LineType.normal,
                          //       // defaultLineColor: Colors.white,
                          //       // finishedLineColor: Colors.orange,
                          //       activeStepTextColor: Colors.black87,
                          //       finishedStepTextColor: Colors.black87,
                          //       internalPadding: 0,
                          //       showLoadingAnimation: false,
                          //       stepRadius: 8,
                          //       showStepBorder: false,
                          //       // lineDotRadius: 1.5,
                          //       steps: [
                          //         EasyStep(
                          //           customStep: CircleAvatar(
                          //             radius: 8,
                          //             backgroundColor: Colors.white,
                          //             child: CircleAvatar(
                          //               radius: 7,
                          //               backgroundColor:
                          //               activeStep >= 0 ? Colors.orange : Colors.white,
                          //             ),
                          //           ),
                          //           title: 'Waiting',
                          //         ),
                          //         EasyStep(
                          //           customStep: CircleAvatar(
                          //             radius: 8,
                          //             backgroundColor: Colors.white,
                          //             child: CircleAvatar(
                          //               radius: 7,
                          //               backgroundColor:
                          //               activeStep >= 1 ? Colors.orange : Colors.white,
                          //             ),
                          //           ),
                          //           title: 'Order Received',
                          //           topTitle: true,
                          //         ),
                          //         EasyStep(
                          //           customStep: CircleAvatar(
                          //             radius: 8,
                          //             backgroundColor: Colors.white,
                          //             child: CircleAvatar(
                          //               radius: 7,
                          //               backgroundColor:
                          //               activeStep >= 2 ? Colors.orange : Colors.white,
                          //             ),
                          //           ),
                          //           title: 'Preparing',
                          //         ),
                          //         EasyStep(
                          //           customStep: CircleAvatar(
                          //             radius: 8,
                          //             backgroundColor: Colors.white,
                          //             child: CircleAvatar(
                          //               radius: 7,
                          //               backgroundColor:
                          //               activeStep >= 3 ? Colors.orange : Colors.white,
                          //             ),
                          //           ),
                          //           title: 'On Way',
                          //           topTitle: true,
                          //         ),
                          //         EasyStep(
                          //           customStep: CircleAvatar(
                          //             radius: 8,
                          //             backgroundColor: Colors.red,
                          //             child: CircleAvatar(
                          //               radius: 7,
                          //               backgroundColor:
                          //               activeStep >= 4 ? Colors.orange : Colors.white,
                          //             ),
                          //           ),
                          //           title: 'Delivered',
                          //         ),
                          //       ],
                          //       onStepReached: (index) =>
                          //           setState(() => activeStep = index),
                          //     ),
                          //   ),
                          // ),
                          if(provider.data_list[index]['delivery_steps']!=null)...{
                            Container(
                              padding: EdgeInsets.all(10),

                              child: Row(
                                children:
                                (provider
                                    .data_list[index]['delivery_steps'] as List)
                                    .map((e) {
                                  return OrderStatusUI(
                                      '${e['step']}', '${e['status']}');
                                }).toList(),
                                // [
                                //   OrderStatusUI('Placed'),
                                //   // OrderStatusUI('In process'),
                                //   // OrderStatusUI('Packed'),
                                //   // OrderStatusUI('On the way'),
                                //   // OrderStatusUI('Delivered'),
                                // ],
                              ),
                            ),
                          },
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image.asset('assests/images/bike.png',height: 20,color: green,),
                                // SizedBox(width: 5,),
                                Text('Order Date',style: TextStyle(color: darkgrey,fontSize: 12)),
                                Expanded(
                                    child: Text('${provider.getOrderDate(index)}',style: TextStyle(
                                        color: Colors.black.withOpacity(0.7)
                                    ),textAlign: TextAlign.right,)
                                )

                              ],
                            ),
                          ),
                          Container(
                            height: 0.5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20,5,15,5),
                            //  padding: EdgeInsets.fromLTRB(10,4,10,4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //   Text('Total: ',style: TextStyle(color: darkgrey,fontSize: 15)),
                                        Text('₹ ${provider.data_list[index]['orderSummery']['totalSellingPrice']}',style: TextStyle(color: green,fontWeight: FontWeight.w800,fontSize: 15),),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Container(


                                        child: Text('${provider.data_list[index]['payment_option']??""}',style: TextStyle(color: darkgrey,fontSize: 12),)
                                    ),
                                  ],
                                ),

                                // if(provider.data_list[index]['order_payment_status']!='Paid')...{
                                //   GestureDetector(
                                //     onTap: () {
                                //       // Navigator.push(context,MaterialPageRoute(builder:(context) => Payment_Gateway()));
                                //       Navigator.pushNamed(context,
                                //           RouteNames.route_payment_options);
                                //     },
                                //     child: Container(
                                //       padding: EdgeInsets.fromLTRB(35, 8, 35, 8),
                                //       decoration: BoxDecoration(
                                //           color: red,
                                //           borderRadius: BorderRadius.all(
                                //               Radius.circular(4)
                                //           )
                                //
                                //       ),
                                //       child: Text('Pay Now', style: TextStyle(
                                //           color: Colors.white, fontSize: 14),),
                                //     ),
                                //   )
                                // }
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                },),
            ),

          ],
        ),
      ),

    );
  }

  space(double width) {
    return Container(
      width: width,
      color: darkgrey.withOpacity(0.3),
      height: 1,
    );
  }


}
int active=0;
Widget OrderStatusUI(String s,String act) {
  Widget widget= Expanded(
    child: Column(
      children: [
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(s != 'Placed')
                Expanded(child: Container(height: 1,color: Colors.grey,)),
              Icon(Icons.circle,color: active==0?Colors.green:Colors.grey,size: 12,),
              if(s != 'Delivered')
                Expanded(child: Container(height: 1,color: Colors.grey,)),

            ],
          ),
        ),

        Text(s,style: TextStyle(color: active==0?Colors.green:Colors.grey,fontSize: 10,),maxLines: 1,),


      ],
    ),
  );
  if(act=='active'){
    active=1;
  }
  return widget;
}