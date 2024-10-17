import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/res/components/product_item.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/view_models/wishlist_viewmodel.dart';

import '../../view_models/home_viewmodel.dart';
class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  @override
  void initState() {
    super.initState();
    WishListViewModel provider=Provider.of(context,listen: false);
    provider.getWishList(context);
  }
  @override
  Widget build(BuildContext context) {
    WishListViewModel provider=Provider.of(context);
    HomeViewModel provider_home=Provider.of(context);
    double width = MediaQuery.of(context).size.width;

    var green = Color(0xFF689f39);
    var darkgrey = Color(0xFF7b7c7a);
    var red = Color(0xFFf17523);

    int i = 0;
    return SingleChildScrollView(
      child: Column(
        children: [

          Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey  .withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(margin: EdgeInsets.fromLTRB(10,0,0,0),child: Text('${provider.data_list.length} items', style: TextStyle(color: Colors.grey),)),
                Container(),
                // GestureDetector(
                //   onTap: (){
                //     //NavigateToScreen(context,FilterScreen());
                //   },
                //   child: Container(
                //     padding: EdgeInsets.fromLTRB(10,5,10,5),
                //     decoration: BoxDecoration(
                //       color: Colors.black.withOpacity(0.5),
                //       borderRadius: BorderRadius.all(Radius.circular(4)),
                //     ),
                //     child: Row(
                //       children: [
                //         Icon(Icons.tune,color: Colors.white,),
                //         Text('Filter',style: TextStyle(color: Colors.white),)
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          for(int i = 0;i<provider.data_list.length;i++)...{
            Slidable(
                key:  ValueKey<int>(i),

                // The start action pane is the one at the left or the top side.
                // startActionPane: ActionPane(
                //   // A motion is a widget used to control how the pane animates.
                //   motion: const ScrollMotion(),
                //
                //   // A pane can dismiss the Slidable.
                //   dismissible: DismissiblePane(onDismissed: () {}),
                //
                //   // All actions are defined in the children parameter.
                //   children:  [
                //     // A SlidableAction can have an icon and/or a label.
                //     SlidableAction(
                //       // onPressed: doNothing,
                //       onPressed: (BuildContext context) {
                //
                //       },
                //       backgroundColor: Color(0xFFFE4A49),
                //       foregroundColor: Colors.white,
                //       icon: Icons.delete,
                //       label: 'Delete',
                //     ),
                //     SlidableAction(
                //       // onPressed: doNothing,
                //       onPressed: (BuildContext context) {
                //
                //       },
                //       backgroundColor: Color(0xFF21B7CA),
                //       foregroundColor: Colors.white,
                //       icon: Icons.share,
                //       label: 'Share',
                //     ),
                //   ],
                // ),

                // The end action pane is the one at the right or the bottom side.
                endActionPane:  ActionPane(
                  extentRatio: 0.35,
                  motion: ScrollMotion(),
                  children: [
                    // SlidableAction(
                    //   // An action can be bigger than the others.
                    //   flex: 2,
                    //   // onPressed:doNothing,
                    //   onPressed: (BuildContext context) {
                    //
                    //   },
                    //   backgroundColor: Colors.black87,
                    //   foregroundColor: Colors.white,
                    //   icon: Icons.delete_outline_sharp,
                    //   label: 'Remove Item',
                    // ),
                    SlidableAction(
                      // onPressed: doNothing,
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                      onPressed: (BuildContext context) {
                        provider.deleteFromWhishlist(context,provider.data_list[i]);
                      },
                    ),
                  ],
                ),

                child:ProductItem(FROM.WHISHLIST,provider.data_list[i],
              (provider.PRODUCT_DET!=null && provider
                  .data_list[i]['product_id']==provider.PRODUCT_DET['product_id'] &&
                  provider.loading_add_to_cart) ,
              onTap: (){

                Navigator.pushNamed(context,RouteNames.route_product_details,arguments: [
                  provider.data_list[i],
                  provider_home],
                ).then((value) => provider.checkForCartQty());
              },
              onVariantChange:(_variant){
                provider.setSelectedVarient(i,_variant);
              } ,
              onAddToCart: (_type,_indx){
                provider.addToCart(i,_type, context);

              },

            )
            // Container(
            //   color: Colors.white,
            //   padding: EdgeInsets.all(10),
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           GestureDetector(
            //             onTap: () {
            //               //NavigateToScreen(context,ProductDetScreen(id: "0",));
            //             },
            //             child: Container(
            //               margin: EdgeInsets.all(10),
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.all(Radius.circular(10)),
            //                 boxShadow: [
            //                   BoxShadow(
            //                     color: Colors.grey.withOpacity(0.2),
            //                     spreadRadius: 3,
            //                     blurRadius: 5,
            //                     offset: Offset(0, 0),
            //                   ),
            //                 ],
            //               ),
            //               child: Container(
            //                   padding: EdgeInsets.all(10),
            //
            //                   height: 150,
            //                   width: 150,
            //                   decoration: BoxDecoration(
            //                       color: Colors.white,
            //
            //                       borderRadius: BorderRadius.all(
            //                           Radius.circular(10))
            //                   )
            //                   ,
            //                   child: Image.network(
            //                       '${provider.data_list[i]['feature_img']}')),
            //             ),
            //           ),
            //           Expanded(child: Column(
            //             children: [
            //               Container(width: width,
            //                   child: Text(
            //                     '${provider.data_list[i]['product_name']}',
            //                     style: TextStyle(
            //                         fontSize: 12, color: Colors.grey
            //                     ),)),
            //               SizedBox(height: 6,),
            //               Container(width: width,
            //                   child: Text('Category', maxLines: 2,
            //                     overflow: TextOverflow.ellipsis,)),
            //               SizedBox(height: 6,),
            //               Container(
            //                 width: width,
            //                 padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            //                 decoration: BoxDecoration(
            //                     color: Colors.white,
            //                     borderRadius: BorderRadius.all(
            //                         Radius.circular(5)),
            //                     border: Border.all(
            //                       color: Colors.grey,
            //                       width: 1,
            //                     )
            //                 ),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text('500g'),
            //                     Icon(CupertinoIcons.chevron_down),
            //                   ],
            //                 ),
            //               ),
            //               SizedBox(height: 6,),
            //               Container(
            //                 width: width,
            //                 child: Row(
            //                   children: [
            //                     Text('₹ 500'),
            //                     SizedBox(width: 4,),
            //                     Text('₹ 1000'),
            //                   ],
            //                 ),
            //               ),
            //               SizedBox(height: 6,),
            //               Container(
            //                   width: width,
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment
            //                         .spaceBetween,
            //                     children: [
            //                       Container(),
            //                       Container(
            //                         margin: EdgeInsets.only(right: 20),
            //                         padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
            //                         alignment: Alignment.center,
            //                         decoration: BoxDecoration(
            //                             color: red,
            //                             borderRadius: BorderRadius.all(
            //                               Radius.circular(5),
            //                             )
            //                         ),
            //                         child: Text('ADD', style: TextStyle(
            //                             fontSize: 16, color: Colors.white),),
            //                       ),
            //                     ],
            //                   )
            //               )
            //
            //             ],
            //           )),
            //
            //         ],
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(top: 10),
            //         width: width,
            //         height: 1,
            //         color: Colors.black.withOpacity(0.2),
            //       )
            //     ],
            //   ),
            // ),
            )
          }
        ],
      ),
    );
  }
}
