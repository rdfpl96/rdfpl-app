import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/views/update_profile_screen.dart';

import '../../view_models/myaccount_viewmodel.dart';

class MyAccountScreen extends StatefulWidget {
  var homeProvider;
  MyAccountScreen({this.homeProvider});

  @override
  MyAccountState createState() => MyAccountState();
}

class MyAccountState extends State<MyAccountScreen> {
  var green = Color(0xFF689f39);
  var darkgrey = Color(0xFF7b7c7a);
  var red = Color(0xFFf17523);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyAccountViewModel provider = Provider.of(context);

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                color: green,
                width: 30,
                height: 30,
                child: Icon(CupertinoIcons.back))),
        title: Text("My Account"),
        centerTitle: true,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                width: width,
                color: green.withOpacity(0.5),
                height: 1,
              ),
              Container(
                color: green,
                child: Column(
                  children: [
                    Row(
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          child: SizedBox(
                            height: 70, // Increase the height
                            width: 70, // Increase the width
                            child: Image.asset('assests/images/user.png'),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: width,
                            child: provider.loading
                                ? CircularProgressIndicator()
                                : provider.data_list == null
                                    ? Container(
                                        child: Text('No Data Found'),
                                      )
                                    : Column(
                                        children: [
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '${provider.data_list['name']==null?'':provider.data_list['name']} ${provider.data_list['lname']==null?'':provider.data_list['lname']}',
                                                style: (TextStyle(
                                                    color: Colors.white)),
                                                textAlign: TextAlign.left,
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '${provider.data_list['email']==null?'':provider.data_list['email']}',
                                                style: (TextStyle(
                                                    color: Colors.white)),
                                              )),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '${provider.data_list['mobile']==null?'':provider.data_list['mobile']}',
                                                style: (TextStyle(
                                                    color: Colors.white)),
                                              )),
                                        ],
                                      ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RouteNames.route_update_profile_details,arguments:[provider.data_list,VIEW_TYPE.UPDATE]).then((value) {
                              provider.getCustomerDetails(context);
                            });
                          },
                          child: Container(
                              height: 60,
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.all(10),
                              child: Icon(
                                CupertinoIcons.pen,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // border: Border.all(
                        //     color:
                        //     Colors.black.withOpacity(0.2),
                        //     width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Container(
                        // height: 60,
                        margin: EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Container(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: Container(
                                  padding: EdgeInsets.only(left: 2, right: 2),
                                  child: SvgPicture.asset(
                                    "assests/images/navigation.svg",
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            provider.loading_address
                                ? CircularProgressIndicator()
                                : ((provider.add_list is List)
                                        ? (provider.add_list as List).isEmpty
                                        : provider.add_list == null)
                                    ? Container(
                                        child: Text('No Address Found'),
                                      )
                                    : Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${provider.add_list['address1']}, ${provider.add_list['address2']}, ${provider.add_list['area']}",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w100),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${provider.add_list['landmark']}, ${provider.add_list['city']}, ${provider.add_list['state']}, ${provider.add_list['pincode']}",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w100),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                            // (provider.add_list!=null)?
                            //   Expanded(
                            //     child: Column(
                            //       children: [
                            //         Container(alignment: Alignment.centerLeft,
                            //           child: Text(
                            //             "${provider.add_list['address1']}, ${provider.add_list['address2']}, ${provider.add_list['area']}",
                            //             style: TextStyle(
                            //                 color: Colors.grey,
                            //                 fontSize: 12,
                            //                 fontWeight: FontWeight.w100),
                            //           ),
                            //         ),
                            //         Container(
                            //           alignment: Alignment.centerLeft,
                            //           child: Text(
                            //             "${provider.add_list['landmark']}, ${provider.add_list['city']}, ${provider.add_list['state']}, ${provider.add_list['pincode']}",
                            //             style: TextStyle(
                            //                 color: Colors.grey,
                            //                 fontSize: 12,
                            //                 fontWeight: FontWeight.w100),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   )
                            // :Container(child: Text('No Address Found'),),

                            Container(
                              padding: EdgeInsets.all(4),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteNames.route_delivery_address_screen)
                                      .then((value) => provider.getCustomerDetails(context));
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: green,
                                      width: 1,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  child: Text(
                                    '  change  ',
                                    style: TextStyle(color: green),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(context,MaterialPageRoute(builder: (context)=> MyOrders()));
                  Navigator.pushNamed(
                      context, RouteNames.route_my_orders_screen);
                },
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.arrow_clockwise,
                        color: darkgrey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'My Orders',
                        style: TextStyle(color: darkgrey, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
              space(width),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.route_my_reviews_screen);
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.reviews_outlined,
                        color: darkgrey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'My Ratings & Reviews',
                        style: TextStyle(color: darkgrey, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
              space(width),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => DeliveryAddress()),
                  // );
                  Navigator.pushNamed(
                          context, RouteNames.route_delivery_address_screen)
                      .then((value) => provider.getCustomerDetails(context));
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: darkgrey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'My Delivery Address',
                        style: TextStyle(color: darkgrey, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
              space(width),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => DeliveryAddress()),
                  // );
                  Navigator.pushNamed(
                          context, RouteNames.route_offer_screen,arguments: [widget.homeProvider]);
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: darkgrey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Offers',
                        style: TextStyle(color: darkgrey, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
              space(width),
              GestureDetector(
                onTap: () => provider.logout(),
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: darkgrey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(color: darkgrey, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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
