
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/res/components/add_to_cart_button.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/views/product_detail_screen.dart';

import '../res/components/savelater_product_item.dart';
import '../res/theme.dart';
import '../view_models/basket_viewmodel.dart';


class BasketScreen extends StatefulWidget {

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<BasketScreen> {

  final ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    // BasketViewModel provider=Provider.of(context,listen: false);
    // provider.getBasketList(context);
    Future.microtask(() {
      Provider.of<BasketViewModel>(context, listen: false).getBasketList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    BasketViewModel provider=Provider.of(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var green = Color(0xFF689f39);
    var darkgrey = Color(0xFF7b7c7a);
    var red = Color(0xFFf17523);

    Utils.prinAppMessages('Size:${provider.data_list.length} loading:${provider.loading_delete_from_cart}');
    Utils.prinAppMessages('Prod Details:${provider.PRODUCT_DET} loading:${provider.loading}');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(onTap: (){Navigator.pop(context);},child: Container(color: green,child: Icon(CupertinoIcons.back,))),
        backgroundColor: green,
        title: Text('Review Basket',style: TextStyle(fontSize: 16,color: Colors.white)),
        centerTitle: true,
        actions: [
          // Container(color: green,padding: EdgeInsets.fromLTRB(20,0,20,0),child: Icon(Icons.search)),
        ],
      ),
      body: provider.loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 50), // Adjust this padding if needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GroupedListView<dynamic, String>(
                    shrinkWrap: true, // Makes sure the list wraps its content
                    physics: NeverScrollableScrollPhysics(), // Prevents the list from scrolling independently
                    elements: provider.data_list,
                    groupBy: (element) => element['product_name'],
                    groupSeparatorBuilder: (String groupByValue) {
                      return Container(
                        color: Colors.grey.withOpacity(0.1),
                        child: txtbox2('$groupByValue'),
                      );
                    },
                    itemBuilder: (context, dynamic element) => GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.route_product_details,
                          arguments: element['product_id'],
                        );
                      },
                      child: Slidable(
                        key: ValueKey(element['product_id']),
                        endActionPane: ActionPane(
                          extentRatio: 0.35,
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              backgroundColor: Color(0xFF0392CF),
                              foregroundColor: Colors.white,
                              icon: Icons.bookmark_add_outlined,
                              label: 'Save For Later',
                              onPressed: (BuildContext context) {
                                provider.addSaveForLater(context, element);
                              },
                            ),
                          ],
                        ),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.2),
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          height: 110,
                                          width: 110,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          child: Image.network('${element['feature_img']}'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${element['product_name']}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                            SizedBox(height: 6),
                                            Text('${element['pack_size']}'),
                                            SizedBox(height: 6),
                                            // Text('₹ ${provider.getProductTotal(element)}'),
                                            Row(
                                              children: [
                                                Text('₹ ${provider.getProductTotal(element)}', style: TextStyle(fontWeight: FontWeight.w900)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('₹ ${element['before_off_price']}',
                                                    style: kSmallLightText.copyWith(fontSize: 10, decoration: TextDecoration.lineThrough)),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            Row(
                                              children: [
                                                AddToCartButton(
                                                  "${element['cart_qty']}",
                                                  isLoading: provider.PRODUCT_DET != null &&
                                                      provider.PRODUCT_DET['product_id'] == element['product_id'] &&
                                                      provider.PRODUCT_DET['variant_id'] == element['variant_id'] &&
                                                      provider.loading_add_to_cart,
                                                  width: 130,
                                                  height: 35,
                                                  onTap: (type) {
                                                    provider.addToCart(type, element, context);
                                                  },
                                                ),
                                                IconButton(
                                                  onPressed: () => provider.deleteFromCart(element, context),
                                                  icon: Icon(Icons.delete),
                                                ),
                                              ],
                                            ),
                                            if ((provider.loading_delete_from_cart &&
                                                provider.CART_ID != null &&
                                                provider.CART_ID == element['cart_id']) ||
                                                (provider.PRODUCT_DET != null &&
                                                    element['product_id'] == provider.PRODUCT_DET['product_id'] &&
                                                    provider.loading_add_to_cart)) ...{
                                              Container(
                                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                                child: Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              ),
                                            },
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.black.withOpacity(0.2),
                                  )
                                ],
                              ),
                              if (provider.loading_save_later &&
                                  provider.SAVE_LATER != null &&
                                  provider.SAVE_LATER['cart_id'] == element['cart_id']) ...{
                                Container(
                                  height: 150,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              }
                            ],
                          ),
                        ),
                      ),
                    ),
                    itemComparator: (item1, item2) =>
                        item1['product_name'].compareTo(item2['product_name']),
                    useStickyGroupSeparators: true,
                    floatingHeader: true,
                    order: GroupedListOrder.ASC,
                  ),
                  SizedBox(height: 20), // Add some space between the list and the "Save Later" section
                  // if(provider.save_later_list!=null && provider.save_later_list.length>0)...{
                    Padding(padding:EdgeInsets.only(left: 20,right: 20),child: Row(
                      children: [
                        Text('Save Later'),
                        Spacer(),
                        TextButton(onPressed: () {
                          Navigator.pushNamed(context, RouteNames.route_save_later_screen,arguments: [provider.save_later_list]).then((value) => provider.getBasketList(context));
                        }, child: Text(
                          'View All',
                        ))
                      ],
                    )),
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          // return Card(
                          //   color: Colors.red,
                          //   child: Container(
                          //     width: 100,
                          //     height: 250,
                          //   ),
                          // );
                          return SaveLaterProductItem(provider.save_later_list[index],
                            (provider.SAVE_LATER!=null && provider
                                .save_later_list[index]['save_id']==provider.SAVE_LATER['save_id'] &&
                                provider.loading_save_later),
                            onTap: (){

                            },
                            onVariantChange:(_variant){
                              //provider.setSelectedVarient(index,_variant,prod_type: 'S');
                            } ,
                            onAddToCart: (_type,_indx){
                              provider.moveToCart(context,provider.save_later_list[index]);
                            },);
                        },
                        itemCount: provider.save_later_list.length,
                      ),
                    ),
                    SizedBox(height: 50),
                  // },

                  // Add any additional widgets for the "Save Later" section here
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: provider.data_list==null || provider.data_list.isEmpty?
                Container():
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    height: 0.5,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 4),
                    color: Colors.black.withOpacity(0.2),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 15, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Total: ', style: TextStyle(color: Colors.grey, fontSize: 15)),
                                Text('₹ ${provider.DATA['subTotal']}', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                              ],
                            ),
                            Container(
                              color: Colors.red.withOpacity(0.1),
                              padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                              child: Text('Saved ₹ ${provider.DATA['total_save']}', style: TextStyle(color: Colors.red, fontSize: 10)),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.route_delivery_options,
                              arguments: [provider.data_list, provider.DATA],
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
      // SafeArea(
      //     child:  provider.loading?Center(
      //       child: Center(child: CircularProgressIndicator()),
      //     ):Stack(
      //       children: [
      //         Container(
      //           height: height,
      //           child: Stack(
      //             children: [
      //               Padding(
      //                 padding: EdgeInsets.only(bottom: 50),
      //                 child: Column(
      //                   children: [
      //                     GroupedListView<dynamic, String>(
      //                       elements: provider.data_list,
      //                       // groupBy: (element) => element['variant']['childCat_name'],
      //                       groupBy: (element) => element['product_name'],
      //                       groupSeparatorBuilder: (String groupByValue) {
      //                         return Container(
      //                           color: Colors.grey  .withOpacity(0.1),
      //                           child: Row(
      //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                             children: [
      //                               txtbox2('$groupByValue'),
      //                               // txtbox2('1 Item'),
      //                             ],
      //                           ),
      //                         );
      //                       },
      //                       itemBuilder: (context, dynamic element) => GestureDetector(
      //                         onTap: (){
      //                           Navigator.pushNamed(context, RouteNames.route_product_details,arguments: element['product_id']);
      //                         },
      //                         child: Slidable(
      //                           key: const ValueKey(0),
      //
      //                           // The start action pane is the one at the left or the top side.
      //                           // startActionPane: ActionPane(
      //                           //   // A motion is a widget used to control how the pane animates.
      //                           //   motion: const ScrollMotion(),
      //                           //
      //                           //   // A pane can dismiss the Slidable.
      //                           //   dismissible: DismissiblePane(onDismissed: () {}),
      //                           //
      //                           //   // All actions are defined in the children parameter.
      //                           //   children:  [
      //                           //     // A SlidableAction can have an icon and/or a label.
      //                           //     SlidableAction(
      //                           //       // onPressed: doNothing,
      //                           //       onPressed: (BuildContext context) {
      //                           //
      //                           //       },
      //                           //       backgroundColor: Color(0xFFFE4A49),
      //                           //       foregroundColor: Colors.white,
      //                           //       icon: Icons.delete,
      //                           //       label: 'Delete',
      //                           //     ),
      //                           //     SlidableAction(
      //                           //       // onPressed: doNothing,
      //                           //       onPressed: (BuildContext context) {
      //                           //
      //                           //       },
      //                           //       backgroundColor: Color(0xFF21B7CA),
      //                           //       foregroundColor: Colors.white,
      //                           //       icon: Icons.share,
      //                           //       label: 'Share',
      //                           //     ),
      //                           //   ],
      //                           // ),
      //
      //                           // The end action pane is the one at the right or the bottom side.
      //                           endActionPane:  ActionPane(
      //                             extentRatio: 0.35,
      //                             motion: ScrollMotion(),
      //                             children: [
      //                               // SlidableAction(
      //                               //   // An action can be bigger than the others.
      //                               //   flex: 2,
      //                               //   // onPressed:doNothing,
      //                               //   onPressed: (BuildContext context) {
      //                               //
      //                               //   },
      //                               //   backgroundColor: Colors.black87,
      //                               //   foregroundColor: Colors.white,
      //                               //   icon: Icons.delete_outline_sharp,
      //                               //   label: 'Remove Item',
      //                               // ),
      //                               SlidableAction(
      //                                 // onPressed: doNothing,
      //                                 backgroundColor: Color(0xFF0392CF),
      //                                 foregroundColor: Colors.white,
      //                                 icon: Icons.bookmark_add_outlined,
      //                                 label: 'Save For Later',
      //                                 onPressed: (BuildContext context) {
      //                                   provider.addSaveForLater(context,element);
      //                                 },
      //                               ),
      //                             ],
      //                           ),
      //
      //                           child: Container(
      //                             color: Colors.white,
      //                             padding: EdgeInsets.all(10),
      //                             child:
      //                             Stack(
      //                               alignment: AlignmentDirectional.topEnd,
      //                               children: [
      //                                 Column(
      //                                 children: [
      //                                   Row(
      //                                     children: [
      //                                       Container(
      //                                         margin: EdgeInsets.all(10),
      //                                         decoration: BoxDecoration(
      //                                           borderRadius: BorderRadius.all(Radius.circular(10)),
      //                                           boxShadow: [
      //                                             BoxShadow(
      //                                               color: Colors.grey.withOpacity(0.2),
      //                                               spreadRadius: 3,
      //                                               blurRadius: 5,
      //                                               offset: Offset(0,0),
      //                                             ),
      //                                           ],
      //                                         ),
      //                                         child: Container(
      //                                             padding: EdgeInsets.all(10),
      //
      //                                             height: 110,
      //                                             width: 110,
      //                                             decoration: BoxDecoration(
      //                                                 color: Colors.white,
      //
      //                                                 borderRadius: BorderRadius.all(Radius.circular(10))
      //                                             )
      //                                             ,child: Image.network('${element['feature_img']}',)),
      //                                       ),
      //                                       Expanded(
      //                                           child:
      //                                           Column(
      //                                             crossAxisAlignment: CrossAxisAlignment.start,
      //                                             children: [
      //                                               Container(width: width,child: Text('${element['product_name']}',style: TextStyle(
      //                                                   fontSize: 12,color: Colors.grey
      //                                               ),)),
      //                                               // SizedBox(height: 6,),
      //                                               // Container(width: width,child: Text('Category',maxLines: 2,overflow: TextOverflow.ellipsis,)),
      //                                               SizedBox(height: 6,),
      //                                               // DropdownButtonFormField<dynamic>(
      //                                               //   isDense: true,
      //                                               //   decoration: InputDecoration(
      //                                               //       contentPadding: EdgeInsets
      //                                               //           .symmetric(horizontal: 5),
      //                                               //       isDense: true,
      //                                               //       border: OutlineInputBorder(
      //                                               //           borderRadius: BorderRadius
      //                                               //               .all(
      //                                               //               Radius.circular(5))
      //                                               //       )
      //                                               //   ),
      //                                               //   value: element['variant'],
      //                                               //   items: [element['variant']]
      //                                               //       .map<
      //                                               //       DropdownMenuItem<dynamic>>((
      //                                               //       item) {
      //                                               //     return DropdownMenuItem<
      //                                               //         dynamic>(
      //                                               //       value: item,
      //                                               //       child: Text(
      //                                               //           item['packsize'] + ' ' +
      //                                               //               item['units']),
      //                                               //     );
      //                                               //   }).toList(),
      //                                               //
      //                                               //   onChanged: (value) {
      //                                               //
      //                                               //   },
      //                                               // ),
      //                                               Container(
      //                                                 width: width,
      //                                                 child: Row(
      //                                                   children: [
      //                                                     Text('${element['pack_size'] } '),
      //                                                     // SizedBox(width: 4,),
      //                                                     // Text('₹ 1000'),
      //                                                   ],
      //                                                 ),
      //                                               ),
      //                                               SizedBox(height: 6,),
      //                                               Container(
      //                                                 width: width,
      //                                                 child: Row(
      //                                                   children: [
      //                                                     Text('₹ ${provider.getProductTotal(element) } '),
      //                                                     // SizedBox(width: 4,),
      //                                                     // Text('₹ 1000'),
      //                                                   ],
      //                                                 ),
      //                                               ),
      //                                               SizedBox(height: 6,),
      //
      //                                               Row(
      //                                                 children: [
      //
      //                                                   AddToCartButton("${element['cart_qty']}", isLoading:provider.PRODUCT_DET!=null?
      //                                                   (provider.PRODUCT_DET['product_id']==element['product_id']&& provider.PRODUCT_DET['variant_id']==element['variant_id']&& provider.loading_add_to_cart)?true:false:false,width: 130, height: 35,
      //                                                       onTap: (type){
      //                                                         provider.addToCart(type,element, context);
      //                                                       }),
      //                                                   IconButton(onPressed: () => provider.deleteFromCart(element,context),
      //                                                       icon: Icon(Icons.delete)),
      //                                                 ]
      //                                               ),
      //                                               if((provider.loading_delete_from_cart && provider.CART_ID!=null && provider.CART_ID==element['cart_id']) || (provider.PRODUCT_DET!=null && element['product_id']==provider.PRODUCT_DET['product_id'] &&
      //                                                   provider.loading_add_to_cart))...{
      //                                                 Container(
      //                                                   padding:EdgeInsets.only(top: 5,bottom: 5),
      //                                                   child: Center(
      //                                                     child: CircularProgressIndicator(),
      //                                                   ),
      //                                                 ),
      //                                               },
      //
      //
      //                                             ],
      //                                           ),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                   Container(
      //                                     margin: EdgeInsets.only(top: 10),
      //                                     width: width,
      //                                     height: 1,
      //                                     color: Colors.black.withOpacity(0.2),
      //                                   )
      //                                 ],
      //                               ),
      //                                 if(provider.loading_save_later && provider.SAVE_LATER!=null && provider.SAVE_LATER['cart_id']==element['cart_id'])...{
      //                                   Container(
      //                                     height: 150,
      //                                     color: Colors.grey.withOpacity(0.2),
      //                                     child: Center(
      //                                     child: CircularProgressIndicator(),
      //                                   ),)
      //                                 }
      //                               ]
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                       // itemComparator: (item1, item2) => item1['variant']['childCat_name'].compareTo(item2['variant']['childCat_name']), // optional
      //                       itemComparator: (item1, item2) => item1['product_name'].compareTo(item2['product_name']), // optional
      //                       useStickyGroupSeparators: true, // optional
      //                       floatingHeader: true, // optional
      //                       order: GroupedListOrder.ASC, // optional
      //                     ),
      //                     Text('Save Later')
      //                   ],
      //                 ),
      //               ),
      //
      //             ],
      //           ),
      //         ),
      //
      //         Positioned(
      //           bottom: 0,
      //           child: Container(
      //             color: Colors.white ,
      //             width: width,
      //             alignment: Alignment.centerLeft,
      //
      //             child: Column(
      //               children: [
      //                 Visibility(
      //                   visible: false,
      //                   child: Column(
      //                     children: [
      //                       Container(
      //                         height: 0.5,
      //                         width: width,
      //                         margin: EdgeInsets.only(bottom:4),
      //                         color: Colors.black.withOpacity(0.2),
      //                       ),
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.start,
      //                         children: [
      //                           Container(padding: EdgeInsets.all(4),
      //                               margin: EdgeInsets.fromLTRB(14,4,14,4),
      //                               decoration: BoxDecoration(
      //                                 color: green,
      //                                 borderRadius: BorderRadius.all(Radius.circular(50)),
      //                               )
      //                               ,child: Icon(Icons.location_on_outlined,color: Colors.white,)),
      //
      //                           Expanded(
      //                             child: Column(
      //                               mainAxisAlignment: MainAxisAlignment.start,
      //                               children: [
      //                                 Container(
      //                                   alignment: Alignment.centerLeft,
      //                                   child: Row(
      //                                     mainAxisAlignment: MainAxisAlignment.start,
      //                                     children: [
      //                                       Text('Selected Location',style: TextStyle(fontSize: 14),),
      //                                       SizedBox(width: 10,),
      //                                       Icon(CupertinoIcons.chevron_down,size: 15,),
      //                                     ],
      //                                   ),
      //                                 ),
      //                                 Container(
      //
      //                                     alignment: Alignment.centerLeft,
      //                                     child: Text('Thane West,Thane - 400604',style: TextStyle(color: darkgrey,fontSize: 10),))
      //                               ],
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 Container(
      //                   height: 0.5,
      //                   width: width,
      //                   margin: EdgeInsets.only(top:4),
      //                   color: Colors.black.withOpacity(0.2),
      //                 ),
      //                 Container(
      //                   padding: EdgeInsets.fromLTRB(20,5,15,5),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Column(
      //                         mainAxisAlignment: MainAxisAlignment.start,
      //                         children: [
      //                           Row(
      //                             mainAxisAlignment: MainAxisAlignment.start,
      //                             children: [
      //                               Text('Total: ',style: TextStyle(color: darkgrey,fontSize: 15)),
      //                               Text('₹ ${provider.DATA['subTotal']}',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15),),
      //                             ],
      //                           ),
      //                           Container(
      //                               color: red.withOpacity(0.1),
      //                               padding: EdgeInsets.fromLTRB(10,4,10,4),
      //                               child: Text('Saved ₹ ${provider.DATA['total_save']}',style: TextStyle(color: red,fontSize: 10),)
      //                           ),
      //                         ],
      //                       ),
      //                       Visibility(
      //                         visible: false,
      //                         child: Container(
      //                           padding: EdgeInsets.fromLTRB(20,8,20,8),
      //                           decoration: BoxDecoration(
      //                               color: red,
      //                               borderRadius: BorderRadius.all(
      //                                   Radius.circular(4)
      //                               )
      //
      //                           ),
      //                           child: Text('Add Address',style: TextStyle(color: Colors.white,fontSize: 14),),
      //                         ),
      //                       ),
      //                       Visibility(
      //                         visible: true,
      //                         child: GestureDetector(
      //                           onTap: (){
      //                             // Navigator.push(context,MaterialPageRoute(builder:(context) => Delivery_Options()));
      //                             Navigator.pushNamed(context, RouteNames.route_delivery_options,arguments: [provider.data_list,provider.DATA]);
      //                           },
      //                           child: Container(
      //                             padding: EdgeInsets.fromLTRB(20,8,20,8),
      //                             decoration: BoxDecoration(
      //                                 color: red,
      //                                 borderRadius: BorderRadius.all(
      //                                     Radius.circular(4)
      //                                 )
      //
      //                             ),
      //                             child: Text('Checkout',style: TextStyle(color: Colors.white,fontSize: 14),),
      //                           ),
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         )
      //       ],
      //     )
      // ),

    );
  }

  void doNothing(BuildContext context) {}

  txtbox2(String s) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        // color: Colors.white
      ),
      padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
      margin: EdgeInsets.all(10),
      child: Text(s, style: TextStyle(color: Colors.black.withOpacity(0.5))),
    );
  }
}






