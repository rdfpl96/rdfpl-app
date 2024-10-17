import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/view_models/payment_options_viewmodel.dart';

import '../res/components/app_button.dart';
import '../utils/routes/routes_name.dart';

class Payment_Gateway extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Payment_Gateway> {
  final ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    PaymentOptionsViewModel provider = Provider.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var green = Color(0xFF689f39);
    var darkgrey = Color(0xFF7b7c7a);
    var red = Color(0xFFf17523);

    final List<String> items = [
      "UPI Apps",
      "credit / Debit Card",
      "Net Banking"
    ];
    print(
        "Payment:${provider.list_product}"); //${provider.list_product['total_amount']}");

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  color: green,
                  child: Icon(
                    CupertinoIcons.back,
                  ))),
          backgroundColor: green,
          title: Text('Payment',
              style: TextStyle(fontSize: 16, color: Colors.white)),
          centerTitle: true,
        ),
        key: _scaffoldKey,
        body: (provider.is_loading_checkout || provider.is_loading)
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.grey.withOpacity(0.2),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('',
                                      style: TextStyle(
                                          color:
                                              Colors.black.withOpacity(0.7))),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Vouchers Available',
                                      style: TextStyle(
                                          color:
                                              Colors.black.withOpacity(0.7))),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () => provider.checkCoupons(),
                                  child: Text(
                                    'View',
                                    style: TextStyle(color: green),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Basket Value',
                                style: TextStyle(color: darkgrey),
                              ),
                              Text(
                                  '₹ ${provider.checkout_details['totalMrpPrice']}',
                                  style: TextStyle(color: darkgrey)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Charges',
                                style: TextStyle(color: darkgrey),
                              ),
                              Text(
                                  '₹ ${provider.checkout_details['shipingcharge']}',
                                  style: TextStyle(color: darkgrey))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 0.7,
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount Payable',
                                style: TextStyle(color: darkgrey),
                              ),
                              Text(
                                  '₹ ${provider.checkout_details['totalPayAmout']}',
                                  style: TextStyle(color: darkgrey))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Colors.yellow.withOpacity(0.2)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Saving',
                                  style: TextStyle(color: green),
                                ),
                                Text(
                                  '${provider.checkout_details['totalSave']}',
                                  style: TextStyle(color: green),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        width: width,
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text(
                          'Payment Options',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(context,MaterialPageRoute(builder: (context)=> ThankYou()));
                        Navigator.pushNamed(
                            context, RouteNames.route_thankyou_page);
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Theme(
                                data:
                                    ThemeData(dividerColor: Colors.transparent),
                                // Remove the border
                                child: Column(
                                  children: [
                                    ExpansionTile(
                                      title: Text(
                                        'UPI Apps',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      textColor: Colors.black,
                                      iconColor: darkgrey,
                                      initiallyExpanded: true,
                                      collapsedIconColor: darkgrey,
                                      collapsedTextColor: darkgrey,
                                      backgroundColor: Colors.transparent,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    'assests/images/gpay.png',
                                                    height: 40,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text('Google pay'),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    'assests/images/phonepe.png',
                                                    height: 40,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text('Phonepe'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 2, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Cash On Delivery',
                                      style: TextStyle(
                                          color: darkgrey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  Radio(
                                    value: PAYMENT_OPTIONS.COD,
                                    groupValue: provider.PAYMODE,
                                    onChanged: (value) {
                                      provider.changePaymentMode(value!);
                                    },
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 2, 0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Online Payment',
                                      style: TextStyle(
                                          color: darkgrey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  Radio(
                                    value: PAYMENT_OPTIONS.ONLINE,
                                    groupValue: provider.PAYMODE,
                                    onChanged: ( value) {
                                      provider.changePaymentMode(value!);

                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    provider.is_loading_checkout
                        ? CircularProgressIndicator()
                        : AppButton(
                            title: 'Continue',
                            loading: provider.is_loading,
                            onTap: () {
                              if(provider.PAYMODE==PAYMENT_OPTIONS.COD) {
                                provider.placeOrder();
                              }else{
                                provider.makePayment();
                              }
                            },
                          ),
                  ],
                ),
              ));
  }
}
