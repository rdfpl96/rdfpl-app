
import 'package:royal_dry_fruit/res/colors.dart';
import 'package:royal_dry_fruit/res/theme.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/view_models/home_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/product_det_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/product_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';



class ProductDetScreen extends StatefulWidget{
  var model;
  HomeViewModel homeViewModel;
  ProductDetScreen({required this.model,required this.homeViewModel});

  @override
  StateProductDetScreen createState()=> StateProductDetScreen();

}

class StateProductDetScreen extends State<ProductDetScreen>{

  var green = Color(0xFF689f39);
  var darkgrey = Color(0xFF7b7c7a);
  var red = Color(0xFFf17523);

String aboutTheProduct = 'Almonds are light brown skinned, tough, edible seeds of the almond fruit.They have a wealthy yet subtle bitter-sweet flavor.These are assets of nutrients, especially protein, dietary fibre, mono-unsaturated fatty acids and B complex vitamins.Also, it is wealthy in vitamin E and minerals such as potassium, calcium, manganese, zinc, iron and selenium.Store in a cool, dry place in an airtight container and preferably refrigerate after openingClick here for unique and delicious recipes - https://www.bigbasket.com/flavors/collections/231/dry-fruits-berries-nuts/';

@override
  void initState() {

    super.initState();
    ProductDetViewModel provider=Provider.of(context,listen: false);
    provider.getProductDetails(widget.model, context);
    // provider.getProductRating(widget.model, context);
  }

