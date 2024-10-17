import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/res/components/add_to_cart_button.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';

import '../../view_models/product_viewmodel.dart';
import '../colors.dart';
import '../theme.dart';
import 'app_button.dart';
bool modalRefresh=false;
enum FROM{PRODUCT,WHISHLIST}
class HSaveLaterProductItem extends StatefulWidget {

  final Function onTap;
  final Function onVariantChange;

  final Function onAddToCart;
  var data;

  bool isLoadingAddToCart;
  HSaveLaterProductItem(this.data,this.isLoadingAddToCart,{required this.onTap, required this.onVariantChange, required this.onAddToCart, super.key}){

  }

  @override
  _HSaveLaterProductItemState createState() => _HSaveLaterProductItemState();
}

class _HSaveLaterProductItemState extends State<HSaveLaterProductItem> {
   Function? onRefresh;


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    if(modalRefresh &&  onRefresh!=null){
      // if(mounted) {
      //   onRefresh!(() {
      //     Utils.prinAppMessages("Product Debug: Model Manual Reshing.........");
      //   });
      // }
    }
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        margin: EdgeInsets.all(5),
        child: Column(
          children: [
            Row(

              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        //image
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1, color: Colors.grey.shade200)),
                          child: SizedBox(
                            height: 120,
                            child: Image.network(
                              '${widget.data['feature_img']}',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen, width: 0.5),
                            gradient: LinearGradient(
                                tileMode: TileMode.repeated,
                                colors: [
                                  Colors.white.withOpacity(0.10),
                                  Colors.lightGreen.withOpacity(0.10),
                                  Colors.lightGreen.withOpacity(0.30),
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Har Din Sasta!',
                                style: kSmallDarkText.copyWith(color: Colors.green.shade900),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 15,
                                color: Colors.green.shade900,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120,

                            margin: EdgeInsets.only(left: 10, top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                  Text(
                                      '${widget.data['product_name']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12,
                                          fontWeight: FontWeight.w600)),

                                Text(widget.data['product_name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kSmallLightText.copyWith(fontSize: 12)),
                                SizedBox(
                                  height: 5,
                                ),
                                InkWell(
                                  // onTap: () {
                                  //   Utils.prinAppMessages("Product Debug: Modal Open");
                                  //
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
                                  //           return VariantBottomSheet(
                                  //             widget.from,
                                  //             isLoading,
                                  //             loading_index,
                                  //             data: widget.data,
                                  //             onAddToCart: (type,_indx){
                                  //               onRefresh=modalState;
                                  //               modalRefresh=true;
                                  //
                                  //               print('add to cart data ${widget.data['items'][_indx]['qty']}');
                                  //               widget.onAddToCart(type,_indx);
                                  //
                                  //               Future.delayed(Duration(seconds: 3),() {
                                  //                   modalState((){
                                  //                     isLoading=false;
                                  //                     loading_index=-1;
                                  //                   });
                                  //               },);
                                  //             },
                                  //             onVariantChange: (variant) {
                                  //               modalState(() {
                                  //                 widget.data['items'].forEach((v) {
                                  //                   v['is_selected'] = false;
                                  //                 });
                                  //                 variant['is_selected'] = true;
                                  //                 widget.onVariantChange(variant);
                                  //               });
                                  //             },
                                  //           );
                                  //       },);
                                  //     },
                                  //
                                  //   );
                                  // },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${widget.data['pack_size']}',
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          size: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text('${widget.data['price']}',style: TextStyle(fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(widget.data==null?'₹ 0':'₹ ${widget.data['before_off_price']}',
                                        style: kSmallLightText.copyWith(fontSize: 10, decoration: TextDecoration.lineThrough)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child:AddToCartButton(
                                    isLoading: widget.isLoadingAddToCart,
                                    onTap: ( _type) {
                                      widget.onAddToCart(_type,0);
                                    },
                                    widget.data['cart_qty']==null?null:widget.data['cart_qty'].toString(),
                                    width: 120,
                                    height: 30,
                                  ),
                              ),),
                        ],
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

}


