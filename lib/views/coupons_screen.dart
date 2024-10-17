import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/res/colors.dart';
import 'package:royal_dry_fruit/view_models/coupons_viewModel.dart';
import 'package:royal_dry_fruit/view_models/payment_options_viewmodel.dart';

import '../res/components/app_button.dart';
import '../utils/routes/routes_name.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    CouponsViewModel provider = Provider.of(context);

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
        title: Text('Coupons',
            style: TextStyle(fontSize: 16, color: Colors.white)),
        centerTitle: true,
      ),
      key: _scaffoldKey,
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          color: Colors.grey.withOpacity(0.2),
          child: Column(children: [
            TextFormField(
              controller: provider.tec_coupon,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                hintText: 'Enter Coupon',
                // border: InputBorder.none,
                hintStyle: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.5)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            AppButton(
              title: 'Apply Coupon',
              loading: provider.is_loading,
              onTap: () {
                provider.applyCoupon();
              },
            ),
            SizedBox(height: 10,),
            Expanded(child: provider.is_loading_data?Center(child: CircularProgressIndicator(),):ListView.builder(
              itemCount: provider.list_coupons.length,
              itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${provider.list_coupons[index]['coupon_code']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),),
                      Text('${provider.list_coupons[index]['description']==null?'':provider.list_coupons[index]['description']}',
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                      Row(
                        children: [
                          Text('${provider.list_coupons[index]['expiry_date']==null?'':provider.list_coupons[index]['expiry_date']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500
                            ),),
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:kButtonColor),
                            onPressed: () {
                              provider.tec_coupon.text=provider.list_coupons[index]['coupon_code'];
                              provider.applyCoupon();
                            }, child: Text('Apply'),),

                        ],
                      ),
                    ],
                  ),
                ),
              );
            },))
          ])),
    );
  }
}
