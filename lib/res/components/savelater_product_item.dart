import 'package:flutter/material.dart';
import 'package:royal_dry_fruit/res/components/add_to_cart_button.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';

import '../colors.dart';
import '../theme.dart';
import 'app_button.dart';
bool modalRefresh=false;
class SaveLaterProductItem extends StatefulWidget {
  final Function onTap;
  final Function onVariantChange;

  final Function onAddToCart;
  var data;
  bool isLoadingAddToCart;
  SaveLaterProductItem(this.data,this.isLoadingAddToCart,{required this.onTap, required this.onVariantChange, required this.onAddToCart,super.key});

  @override
  State<SaveLaterProductItem> createState() => _DashboardProductItemState();
}

class _DashboardProductItemState extends State<SaveLaterProductItem> {
  Function? onRefresh;
  @override
  Widget build(BuildContext context) {
    print('dattt:${widget.data} is loading cart:${widget.isLoadingAddToCart}');
    return Container(
      margin: EdgeInsets.all(5),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child:Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 260,
                width: 120,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior : Clip.hardEdge,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1,color: Colors.grey.shade200)
                          ),
                          child: Image.network(
                            '${widget.data['feature_img']}',
                            width: 120,
                            height: 100,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child:    AddToCartButton(
                            isLoading: widget.isLoadingAddToCart,
                            onTap: (_type) {
                              widget.onAddToCart(_type,0);
                            },
                            null,
                            width: 70,
                            height: 30,),),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('${widget.data['product_name']}',//category
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    Text('${widget.data['product_name']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kSmallLightText.copyWith(fontSize: 12)),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      // onTap: () {
                      //   showModalBottomSheet(
                      //     context: context,
                      //     elevation: 10,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(5.0),
                      //     ),
                      //     builder: (context) {
                      //       Utils.prinAppMessages("Product Debug: Builder Model *************************************************");
                      //       bool isLoading=false;
                      //       int loading_index=-1;
                      //       return StatefulBuilder(builder: (ctx, modalState) {
                      //
                      //         Utils.prinAppMessages("Product Debug: Stateful Builder");
                      //
                      //
                      //         return VariantBottomSheet(
                      //           isLoading,
                      //           loading_index,
                      //           data: widget.data,
                      //           onAddToCart: (type,_indx){
                      //             onRefresh=modalState;
                      //             modalRefresh=true;
                      //
                      //             print('add to cart data ${widget.data['items'][_indx]['qty']}');
                      //             widget.onAddToCart(type,_indx);
                      //
                      //             Future.delayed(Duration(seconds: 3),() {
                      //               modalState((){
                      //                 isLoading=false;
                      //                 loading_index=-1;
                      //               });
                      //             },);
                      //           },
                      //           onVariantChange: (variant) {
                      //             modalState(() {
                      //               widget.data['items'].forEach((v) {
                      //                 v['is_selected'] = false;
                      //               });
                      //               variant['is_selected'] = true;
                      //               widget.onVariantChange(variant);
                      //             });
                      //           },
                      //         );
                      //       },);
                      //     },
                      //   );
                      //
                      // },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          // borderRadius: BorderRadius.circular(5),
                        ), //             <--- BoxDecoration here
                        child: Row(
                          children: [
                            Text(
                            '${widget.data['pack_size']}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade700),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_drop_down,size: 15,)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text( '${widget.data['price']}',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                        SizedBox(
                          width: 5,
                        ),
                        Text(widget.data==null?'₹ 0':'₹ ${widget.data['before_off_price']}',
                            style: kSmallLightText.copyWith(
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough)),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            Positioned(bottom: 20,width: 140,
              child: Container(height: 1,color: Colors.lightGreen.shade200,),),
            Positioned(
              bottom: 0,
              height: 20,
              width: 140,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  // border: Border(
                  //   top: BorderSide(width: 1, color: kGreen), // Top border only
                  // ),
                  // color: kGreen.withOpacity(0.82),
                    gradient: LinearGradient(
                        tileMode: TileMode.repeated,
                        colors: [
                          Colors.white.withOpacity(0.10),
                          // Colors.white,
                          // Colors.lime.withOpacity(0.10),
                          Colors.lightGreen.withOpacity(0.10),
                          Colors.lightGreen.withOpacity(0.30),
                        ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Har Din Sasta!',style: kSmallDarkText.copyWith(color: Colors.green.shade900),),
                    Spacer(),
                    Icon(Icons.arrow_drop_down,size: 15,color: Colors.green.shade900,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // getSelectedVariant() {
  //   for (int i = 0; i < (widget.data['items'] as List).length; i++) {
  //     if (widget.data['items'][i]['is_selected'] == true) {
  //       return widget.data['items'][i];
  //     }
  //   }
  // }
}


class VariantBottomSheet extends StatefulWidget {
  final data;

  final Function onVariantChange;
  final Function onAddToCart;
  bool isLoading;
  int loading_index;
  VariantBottomSheet(this.isLoading,this.loading_index,{required this.data, required this.onVariantChange, required this.onAddToCart});

  @override
  State<VariantBottomSheet> createState() => _VariantBottomSheetState();
}

class _VariantBottomSheetState extends State<VariantBottomSheet> {
  @override
  Widget build(BuildContext ctx) {
    print("Sheet Refreshed isLoading:${widget.isLoading}");
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Card(
                    color: Colors.grey,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(widget.data== null ? 'https://uat.rdfpl.com/uploads/1701583681URADMOGAR_1.jpg' : '${widget.data['imagepath']}')),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${widget.data['top_cat_name']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('${widget.data['product_name']}'),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Text(
              'Choose a pack size',
              style: kSmallLightText.copyWith(fontSize: 12),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var variant = widget.data['items'][index];
                  Utils.prinAppMessages('Product DEbug Variant:${variant['variant_id']} Qty:${variant['qty']}');
                  return InkWell(
                    onTap: () {

                      widget.onVariantChange(variant);
                      // setState(() {
                      //   print('Setting state modal sheet');
                      //
                      // });
                      // Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: variant['is_selected'] == true ? Colors.green : Colors.grey.shade300, width: 1)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${variant['pack_size']} ${variant['units']}',
                                  style: kSmallLightText.copyWith(fontSize: 10),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '₹ ${variant['price']}',
                                      style: kSmallDarkText.copyWith(fontSize: 14),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '₹ ${variant['before_off_price']}',
                                      style: kSmallLightText.copyWith(fontSize: 12, decoration: TextDecoration.lineThrough),
                                    ),
                                    Container(
                                      color: kGreen,
                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${getDiscountPercent(variant)}',
                                        style: kSmallDarkText.copyWith(color: Colors.white),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          AddToCartButton(
                            isLoading: widget.isLoading && widget.loading_index==index,
                            onTap: (_type) {

                              // widget.provider.addToCart(index, _type, context);
                              print('product list Add Cart Type:$_type');
                              widget.onVariantChange(variant);
                              Future.delayed(Duration(milliseconds: 400),() {
                                widget.onAddToCart(_type,index);
                                setState(() {
                                  widget.isLoading=true;
                                  widget.loading_index=index;
                                });
                              },);

                            },
                            variant['qty'] == null ? null : '${variant['qty']}',
                            // widget.data['variants'][index]['qty']== null ? null :'${widget.data['variants'][index]['qty']}',
                            width: 120,
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: (widget.data['items'] as List).length,
              ),
            )
          ],
        ),
      ),
    );
  }

  getDiscountPercent(var variant) {
    try {
      double price = double.parse(variant['price']);
      double priceBeforeOff = double.parse(variant['before_off_price']);
      if (price > priceBeforeOff || priceBeforeOff == price) {
        return "0% Off";
      } else {
        double discount = (price / priceBeforeOff) * 100;
        return '${discount.toStringAsFixed(2)} % Off';
      }
    } catch (e) {
      print(e);
      return "0% Off";
    }
  }

}