  @override
  Widget build(BuildContext context) {
    ProductDetViewModel provider=Provider.of(context);

    // provider.getProductDetails("product_id=${widget.id}", context);

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(width: 30,height: 30,child: Icon(CupertinoIcons.back))),
        centerTitle: true,shadowColor: Colors.transparent,
      actions: [
        IconButton(
            onPressed: () => provider.searchProduct(context),
            icon: Icon(Icons.search)),SizedBox(width:20),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, RouteNames.route_basket),
          child: Container(
            padding: EdgeInsets.only(right: 5),
            height: kToolbarHeight,
            child: new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Icon(CupertinoIcons.bag),SizedBox(width:20),

                  new Positioned(
                    right: 0,
                    child: new Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: new Text(
                        '${widget.homeViewModel.cart_count}',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )

              ],
            ),
          ),
        ),
      ],),


      body: provider.loading?
      Container(child: Center(child: CircularProgressIndicator()),):
          provider.product_detail==null?
          Center(child: Container(child: Text('No Data Found'),)):
      Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(

                  child: Column(
                    children: [
                      Container(width: width,margin: EdgeInsets.fromLTRB(10,10,10,0),child: Text('${provider.product_detail['product_name']}',style: TextStyle(color: darkgrey,fontSize: 16),)),

                      Container(
                        width: width,margin: EdgeInsets.fromLTRB(10,10,10,5),
                        child: Row(children: [
                          Text('₹${provider.getSelected()['price'].toString()}'),
                          Container(margin: EdgeInsets.all(10),child: Text('₹${provider.getSelected()['before_off_price'].toString()}',style: TextStyle(decoration: TextDecoration.lineThrough,color: darkgrey,fontSize: 12),)),
                          (double.tryParse(provider.getSelected()['before_off_price']) ?? 0.0)==0.00?
                          Container():
                          Container(padding: EdgeInsets.all(2) ,color: red,child: Text('${provider.getPercentage()} % Off',style: TextStyle(color: Colors.white,fontSize:12))),
                        ],),
                      ),

                      Container(
                        width: width,
                        height: width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        margin: EdgeInsets.all(10),
                        child: Image.network('${provider.selected_img}'),
                      ),

                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for(int i =0;i<provider.images_list.length;i++)...{
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))
                                  ),
                                  margin: EdgeInsets.only(left: 10),
                                  child: Image.network(
                                      '${provider.images_list[i]}'),
                                )
                              }
                            ],
                          )
                      ),

                      Container(width: width,margin: EdgeInsets.only(left: 10,top: 10),
                          child: Text('Pack Sizes',style: TextStyle(fontSize: 16,color: darkgrey,fontWeight: FontWeight.w100))),

                      for(int i=0;i<(provider.product_detail['items']as List).length;i++)...{

                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.2),
                                  width: 1,

                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${provider.product_detail['items'][i]['pack_size']}${provider.product_detail['items'][i]['units']}', style: TextStyle(fontSize: 12),),
                                  Column(children: [
                                    Text('${provider.product_detail['items'][i]['price']}', style: TextStyle(fontSize: 12)),
                                    Text('${provider.product_detail['items'][i]['before_off_price']}', style: TextStyle(
                                        color: darkgrey,
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 12)),
                                  ],),
                                  Radio(value: provider.product_detail['items'][i],
                                    groupValue: provider.selected_varient,
                                    onChanged: ( value) {
                                      provider.setSelectedVarient(value);
                                    },),
                                ],
                              ),
                            ),
                            Positioned(top: 10, left: 10,
                              child: (double.tryParse(provider.product_detail['items'][i]['before_off_price']) ?? 0.0)==0.00?
                              Container():
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(2)),
                                    color: red
                                ),
                                child: Text('₹ ${(double.tryParse(provider.product_detail['items'][i]['before_off_price']) ?? 0.0) - (double.tryParse(provider.product_detail['items'][i]['price']) ?? 0.0) } OFF',
                                  style: TextStyle(color: Colors.white, fontSize: 10),),
                              ),
                            ),
                          ],
                        ),

                      },
                      if(!(provider.product_detail['other_info'] is bool) && provider.product_detail['other_info']!=null)...{
                        for(int i = 0; i < (provider
                            .product_detail['other_info'] as List)
                            .length; i++)...{
                          // ExpansionTile(title: Text("${provider.product_detail['description'][i]['desc_header']} Tittlere"),
                          // children: [
                          //   Text('${provider.product_detail['description'][i][
                          //       'description']} Desdsds')
                          // ],)
                          if(provider
                              .product_detail['other_info'][i]['heading'] ==
                              null || provider
                              .product_detail['other_info'][i]['heading'] ==
                              '')...{
                          } else
                            ...{

                              Container(width: width,
                                  margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text('${provider
                                                .product_detail['other_info'][i]['heading']}',
                                                style: TextStyle(fontSize: 15,
                                                    color: darkgrey,
                                                    fontWeight: FontWeight
                                                        .w100)),
                                          ),
                                          Container(width: 40,
                                              height: 40,
                                              child: Icon(
                                                CupertinoIcons.chevron_down,
                                                color: darkgrey.withOpacity(
                                                    0.9),
                                                size: 20,))
                                        ],
                                      ),
                                      Container(
                                          child: Text('${provider
                                              .product_detail['other_info'][i]['description']}',
                                            style: TextStyle(
                                              color: darkgrey.withOpacity(
                                                  0.6),),
                                          )),
                                      Container(
                                        height: 1,
                                        width: width,
                                        margin: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        color: Colors.black.withOpacity(0.2),
                                      ),

                                    ],
                                  )),
                            }
                        },
                      },

                      SizedBox(height: 10,),

                      //Highlight Section Disable
                      // Container(width: width,margin: EdgeInsets.only(left: 10,top: 10),
                      //     child: Text('Highlights',style: TextStyle(fontSize: 16,color: darkgrey,fontWeight: FontWeight.w100))),
                      //
                      // Container(
                      //   margin: EdgeInsets.only(left: 10,top: 15),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: Container(
                      //           child: Column(
                      //             children: [
                      //               Stack(
                      //                 fit: StackFit.loose,
                      //                 alignment: Alignment.center,
                      //                 children: [
                      //                   CircularProgressIndicator(
                      //                     backgroundColor: Colors.grey.shade300,
                      //                     color: red,
                      //                     value: 0.5,
                      //                     strokeCap: StrokeCap.round,
                      //                     valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                      //                   ),
                      //                   Text('2.3',style: TextStyle(fontSize: 14),)
                      //                 ],
                      //               ),
                      //               SizedBox(height: 10,),
                      //               Text('Softness',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w100),),
                      //               SizedBox(height: 7,),
                      //               Text('4667 ratings',style: kTextTitleSmall.copyWith(color: Colors.grey.shade500),),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: Container(
                      //           child: Column(
                      //             children: [
                      //               Stack(
                      //                 fit: StackFit.loose,
                      //                 alignment: Alignment.center,
                      //                 children: [
                      //                   CircularProgressIndicator(
                      //                     backgroundColor: Colors.grey.shade300,
                      //                     color: red,
                      //                     value: 0.7,
                      //                     strokeCap: StrokeCap.round,
                      //                     valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                      //                   ),
                      //                   Text('4.7',style: TextStyle(fontSize: 14),)
                      //                 ],
                      //               ),
                      //               SizedBox(height: 10,),
                      //               Text('Puffiness',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w100),),
                      //               SizedBox(height: 7,),
                      //               Text('321 ratings',style: kTextTitleSmall.copyWith(color: Colors.grey.shade500),),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: Container(
                      //           child: Column(
                      //             children: [
                      //               Stack(
                      //                 fit: StackFit.loose,
                      //                 alignment: Alignment.center,
                      //                 children: [
                      //                   CircularProgressIndicator(
                      //                     backgroundColor: Colors.grey.shade300,
                      //                     color: red,
                      //                     value: 0.9,
                      //                     strokeCap: StrokeCap.round,
                      //                     valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                      //                   ),
                      //                   Text('4.5',style: TextStyle(fontSize: 14),)
                      //                 ],
                      //               ),
                      //               SizedBox(height: 10,),
                      //               Text('Tastte',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w100),),
                      //               SizedBox(height: 7,),
                      //               Text('1302 ratings',style: kTextTitleSmall.copyWith(color: Colors.grey.shade500),),
                      //             ],
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 15,),
                      // Divider(height: 1,color: Colors.grey.shade400,),
                      //Highlight Section Disable
                      if(provider.list_rating_review!=null)...{
                        Container(width: width,margin: EdgeInsets.only(left: 10,top: 10),
                            child: Text('Reviews & Ratings',style: TextStyle(fontSize: 16,color: darkgrey,fontWeight: FontWeight.w100))),
                        SizedBox(height: 10,),
                        Divider(height: 1,color: Colors.grey.shade400,),
                        Container(
                          margin: EdgeInsets.only(left: 10,top: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('${provider.Prod_Rating==null?'0':provider.Prod_Rating}',style: kTextTitleLarge.copyWith(color: green,fontWeight: FontWeight.bold),),
                                        SizedBox(width: 5,),
                                        Icon(Icons.star,size: 15,color: green,),
                                      ],
                                    ),
                                    Text('${provider.list_rating_review==null?'0':(provider.list_rating_review as List).length} reviews',style: kSmallLightText,)
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,color: Colors.grey,),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Divider(height: 1,color: Colors.grey.shade400,),
                        Container(width: width, margin: EdgeInsets.only(
                            left: 10, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: (provider.list_rating_review as List)
                                  .map((e) =>
                                  Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                               // width: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Colors.green.shade100
                                                ),
                                                child: Padding(padding:EdgeInsets.symmetric(horizontal: 5,vertical: 2),child: Row(
                                                  children: [
                                                    Text('${e['cust_rate']}',style: TextStyle(fontSize: 10),),
                                                    SizedBox(width: 2,),
                                                    Icon(Icons.star_sharp,color: Colors.green,size: 10,)
                                                  ],
                                                )),
                                              ),
                                              SizedBox(width: 5,),
                                              Text('${e['title']==null?"":e['title']}',
                                                  style: TextStyle(fontSize: 14,
                                                      color: darkgrey,
                                                      fontWeight: FontWeight.w100)),
                                            ],
                                          ),
                                          // Review Images If Contains
                                          // SizedBox(height: 10,),
                                          // SingleChildScrollView(
                                          //     scrollDirection: Axis.horizontal,
                                          //     child: Row(
                                          //       children: [
                                          //         for(int i =1;i<7;i++)...{
                                          //           Container(
                                          //             width: 80,
                                          //             height: 80,
                                          //             decoration: BoxDecoration(
                                          //                 color: Colors.white,
                                          //                 borderRadius: BorderRadius.all(
                                          //                     Radius.circular(10))
                                          //             ),
                                          //             margin: EdgeInsets.only(left: 10),
                                          //             child: Image.network(
                                          //                 '${provider.list_rating_review[0]['defaultUserImage']}'),
                                          //           )
                                          //         }
                                          //       ],
                                          //     )
                                          // ),
                                          SizedBox(height: 10,),
                                          Text('${e['comment']}',
                                              style: TextStyle(fontSize: 14,
                                                  color: darkgrey,
                                                  fontWeight: FontWeight.w100)),
                                          SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              CircleAvatar(child: ClipRRect(
                                                child: Image.asset(
                                                    'assests/images/ic_user.png'),
                                              ),
                                                  radius: 15,
                                                  backgroundColor: Colors
                                                      .transparent),
                                              SizedBox(width: 5,),
                                              Text(
                                                  // '${e['customer_datails'][0]['c_fname']} ${e['customer_datails'][0]['c_lname']} (${e['add_date']})',
                                                  '${e['customer_name']} (${e['add_date']})',
                                                  style: TextStyle(fontSize: 12,
                                                      color: Colors.grey
                                                          .shade500)),
                                            ],
                                          ),
                                          SizedBox(height: 15,),
                                          Divider(height: 1,)
                                        ],
                                      )
                                  )).toList(),
                            )
                        ),
                      },

                      SizedBox(height: 150,),

                    ],
                  ),
                ),

              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child:
                    GestureDetector(
                      onTap: (){
                        provider.addToWishList(widget.model, context);
                      },
                      child: Container(
                        height: 55,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: provider.isInWhishList?kGreen:darkgrey
                        ),
                        child: provider.loading_in_details?Container(child: Center(child: CircularProgressIndicator(color: Colors.white),),):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.bookmark,color: Colors.white,),
                            SizedBox(width: 10,),
                            (provider.loading_whishlist || provider.loading_delete_whishlist)?CircularProgressIndicator():Text(provider.isInWhishList?"WishListed":'Add To Wishlist',style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child:  (provider.getSelected()['qty']!=null && int.parse(provider.getSelected()['qty'])>0)?
                    Container(
                      // width:150,
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(left: 5,right: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                provider.addToCart(provider.product_detail,'-', context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color:red,
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),
                                        topLeft: Radius.circular(8))
                                ),
                                child: Center(
                                  child: Text('-',style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white
                                  ),),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Text(
                            '${provider.getSelected()['qty']==null?'0':provider.getSelected()['qty']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                provider.addToCart(provider.product_detail,'+', context);                                                },
                              child: Container(
                                decoration: BoxDecoration(
                                    color:red,
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(8),
                                        topRight: Radius.circular(8))
                                ),
                                child: Center(
                                  child: Text('+',style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white
                                  ),),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ):
                    GestureDetector(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>BasketScreen()));
                        // Navigator.pushNamed(context, RouteNames.route_basket);
                        provider.addToCart(provider.product_detail, '+',context);
                      },
                      child: Container(
                        height: 55,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: green
                        ),
                        child: provider.loading_add_to_cart?Center(child: CircularProgressIndicator(),): Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.bag,color: Colors.white),
                            SizedBox(width: 10,),
                            Text('Add to Basket',style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
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