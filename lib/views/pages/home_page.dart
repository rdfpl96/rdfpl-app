import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/res/components/dashboard_product_item.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/views/home_screen.dart';

import '../../utils/routes/routes_name.dart';
import '../../view_models/home_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    HomeViewModel provider=Provider.of(context);

    var green = Color(0xFF689f39);
    var darkgrey = Color(0xFF7b7c7a);
    var red = Color(0xFFf17523);


    // final List<String> categories = [
    //   "Fruits& Vegetables",
    //   "Dairy & Breads",
    //   "Eggs, Meat, & Fish",
    //   "Cooking Essentials",
    //   "Munhies & Biscuits",
    //   "Chocolates & Sweets",
    //   "Ready-to-Cook & Eat",
    //   "Beverages",
    //   "Beauty & Hygiene",
    // ];


    double width = MediaQuery.of(context).size.width;

    return provider.loading?Center(child: CircularProgressIndicator()):Column(
      children: [
        SizedBox(height: 5,),
        CarouselSlider(
          options: CarouselOptions(
            onPageChanged: (index, reason) {},
            height: 180, // Adjust the height as needed
            aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
            viewportFraction: 0.8, // Adjust the fraction of the viewport to show
            initialPage: 0, // Set the initial page
            enableInfiniteScroll: true, // Allow infinite scrolling
            autoPlay: true, // Auto play the carousel
            autoPlayInterval: Duration(seconds: 2), // Auto play interval
            autoPlayAnimationDuration:
            Duration(milliseconds: 800), // Animation duration
            autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
            enlargeCenterPage: true, // Enlarge the center image
          ),
          items: provider.data_list.map((data) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: (data['mobile_image'] as String).endsWith("/")?Container():Image.network(
                      '${data['mobile_image']}',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),



        SizedBox(height: 25,),
        Container(
          margin: EdgeInsets.fromLTRB(5,0,5,0),
          child: Column(
            children: [

              Container(
                width: width,
                child: Text('My Smart Basket',style: TextStyle(fontSize: 18,color: red),),
              ),
              SizedBox(height: 10,),
              Container(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.mySmartProduct.length,
                  itemBuilder: (context, index) {
                    return DashboardProductItem(provider.mySmartProduct[index],
                        (provider.PRODUCT_DET!=null && provider
                            .mySmartProduct[index]['product_id']==provider.PRODUCT_DET['product_id'] &&
                            provider.loading_add_to_cart),
                      onTap: (){
                        Navigator.pushNamed(context,RouteNames.route_product_details,arguments: [
                          provider.mySmartProduct[index],
                          provider],
                        );

                      },
                      onVariantChange:(_variant){
                        provider.setSelectedVarient(index,_variant,prod_type: 'S');
                      } ,
                      onAddToCart: (_type,_indx){
                        provider.addToCart(index,_type, context,prod_type: 'S');
                      },);
                  },
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: width,
                child: Text('Featured Product',style: TextStyle(fontSize: 18,color: red),),
              ),
              SizedBox(height: 10,),
              Container(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.myFeatureProduct.length,
                  itemBuilder: (context, index) {
                    return DashboardProductItem(provider.myFeatureProduct[index],
                      (provider.PRODUCT_DET!=null && provider
                          .myFeatureProduct[index]['product_id']==provider.PRODUCT_DET['product_id'] &&
                          provider.loading_add_to_cart),
                      onTap: (){
                        Navigator.pushNamed(context,RouteNames.route_product_details,arguments: [
                          provider.myFeatureProduct[index],
                          provider],
                        );

                      },
                      onVariantChange:(_variant){
                        provider.setSelectedVarient(index,_variant,prod_type: 'F');
                      } ,
                      onAddToCart: (_type,_indx){
                        provider.addToCart(index,_type, context,prod_type: 'F');
                      },);
                  },
                ),
              ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //
              //     children: [
              //
              //       for(int i = 0;i<10;i++)...{
              //         Container(
              //           width: 150,
              //           padding: EdgeInsets.all(10),
              //
              //           child: Column(
              //             children: [
              //               Column(
              //                 children: [
              //                   GestureDetector(
              //                     onTap: (){
              //                       // NavigateToScreen(context,ProductDetScreen(id:"0"));
              //                     },
              //                     child: Container(
              //                       height: 100,
              //                       width: 100,
              //                       decoration: BoxDecoration(
              //                         color: Colors.white,
              //                         borderRadius: BorderRadius.all(
              //                             Radius.circular(10)),
              //                         boxShadow: [
              //                           BoxShadow(
              //                             color: Colors.grey
              //                                 .withOpacity(0.1),
              //                             spreadRadius: 3,
              //                             blurRadius: 5,
              //                             offset: Offset(0, 0),
              //                           ),
              //                         ],
              //                       ),
              //                       child: Image.asset(
              //                           "assests/images/almond.jpg"),
              //                     ),
              //                   ),
              //                   SizedBox(height: 4,),
              //                   Container(
              //                       width: width,
              //                       child: Text(
              //                         'DRYFRUITS',
              //                         style: TextStyle(
              //                             fontSize: 12,
              //                             color: Colors.grey),
              //                       )
              //                   ),
              //                   SizedBox(
              //                     height: 6,
              //                   ),
              //                   Container(
              //                       width: width,
              //                       child: Text(
              //                         'Organic - Almond/Badam',
              //                         maxLines: 2,
              //                         overflow: TextOverflow.ellipsis,
              //                       )),
              //                   SizedBox(
              //                     height: 6,
              //                   ),
              //                   Container(
              //                     width: width,
              //                     padding:
              //                     EdgeInsets.fromLTRB(5, 2, 5, 2),
              //                     decoration: BoxDecoration(
              //                         color: Colors.white,
              //                         borderRadius: BorderRadius.all(
              //                             Radius.circular(5)),
              //                         border: Border.all(
              //                           color: Colors.grey,
              //                           width: 1,
              //                         )),
              //                     child: Row(
              //                       mainAxisAlignment:
              //                       MainAxisAlignment
              //                           .spaceBetween,
              //                       children: [
              //                         Text('500g'),
              //                         Icon(CupertinoIcons
              //                             .chevron_down),
              //                       ],
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     height: 6,
              //                   ),
              //                   Container(
              //                     width: width,
              //                     child: Row(
              //                       children: [
              //                         Text('₹ 500'),
              //                         SizedBox(
              //                           width: 4,
              //                         ),
              //                         Text('₹ 1000'),
              //                       ],
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     height: 6,
              //                   ),
              //                   Container(
              //                       width: width,
              //                       child: Row(
              //                         mainAxisAlignment:
              //                         MainAxisAlignment
              //                             .center,
              //                         children: [
              //                           // Container(),
              //                           GestureDetector(
              //                             onTap: (){
              //                               provider.plusminusbtn();
              //                             },
              //                             child: Visibility(
              //                               visible: provider.plusminus,
              //
              //                               child: Row(
              //                                 children: [
              //                                   Container(
              //
              //                                     padding: EdgeInsets.fromLTRB(
              //                                         10, 3, 10, 3),
              //                                     decoration: BoxDecoration(
              //                                         color: red,
              //                                         borderRadius: BorderRadius.all( Radius.circular(4))),
              //                                     child: Text('+',style: TextStyle(color: Colors.white),),
              //                                   ),
              //                                   Container(padding: EdgeInsets.all(10),child: Text('0')),
              //                                   Container(
              //                                     padding: EdgeInsets.fromLTRB(
              //                                         10, 3, 10, 3),
              //                                     decoration: BoxDecoration(
              //                                         color: red,
              //                                         borderRadius: BorderRadius.all( Radius.circular(4))),
              //                                     child: Text('-',style: TextStyle(color: Colors.white),),
              //                                   ),
              //
              //                                 ],
              //                               ),
              //                             ),
              //                           ),
              //                           GestureDetector(
              //                             onTap: (){
              //                               provider.addbtn();
              //                             },
              //                             child: Visibility(
              //                               visible: provider.add_btn,
              //                               child: Container(
              //
              //                                 // margin: EdgeInsets.only(
              //                                 //     right: 0),
              //                                 padding: EdgeInsets.fromLTRB(
              //                                     20, 3, 20, 3),
              //
              //                                 alignment: Alignment.center,
              //                                 decoration: BoxDecoration(
              //                                     color: red,
              //                                     borderRadius:
              //                                     BorderRadius.all(
              //                                       Radius.circular(4),
              //                                     )),
              //                                 child: Text(
              //                                   'ADD',
              //                                   style: TextStyle(
              //                                       fontSize: 16,
              //                                       color: Colors.white),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ],
              //                       ))
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //         Container(width: 1,height: 270,color: Colors.black.withOpacity(0.1),),
              //       }
              //
              //     ],
              //   ),
              // ),
              SizedBox(height: 10,),
              Container(
                width: width,
                child: Text('Newly Launch',style: TextStyle(fontSize: 18,color: red),),
              ),
              Container(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.myNewProduct==null?0:provider.myNewProduct.length,
                  itemBuilder: (context, index) {
                    return DashboardProductItem(provider.myNewProduct[index],
                      (provider.PRODUCT_DET!=null && provider
                          .myNewProduct[index]['product_id']==provider.PRODUCT_DET['product_id'] &&
                          provider.loading_add_to_cart),
                      onTap: (){
                        Navigator.pushNamed(context,RouteNames.route_product_details,arguments: [
                          provider.myNewProduct[index],
                          provider],
                        );

                      },
                      onVariantChange:(_variant){
                        provider.setSelectedVarient(index,_variant,prod_type: 'N');
                      } ,
                      onAddToCart: (_type,_indx){
                        provider.addToCart(index,_type, context,prod_type: 'N');

                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: width,
                child: Text('Categories',style: TextStyle(fontSize: 18,color: red),),
              ),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: provider.cat_list.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  print('ImageUrl--------------------------------------\n${provider.cat_list[index]['imagepath']}');
                  return InkWell(
                    onTap: () {
                      context.read<HomeViewModel>().header_data=null;
                      context.read<HomeViewModel>().cat_id = int.parse(provider.cat_list[index]['cat_id'].toString());
                      context.read<HomeViewModel>().child_cat_id = 0;
                      context.read<HomeViewModel>().sub_cat_id = 0;
                      context.read<HomeViewModel>().selectedIndexOfNavigation(
                          2);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(2,10,2,10),
                      //  padding: EdgeInsets.all(10),
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          final itemHeight = constraints.maxHeight;
                          final imageAndSpacingHeight = itemHeight * 0.7;
                          final textHeight = itemHeight * 0.3;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(

                                    child: Container(
                                      // margin: EdgeInsets.fromLTRB(10,10,10,10),
                                        height: 70,
                                        width: 70,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.lightGreen.withOpacity(0.10),
                                          radius: 50,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: (provider.cat_list[index]['cat_image']==null||provider.cat_list[index]['cat_image']=='')?
                                            Image.asset('assests/images/no_image.png',fit: BoxFit.fitHeight, height: 50,):
                                            Image.network('${provider.cat_list[index]['imagepath']==null?"":provider.cat_list[index]['imagepath']}',fit: BoxFit.fitHeight, height: 50,),
                                          ),
                                        )
                                    ),
                                  )
                              ),
                              SizedBox(height: (itemHeight - imageAndSpacingHeight - textHeight) / 2),
                              Column(
                                children: [

                                  Text(
                                    '${provider.cat_list[index]['name']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500// Assuming 'black' is a Color variable
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              )



            ],
          ),
        ),
      ],
    );
  }
}
