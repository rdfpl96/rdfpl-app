
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/res/components/app_button.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/view_models/my_order_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/order_details_viewmodel.dart';



class OrderDetScreen extends StatefulWidget {
  @override
  _OrderDetState createState() => _OrderDetState();
}

class _OrderDetState extends State<OrderDetScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController; // Declare TabController
  late int currentTab;
  @override
  void initState() {
    super.initState();
    currentTab=1;
    _tabController = TabController(
      length: 2, // Number of tabs
      vsync: this, // Use 'this' as the vsync parameter
    );
    _tabController.animation!.addListener(() {
      final value = _tabController.animation!.value.round();
      if (value != currentTab && mounted) {
        changePage(value);
      }
    });
  }
  void changePage(int newTab) {
    setState(() {
      currentTab = newTab;
    });
  }
  @override
  void dispose() {
    _tabController.dispose(); // Dispose of TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    active=0;
    OrderDetailsViewModel provider=Provider.of(context);
    var green = Color(0xFF689f39);
    var darkgrey = Color(0xFF7b7c7a);
    var red = Color(0xFFf17523);

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: green,
              child: Icon(CupertinoIcons.back),
            ),
          ),
          // backgroundColor:green,
          title: Text(
            'Order Details',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          centerTitle: true,

          bottom: TabBar(

            indicatorColor: Colors.black,
            // Indicator color (bottom line)
            labelColor: Colors.white, // Selected tab label color
            unselectedLabelColor: Colors.white60, // Unselected tab label color
            // Change TabBar background color
            labelStyle: TextStyle(// Background color of selected tab
            ),
            controller: _tabController,

            // Assign TabController to TabBar
            tabs: [

              Tab(text: 'Summary',),
              Tab(text: 'Items(1)'),
            ],

          ),
        ),
        body: Stack(
          children: [
            Container(
              color: Color(0xff8f8f8),
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController, // Assign TabController to TabBarView
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(width: width,
                        child: Column(
                          children: [
                            if(provider.checkIsSaving())...{
                              Container(
                                color: Color(0xffe7f2dd),
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center,
                                  children: [
                                    Image.asset(
                                      'assests/images/celebrate.png',
                                      height: 25,),
                                    SizedBox(width: 10,),
                                    Text('You Saved ₹${provider.getSavingAmount()} in this order',
                                      style: TextStyle(color: green),),
                                  ],
                                ),
                              ),
                            },
                            Container(
                              margin: EdgeInsets.all(10),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(margin: EdgeInsets.fromLTRB(10,10,0,0),child: Image.asset('assests/images/rd_logo.png',height:40,width: 40,)),
                                  Row(
                                    children: [
                                      Container(margin: EdgeInsets.fromLTRB(10,10,0,0),
                                          child: Text('Order no: ',
                                            style: TextStyle(fontSize: 14,color: darkgrey),)),

                                      Container(margin: EdgeInsets.fromLTRB(10,10,0,0),
                                          child: Text('${provider.data['order_no']}',
                                          style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.7)),)),
                                    ],
                                  ),
                                  Container(
                                          padding: EdgeInsets.all(10),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                for(int i = 0;i <(provider.data['order_items']==null?0:(provider.data['order_items'] as List).length);i++)...{
                                                Container(child: Image.network('${provider.data['order_items'][i]['imagepath']}',height: 40,)),
                                                Container(height:30,width:2,color: Colors.grey.withOpacity(0.2),),
                                                }
                                              ],
                                            ),
                                          ),
                                        ),
                                ],

                              ) ,
                            ),
                            TitleN('Order Status'),
                            Container(
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
                              child: Column(
                                children: [
                                  // Container(
                                  //   padding: EdgeInsets.all(10),
                                  //
                                  //   child: Row(
                                  //     children: [
                                  //        OrderStatusUI('Placed'),
                                  //       OrderStatusUI('In process'),
                                  //       OrderStatusUI('Packed'),
                                  //       OrderStatusUI('On the way'),
                                  //        OrderStatusUI('Delivered'),
                                  //     ],
                                  //   ),
                                  // ),
                                  if(provider.data['delivery_steps']!=null)...{
                                    Container(
                                      padding: EdgeInsets.all(10),

                                      child: Row(
                                        children:
                                        (provider
                                            .data['delivery_steps'] as List)
                                            .map((e) => OrderStatusUI(
                                            '${e['step']}',
                                            '${e['status']}'),)
                                            .toList(),
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
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Image.asset('assests/images/bike.png',height: 20,color: green,),
                                            // SizedBox(width: 5,),
                                            Text('Order Date',style: TextStyle(color: darkgrey,fontSize: 12)),
                                            Expanded(
                                              child: Text('${provider.data['order_date']}',style: TextStyle(
                                                color: Colors.black.withOpacity(0.7)
                                              ),textAlign: TextAlign.right,)
                                            )

                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Image.asset('assests/images/bike.png',height: 20,color: green,),
                                            // SizedBox(width: 5,),
                                            Text('Payment Status',style: TextStyle(color: darkgrey,fontSize: 12)),
                                            Expanded(
                                              child: Text('${provider.data['order_payment_status']}',style: TextStyle(
                                                color: Colors.black.withOpacity(0.7)
                                              ),textAlign: TextAlign.right,)
                                            )

                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ) ,
                            ),
                            TitleN('Quick Actions'),
                            Container(
                              margin: EdgeInsets.all(10),
                             // padding: EdgeInsets.fromLTRB(10,5,10,5),
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
                              child: Column(
                                children: [
                                  // QuickAct(Icons.calendar_month,'Change delivery slot'),
                                  QuickAct(CupertinoIcons.xmark_circle,'Cancel order'),
                                  QuickAct(Icons.help_outline,'Get help for this order'),
                                ],
                              ),
                            ),
                            TitleN('Payment Details'),
                            Container(
                              margin: EdgeInsets.all(10),
                              // padding: EdgeInsets.fromLTRB(10,5,10,5),
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
                              child: Column(
                                children: [
                                  PaymentOP('Payment options','${provider.data['payment_option']??''}',darkgrey),
                                  PaymentOP('Oder Items','${provider.data['order_items']==null?0:(provider.data['order_items']as List).length} Items',darkgrey),
                                  PaymentOP('Sub Total','₹ ${provider.data['orderSummery']['totalSellingPrice']}',darkgrey),
                                  PaymentOP('Delivery Chargers','₹ ${provider.data['delivery_charge']}',darkgrey),
                                  SizedBox(height: 10,),
                                  Container(
                                    color: Colors.grey.withOpacity(0.5),
                                    height: 1,
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10,10,10,0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total',style: TextStyle(color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w700,fontSize: 17),),
                                        Text('₹ ${provider.data['orderSummery']['totalSellingPrice']}',style: TextStyle(color: red,fontWeight: FontWeight.w600,fontSize: 17))
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,)

                                ],
                              ),
                            ),
                            TitleN('Delivery Address'),
                            Container(
                              margin: EdgeInsets.all(10),
                              // padding: EdgeInsets.fromLTRB(10,5,10,5),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Align children to the top
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        alignment: Alignment.topLeft,
                                        child: Icon(Icons.my_location,color: darkgrey,),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 13,),
                                            Text('${provider.data['address']['fname']} ${provider.data['address']['lname']}',style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 13,fontWeight: FontWeight.w600),),
                                            SizedBox(height: 2,),
                                            Text(
                                              '${provider.data['address']['apartment']}, ${provider.data['address']['room_no']}, ${provider.data['address']['area']}, ${provider.data['address']['city']}, ${provider.data['address']['landmark']}, ${provider.data['address']['pincode']}',
                                              maxLines: 2,
                                              style: TextStyle(color: darkgrey,fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Align children to the top
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        alignment: Alignment.topLeft,
                                        child: Icon(Icons.call,color: darkgrey,),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 13,),
                                            Text('${provider.data['address']['mobile']}',style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 13,fontWeight: FontWeight.w600),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            AppButton(title: 'Buy Again', onTap: () {

                            },),
                            SizedBox(height: 100,),


                          ],
                        ),
                    ),
                  ),


                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,

                  child: GroupedListView<dynamic, String>(
                    elements: provider.data['order_items'],
                    groupBy: (element) {
                      print('${element['product_name']}');
                      return element['product_name'];
                    },
                    groupSeparatorBuilder: (String groupByValue) {
                      return Container(
                        color: Colors.grey  .withOpacity(0.1),
                        child: txtbox2('$groupByValue'),
                      );
                    },
                    itemBuilder: (context, dynamic element) {
                      print("$element ______________________________________________________");
                      return GestureDetector(
                        onTap: (){
                          // Navigator.pushNamed(context, RouteNames.route_product_details,arguments: element['product_id']);
                        },
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child:
                          // Stack(
                          //   alignment: AlignmentDirectional.topEnd,
                          //   children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 120,
                                    // width: 100,
                                    child: Image.network(
                                      '${element['imagepath']}',
                                    ),
                                  ),
                                  // Container(
                                  //   margin: EdgeInsets.all(10),
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                                  //     boxShadow: [
                                  //       BoxShadow(
                                  //         color: Colors.grey.withOpacity(0.2),
                                  //         spreadRadius: 3,
                                  //         blurRadius: 5,
                                  //         offset: Offset(0,0),
                                  //       ),
                                  //     ],
                                  //   ),
                                  //   child: Container(
                                  //       padding: EdgeInsets.all(10),
                                  //
                                  //       height: 150,
                                  //       width: 150,
                                  //       decoration: BoxDecoration(
                                  //           color: Colors.white,
                                  //
                                  //           borderRadius: BorderRadius.all(Radius.circular(10))
                                  //       )
                                  //       ,child: Image.network('${provider.data['imageUrl']}${element['pro_product_img']}',)),
                                  // ),
                                  Expanded(
                                    child:
                                    Container(
                                      alignment: Alignment.topCenter,
                                      // color: red,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(width: width,child: Text('${element['product_name']}',style: TextStyle(
                                              fontSize: 12,color: Colors.grey
                                          ),)),
                                          SizedBox(height: 6,),
                                          // Container(width: width,child: Text('${element['cat_name']}',maxLines: 2,overflow: TextOverflow.ellipsis,)),
                                          // SizedBox(height: 6,),
                                          Container(
                                            width: width,
                                            child: Row(
                                              children: [
                                                Text('₹ ${element['price'] } '),
                                                // SizedBox(width: 4,),
                                                // Text('₹ 1000'),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 6,),
                                          Container(width: width,child: Text('Quantity: ${element['qty']}',maxLines: 2,overflow: TextOverflow.ellipsis,)),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: width,
                                height: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: List.generate(5, (index) {
                                      return IconButton(
                                        icon: Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onPressed: () {
                                          // Handle star rating logic here
                                          // Utils.showFlushbarError("$index", context);
                                        },
                                      );
                                    }),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle the "Write Review" button press here
                                      Navigator.pushNamed(context, RouteNames.route_rate_reviews_screen,arguments: [element]);
                                    },
                                    child: Text('Write Review'),
                                  ),
                                  SizedBox(height: 150,)
                                ],
                              ),
                            ],
                          ),

                          //   ]
                          // ),
                        ),
                      );
                    },
                    itemComparator: (item1, item2) => item1['product_name'].compareTo(item2['product_name']), // optional
                    useStickyGroupSeparators: true, // optional
                    floatingHeader: true, // optional
                    order: GroupedListOrder.ASC, // optional
                  ),)

                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white ,
                // width: width,
                alignment: Alignment.centerLeft,

                child: Column(
                  children: [

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
                                  Text('₹ ${provider.data['orderSummery']['totalSellingPrice']}',style: TextStyle(color: green,fontWeight: FontWeight.w800,fontSize: 15),),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Container(

                                  child: Text('${provider.data['payment_option']??''}',style: TextStyle(color: darkgrey,fontSize: 12),)
                              ),
                            ],
                          ),

                          // if(provider.data['order_payment_status']!=null && provider.data['order_payment_status']!='Paid')...{
                          //   GestureDetector(
                          //     onTap: (){
                          //       // Navigator.push(context,MaterialPageRoute(builder:(context) => Payment_Gateway()));
                          //       Navigator.pushNamed(context, RouteNames.route_payment_options);
                          //     },
                          //     child: Container(
                          //       padding: EdgeInsets.fromLTRB(20,10,20,10),
                          //       decoration: BoxDecoration(
                          //           color: red,
                          //           borderRadius: BorderRadius.all(
                          //               Radius.circular(4)
                          //           )
                          //
                          //       ),
                          //       child: Text('Pay Now',style: TextStyle(color: Colors.white,fontSize: 14),),
                          //     ),
                          //   )
                          // },

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
  txtbox2(String s) {

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      // color: Colors.white
    ),padding: EdgeInsets.fromLTRB(10,6,10,6),margin: EdgeInsets.all(10),child: Text(s,style: TextStyle(color: Colors.black.withOpacity(0.5))),);
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

          Text(s,style: TextStyle(color: active==0?Colors.green:Colors.grey,fontSize: 10),),


        ],
      ),
    );
   if(act=='active'){
     active=1;
   }
   return widget;
  }

  Widget QuickAct( var icon  , String s) {
    return GestureDetector(
      onTap: (){
      if(s == 'Cancel order'){
        // Navigator.push(context,MaterialPageRoute(builder: (context)=> CancelOrder()));
        Navigator.pushNamed(context, RouteNames.route_cancel_order);
      };
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(icon,color: Colors.grey,),
                  SizedBox(width: 10,),
                  Text(s,style: TextStyle(color: Colors.grey),),
                  Expanded(child: Container(alignment: Alignment.centerRight,child: Icon(CupertinoIcons.forward,color: Colors.grey,)))
                ],
              ),
            ),
            if(s != 'Get help for this order')
            Container(
             // width: 100,
              height: 1,
              color: Colors.grey.withOpacity(0.5),
            ),

          ],
        ),
      ),
    );
  }

  Widget PaymentOP(String s,String value, Color darkgrey,) {
    return Container(
      margin: EdgeInsets.fromLTRB(10,10,10,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(s,style: TextStyle(color: darkgrey)),
          Text(value,style: TextStyle(color:darkgrey))
        ],
      ),
    );
  }

  Widget TitleN(String s) {
   return Container(alignment: Alignment.centerLeft,margin: EdgeInsets.all(10),
        child: Text(s, style: TextStyle(color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w700,fontSize: 17),));
  }


}
