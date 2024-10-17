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
class ProductItem extends StatefulWidget {

  final Function onTap;
  final Function onVariantChange;

  final Function onAddToCart;
  var data;
  FROM from;
  bool isLoadingAddToCart;
  ProductItem(this.from,this.data,this.isLoadingAddToCart,{required this.onTap, required this.onVariantChange, required this.onAddToCart, super.key}){

  }

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
   Function? onRefresh;
  String dummyImage = 'https://uat.rdfpl.com/uploads/1701583681URADMOGAR_1.jpg';
  String dummyCategory = 'Fresho Organic - ';
  String dummyProductName = 'Cow Ghee/Tuppa Small';

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
        margin: EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1, color: Colors.grey.shade200)),
                          child: SizedBox(
                            height: 120,
                            child: Image.network(
                              widget.data == null ? '': (widget.from==FROM.PRODUCT?'${widget.data['imagepath']}':'${widget.data['feature_img']}'),
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
                                if(widget.from==FROM.PRODUCT)...{
                                  Text(widget.data == null
                                      ? dummyCategory
                                      : '${widget.data['top_cat_name']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                },
                                Text(widget.data == null ? dummyProductName : widget.data['product_name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kSmallLightText.copyWith(fontSize: 12)),
                                SizedBox(
                                  height: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    Utils.prinAppMessages("Product Debug: Modal Open");

                                    showModalBottomSheet(
                                      context: context,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      builder: (context) {
                                        Utils.prinAppMessages("Product Debug: Builder Model *************************************************");
                                        bool isLoading=false;
                                        int loading_index=-1;
                                        return StatefulBuilder(builder: (ctx, modalState) {

                                          Utils.prinAppMessages("Product Debug: Stateful Builder");


                                            return VariantBottomSheet(
                                              widget.from,
                                              isLoading,
                                              loading_index,
                                              data: widget.data,
                                              onAddToCart: (type,_indx){
                                                onRefresh=modalState;
                                                modalRefresh=true;

                                                print('add to cart data ${widget.data['items'][_indx]['qty']}');
                                                widget.onAddToCart(type,_indx);

                                                Future.delayed(Duration(seconds: 3),() {
                                                    modalState((){
                                                      isLoading=false;
                                                      loading_index=-1;
                                                    });
                                                },);
                                              },
                                              onVariantChange: (variant) {
                                                modalState(() {
                                                  widget.data['items'].forEach((v) {
                                                    v['is_selected'] = false;
                                                  });
                                                  variant['is_selected'] = true;
                                                  widget.onVariantChange(variant);
                                                });
                                              },
                                            );
                                        },);
                                      },

                                    );
                                  },
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
                                          "${getSelectedVariant()['pack_size']} ${getSelectedVariant()['units']}",
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
                                    Text('₹ ${getSelectedPrice()}', style: TextStyle(fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('₹ ${getSelectedVariant()['before_off_price']}',
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
                                    onTap: (_type) {
                                      widget.onAddToCart(_type,0);
                                    },
                                    getSelectedVariant()['qty'] == null ? null : '${getSelectedVariant()['qty']}',
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

  getSelectedPrice() {
    for (int i = 0; i < (widget.data['items'] as List).length; i++) {
      if (widget.data['items'][i]['is_selected'] == true) {
        return widget.data['items'][i]['price'];
      }
    }
  }

  getSelectedVariant() {
    for (int i = 0; i < (widget.data['items'] as List).length; i++) {
      if (widget.data['items'][i]['is_selected'] == true) {
        return widget.data['items'][i];
      }
    }
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

class VariantBottomSheet extends StatefulWidget {
  final data;

  final Function onVariantChange;
  final Function onAddToCart;
  bool isLoading;
  int loading_index;
  FROM from;
  VariantBottomSheet(this.from,this.isLoading,this.loading_index,{required this.data, required this.onVariantChange, required this.onAddToCart});

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

                        child: Image.network(
                          widget.data == null ? '': (widget.from==FROM.PRODUCT?'${widget.data['imagepath']}':'${widget.data['feature_img']}'),
                        )),
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
                        if(widget.from==FROM.PRODUCT)...{
                          Text(
                            '${widget.data['top_cat_name']}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500),
                          ),
                        },
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


///////////////New Code
// class ProductItem extends StatefulWidget {
//
//   final Function onTap;
//   final Function onVariantChange;
//   late Function onRefresh;
//   final Function onAddToCart;
//   int index;
//   ProductItem(this.index,{required this.onTap, required this.onVariantChange, required this.onAddToCart, super.key}){
//
//   }
//
//   @override
//   _ProductItemState createState() => _ProductItemState();
// }
//
// class _ProductItemState extends State<ProductItem> {
//   var data;
//   String dummyImage = 'https://uat.rdfpl.com/uploads/1701583681URADMOGAR_1.jpg';
//   String dummyCategory = 'Fresho Organic - ';
//   String dummyProductName = 'Cow Ghee/Tuppa Small';
//
//   @override
//   void initState() {
//     super.initState();
//     ProductViewModel provider=Provider.of(context,listen: false);
//     data=provider.data_list[widget.index];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         widget.onTap();
//       },
//       child: Container(
//         margin: EdgeInsets.all(5),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     child: Column(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(left: 5),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               border: Border.all(width: 1, color: Colors.grey.shade200)),
//                           child: SizedBox(
//                             height: 120,
//                             child: Image.network(
//                               data == null ? dummyImage : '${data['imageUrl']}${data['image1']}',
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.lightGreen, width: 0.5),
//                             gradient: LinearGradient(
//                                 tileMode: TileMode.repeated,
//                                 colors: [
//                                   Colors.white.withOpacity(0.10),
//                                   Colors.lightGreen.withOpacity(0.10),
//                                   Colors.lightGreen.withOpacity(0.30),
//                                 ],
//                                 begin: Alignment.bottomLeft,
//                                 end: Alignment.topRight),
//                             borderRadius: BorderRadius.all(Radius.circular(5)),
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Har Din Sasta!',
//                                 style: kSmallDarkText.copyWith(color: Colors.green.shade900),
//                               ),
//                               Spacer(),
//                               Icon(
//                                 Icons.arrow_drop_down,
//                                 size: 15,
//                                 color: Colors.green.shade900,
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                     flex: 2,
//                     child: Container(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             height: 120,
//                             margin: EdgeInsets.only(left: 10, top: 5),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(data == null ? dummyCategory : '${data['category']}',
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
//                                 Text(data == null ? dummyProductName : data['product_name'],
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: kSmallLightText.copyWith(fontSize: 12)),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     showModalBottomSheet(
//                                       context: context,
//                                       elevation: 10,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                       ),
//                                       builder: (context) {
//                                         return StatefulBuilder(builder: (context, modalState) {
//                                           widget.onRefresh=modalState;
//                                           return VariantBottomSheet(
//                                             data: data,
//                                             onAddToCart: (type){
//                                               print('add to cart data ${data['variants'][0]['qty']}');
//                                               widget.onAddToCart(type);
//                                             },
//                                             onVariantChange: (variant) {
//                                               modalState(() {
//                                                 data['variants'].forEach((v) {
//                                                   v['is_selected'] = false;
//                                                 });
//                                                 variant['is_selected'] = true;
//                                                 widget.onVariantChange(variant);
//                                               });
//                                             },
//                                           );
//                                         },);
//                                       },
//                                       // builder: (BuildContext context) {
//                                       //   return VariantBottomSheet(
//                                       //     data: data,
//                                       //     onAddToCart: (type){
//                                       //       widget.onAddToCart(type);
//                                       //     },
//                                       //     onVariantChange: (variant) {
//                                       //       setState(() {
//                                       //         data['variants'].forEach((v) {
//                                       //           v['is_selected'] = false;
//                                       //         });
//                                       //         variant['is_selected'] = true;
//                                       //         widget.onVariantChange(variant);
//                                       //       });
//                                       //     },
//                                       //   );
//                                       // },
//                                     );
//                                   },
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 10),
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.grey.shade300),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           "${getSelectedVariant()['pack_size']} ${getSelectedVariant()['units']}",
//                                           style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
//                                         ),
//                                         Spacer(),
//                                         Icon(
//                                           Icons.arrow_drop_down,
//                                           size: 15,
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text('₹ ${getSelectedPrice()}', style: TextStyle(fontWeight: FontWeight.w900)),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text('₹ ${getSelectedVariant()['before_off_price']}',
//                                         style: kSmallLightText.copyWith(fontSize: 10, decoration: TextDecoration.lineThrough)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Padding(
//                               padding: EdgeInsets.only(left: 10),
//                               child: Align(
//                                   alignment: Alignment.centerRight,
//                                   child: AddToCartButton('1', width: 90, height: 30, onTap: widget.onAddToCart)))
//                         ],
//                       ),
//                     ))
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               height: 1,
//               color: Colors.grey.shade300,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   getSelectedPrice() {
//     for (int i = 0; i < (data['variants'] as List).length; i++) {
//       if (data['variants'][i]['is_selected'] == true) {
//         return data['variants'][i]['price'];
//       }
//     }
//   }
//
//   getSelectedVariant() {
//     for (int i = 0; i < (data['variants'] as List).length; i++) {
//       if (data['variants'][i]['is_selected'] == true) {
//         return data['variants'][i];
//       }
//     }
//   }
//
//   getDiscountPercent(var variant) {
//     try {
//       double price = double.parse(variant['price']);
//       double priceBeforeOff = double.parse(variant['before_off_price']);
//       if (price > priceBeforeOff || priceBeforeOff == price) {
//         return "0% Off";
//       } else {
//         double discount = (price / priceBeforeOff) * 100;
//         return '${discount.toStringAsFixed(2)} % Off';
//       }
//     } catch (e) {
//       print(e);
//       return "0% Off";
//     }
//   }
// }
//
// class VariantBottomSheet extends StatefulWidget {
//   final data;
//   int index;
//   final Function onVariantChange;
//   final Function onAddToCart;
//
//   VariantBottomSheet({required this.index,required this.data, required this.onVariantChange, required this.onAddToCart});
//
//   @override
//   State<VariantBottomSheet> createState() => _VariantBottomSheetState();
// }
//
// class _VariantBottomSheetState extends State<VariantBottomSheet> {
//   @override
//   Widget build(BuildContext context) {
//     ProductViewModel provider=Provider.of(context);
//     return Container(
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 SizedBox(
//                   width: 100,
//                   height: 100,
//                   child: Card(
//                     color: Colors.grey,
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.network(widget.data == null ? 'https://uat.rdfpl.com/uploads/1701583681URADMOGAR_1.jpg' : '${widget.data['imageUrl']}${widget.data['image1']}')),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     height: 100,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Text(
//                           '${widget.data['category']}',
//                           style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text('${widget.data['product_name']}'),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Divider(),
//             Text(
//               'Choose a pack size',
//               style: kSmallLightText.copyWith(fontSize: 12),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemBuilder: (context, index) {
//                   var variant = widget.data['variants'][index];
//                   return InkWell(
//                     onTap: () {
//                       widget.onVariantChange(variant);
//                       setState(() {
//                         print('Setting state modal sheet');
//
//                       });
//                       // Navigator.pop(context);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       margin: EdgeInsets.symmetric(vertical: 5),
//                       decoration: BoxDecoration(
//                           border: Border.all(color: variant['is_selected'] == true ? Colors.green : Colors.grey.shade300, width: 1)),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '${variant['pack_size']} ${variant['units']}',
//                                   style: kSmallLightText.copyWith(fontSize: 10),
//                                 ),
//                                 SizedBox(
//                                   height: 7,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       '₹ ${variant['price']}',
//                                       style: kSmallDarkText.copyWith(fontSize: 14),
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text(
//                                       '₹ ${variant['before_off_price']}',
//                                       style: kSmallLightText.copyWith(fontSize: 12, decoration: TextDecoration.lineThrough),
//                                     ),
//                                     Container(
//                                       color: kGreen,
//                                       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                                       margin: EdgeInsets.only(left: 10),
//                                       child: Text(
//                                         '${getDiscountPercent(variant)}',
//                                         style: kSmallDarkText.copyWith(color: Colors.white),
//                                       ),
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                           AddToCartButton(
//                             onTap: (type) {
//                               print('product list Add Cart Type:$type');
//                               widget.onAddToCart(type);
//                               setState(() {
//
//                               });
//                             },
//                             variant['qty'] == null ? null : '${variant['qty']}',
//                             width: 120,
//                             height: 30,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 itemCount: (widget.data['variants'] as List).length,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   getDiscountPercent(var variant) {
//     try {
//       double price = double.parse(variant['price']);
//       double priceBeforeOff = double.parse(variant['before_off_price']);
//       if (price > priceBeforeOff || priceBeforeOff == price) {
//         return "0% Off";
//       } else {
//         double discount = (price / priceBeforeOff) * 100;
//         return '${discount.toStringAsFixed(2)} % Off';
//       }
//     } catch (e) {
//       print(e);
//       return "0% Off";
//     }
//   }
//
// }

//////////End

// import 'package:flutter/material.dart';
// import 'package:royal_dry_fruit/res/components/add_to_cart_button.dart';
//
// import '../colors.dart';
// import '../theme.dart';
// import 'app_button.dart';
//
// class ProductItem extends StatelessWidget {
//   var data;
//   Function onTap;
//   Function onVariantChange;
//   Function onAddToCart;
//   ProductItem(this.data, {required this.onTap,required this.onVariantChange,required this.onAddToCart,super.key});
//   String dummy_image='https://uat.rdfpl.com/uploads/1701583681URADMOGAR_1.jpg';
//   String dummy_category='Fresho Organic - ';
//   String dummy_product_name='Cow Ghee/Tuppa Small';
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         onTap();
//       },
//       child: Container(
//         margin: EdgeInsets.all(5),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//
//                     child: Column(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(left: 5),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               border: Border.all(
//                                   width: 1, color: Colors.grey.shade200)),
//                           child: SizedBox(
//                             height: 120,
//                             child: Image.network(
//                               data==null?dummy_image:'${data['imageUrl']}${data['image1']}',
//                               // width: 120,
//                               // height: 120,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           padding:
//                               EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//                           decoration: BoxDecoration(
//                             border:
//                                 Border.all(color: Colors.lightGreen, width: 0.5),
//                             // color: kGreen.withOpacity(0.82),
//                             gradient: LinearGradient(
//                                 tileMode: TileMode.repeated,
//                                 colors: [
//                                   Colors.white.withOpacity(0.10),
//                                   // Colors.white,
//                                   // Colors.lime.withOpacity(0.10),
//                                   Colors.lightGreen.withOpacity(0.10),
//                                   Colors.lightGreen.withOpacity(0.30),
//                                 ],
//                                 begin: Alignment.bottomLeft,
//                                 end: Alignment.topRight),
//                             borderRadius: BorderRadius.all(Radius.circular(5)),
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Har Din Sasta!',
//                                 style: kSmallDarkText.copyWith(
//                                     color: Colors.green.shade900),
//                               ),
//                               Spacer(),
//                               Icon(
//                                 Icons.arrow_drop_down,
//                                 size: 15,
//                                 color: Colors.green.shade900,
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//
//                     flex: 2,
//                     child: Container(
//
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             height: 120,
//                             margin: EdgeInsets.only(left: 10, top: 5),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               // mainAxisSize: MainAxisSize.max,
//                               // mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text(data==null?dummy_category:'${data['category']}',
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         fontSize: 12, fontWeight: FontWeight.w600)),
//                                 Text(data==null?dummy_product_name:data['product_name'],
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: kSmallLightText.copyWith(fontSize: 12)),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     showModalBottomSheet(
//                                       context: context,
//                                       // color is applied to main screen when modal bottom screen is displayed
//                                       // barrierColor: Colors.grey,
//
//                                       //background color for modal bottom screen
//                                       // backgroundColor: Colors.yellow,
//                                       //elevates modal bottom screen
//                                       elevation: 10,
//                                       // gives rounded corner to modal bottom screen
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                       ),
//                                       builder: (BuildContext context) {
//                                         // UDE : SizedBox instead of Container for whitespaces
//                                         return Container(
//                                           child: Padding(
//                                             padding: EdgeInsets.symmetric(
//                                                 vertical: 15, horizontal: 20),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     SizedBox(
//                                                       width: 100,
//                                                       height: 100,
//                                                       child: Card(
//                                                         color: Colors.grey,
//                                                         elevation: 5,
//                                                         shape:
//                                                             RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             10)),
//                                                         child: ClipRRect(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(10),
//                                                             child: Image.network(
//                                                                 data==null?dummy_image:'${data['imageUrl']}${data['image1']}')),
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       width: 10,
//                                                     ),
//                                                     Expanded(
//                                                       child: Container(
//                                                         width: double.infinity,
//                                                         height: 100,
//                                                         // color: Colors.red,
//                                                         child: Column(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .stretch,
//                                                           mainAxisSize:
//                                                               MainAxisSize.max,
//                                                           children: [
//                                                             Text(
//                                                               '${data['category']}',
//                                                               style: TextStyle(
//                                                                   fontSize: 12,
//                                                                   color: Colors.grey
//                                                                       .shade500),
//                                                             ),
//                                                             SizedBox(
//                                                               height: 5,
//                                                             ),
//                                                             Text(
//                                                                 '${data['product_name']}'),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                                 SizedBox(
//                                                   height: 10,
//                                                 ),
//                                                 Divider(),
//                                                 Text(
//                                                   'Choose a pack size',
//                                                   style: kSmallLightText.copyWith(
//                                                       fontSize: 12),
//                                                 ),
//                                                 Expanded(
//                                                   child: ListView.builder(
//                                                     itemBuilder: (context, index) {
//                                                       return InkWell(
//                                                         onTap: () {
//                                                           print('product list variant change');
//                                                           onVariantChange(data['variants'][index]);
//                                                         },
//                                                         child: Container(
//                                                           padding: EdgeInsets.all(10),
//                                                           margin:
//                                                               EdgeInsets.symmetric(
//                                                                   vertical: 5),
//                                                           decoration: BoxDecoration(
//                                                               border: Border.all(
//                                                                   color: data['variants'][index]['is_selected']==true?
//                                                                   Colors.green:Colors
//                                                                       .grey.shade300,
//                                                                   width: 1)),
//                                                           child: Row(
//                                                             children: [
//                                                               Expanded(
//                                                                 child: Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Text(
//                                                                       '${data['variants'][index]['pack_size']} ${data['variants'][index]['units']}',
//                                                                       style: kSmallLightText
//                                                                           .copyWith(
//                                                                               fontSize:
//                                                                                   10),
//                                                                     ),
//                                                                     SizedBox(
//                                                                       height: 7,
//                                                                     ),
//                                                                     Row(
//                                                                       children: [
//                                                                         Text(
//                                                                           '₹ ${data['variants'][index]['price']}',
//                                                                           style: kSmallDarkText
//                                                                               .copyWith(
//                                                                                   fontSize:
//                                                                                       14),
//                                                                         ),
//                                                                         SizedBox(
//                                                                           width: 5,
//                                                                         ),
//                                                                         Text(
//                                                                           '₹ ${data['variants'][index]['before_off_price']}',
//                                                                           style: kSmallLightText.copyWith(
//                                                                               fontSize:
//                                                                                   12,
//                                                                               decoration:
//                                                                                   TextDecoration
//                                                                                       .lineThrough),
//                                                                         ),
//                                                                         Container(
//                                                                           // width: 70,
//                                                                           color: kGreen,
//                                                                           padding: EdgeInsets
//                                                                               .symmetric(
//                                                                                   horizontal:
//                                                                                       5,
//                                                                                   vertical:
//                                                                                       3),
//                                                                           margin: EdgeInsets
//                                                                               .only(
//                                                                                   left:
//                                                                                       10),
//                                                                           child: Text(
//                                                                             overflow: TextOverflow.fade,
//                                                                             '${getDiscountPercent(data['variants'][index])}',
//                                                                             style: kSmallDarkText
//                                                                                 .copyWith(
//                                                                                     color:
//                                                                                         Colors.white),
//                                                                           ),
//                                                                         )
//                                                                       ],
//                                                                     )
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               // Spacer(),
//                                                               AddToCartButton(
//                                                                 onTap: (type){
//                                                                   print('product list Add Cart Type:$type');
//                                                                   onAddToCart(type);
//                                                                 },
//                                                                 data['variants'][index]['qty']==null?null:'${data['variants'][index]['qty']}',
//                                                                 width: 120,
//                                                                 height: 30,
//                                                               ),
//                                                               // ElevatedButton(
//                                                               //   style:
//                                                               //       ElevatedButton.styleFrom(
//                                                               //     backgroundColor:
//                                                               //         kButtonColor,
//                                                               //   ),
//                                                               //   onPressed: () {},
//                                                               //   child: Text(
//                                                               //     'Add',
//                                                               //     style: TextStyle(
//                                                               //         fontSize: 12,
//                                                               //         color: Colors.white),
//                                                               //   ),
//                                                               // ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       );
//                                                     },
//                                                     itemCount: (data['variants']as List).length,
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   },
//                                   child: Container(
//                                     margin: EdgeInsets.only(right: 10),
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5, vertical: 2),
//                                     decoration: BoxDecoration(
//                                       border:
//                                           Border.all(color: Colors.grey.shade300),
//                                       // borderRadius: BorderRadius.circular(5),
//                                     ),
//                                     //             <--- BoxDecoration here
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           "${getSelectedVariant()['pack_size']} ${getSelectedVariant()['units']}",
//                                           style: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.grey.shade700),
//                                         ),
//                                         Spacer(),
//                                         Icon(
//                                           Icons.arrow_drop_down,
//                                           size: 15,
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text('₹ ${getSelectedPrice()}',
//                                         style:
//                                             TextStyle(fontWeight: FontWeight.w900)),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text('₹ ${getSelectedVariant()['before_off_price']}',
//                                         style: kSmallLightText.copyWith(
//                                             fontSize: 10,
//                                             decoration:
//                                                 TextDecoration.lineThrough)),
//                                   ],
//                                 ),
//                                 //Spacer(),
//
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Padding(
//                               padding: EdgeInsets.only(left: 10),
//                               child: Align(
//                                   alignment:Alignment.centerRight,child: AddToCartButton('1', width: 90, height: 30)))
//                         ],
//                       ),
//                     ))
//               ],
//             ),
//             SizedBox(height: 20,),
//             Container(height: 1,color: Colors.grey.shade300,),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   getSelectedPrice() {
//     for(int i=0;i<(data['variants']as List).length;i++){
//       if(data['variants'][i]['is_selected']==true){
//         return data['variants'][i]['price'];
//       }
//     }
//   }
//   getSelectedVariant() {
//     for(int i=0;i<(data['variants']as List).length;i++){
//       if(data['variants'][i]['is_selected']==true){
//         return data['variants'][i];
//       }
//     }
//   }
//
//   getDiscountPercent(var variant) {
//     try{
//       double price=double.parse(variant['price']);
//       double price_before_off=double.parse(variant['before_off_price']);
//       if(price>price_before_off || price_before_off==price){
//         return "0% Off";
//       }else{
//         double discount=(price/price_before_off)*100;
//         // return '${discount} % Off';
//         return '${discount.toStringAsFixed(2)} % Off';
//       }
//     }catch(e){
//       print(e);
//     }
//   }
// }
