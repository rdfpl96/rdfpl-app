
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:royal_dry_fruit/res/components/product_item.dart';
import 'package:royal_dry_fruit/view_models/search_product_viewmodel.dart';

import '../utils/Utils.dart';
import '../utils/routes/routes_name.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _searchFocusNode = FocusNode(); // Create a FocusNode


  @override
  void initState() {
    super.initState();
    // Set focus to the TextFormField when the screen opens
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void dispose() {
    // Dispose of the FocusNode to avoid memory leaks
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SearchProductViewModel provider=Provider.of(context);
    
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var green = Color(0xFF689f39);
    var darkgrey = Color(0xFF7b7c7a);
    var red = Color(0xFFf17523);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(toolbarHeight: 0,elevation: 0,),
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverAppBar(
                leading: Container(),
                floating: false,
                expandedHeight: 120.0,
                pinned: true,
                toolbarHeight: 120,
                shadowColor: Colors.transparent,
                flexibleSpace: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child:  Container(
                                    color: green,
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    height: 40,
                                    width: 40,
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Icon(CupertinoIcons.back,color: Colors.white,)
                                    ),
                                  )

                              )),
                          Container(alignment: Alignment.center,height: 50,margin: EdgeInsets.all(5),child: Text('Search Products',style: TextStyle(fontSize: 16,color: Colors.white),)),
                          Expanded(child: Container()),
                        ],
                      ),
                      // width: double.infinity,
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(15,0,15,0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.grey.shade100,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(

                          focusNode: _searchFocusNode, // Attach the FocusNode
                          onChanged: (value) => provider.serachProduct(value,1, context),
                          //   textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search Products',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
            SliverToBoxAdapter(
              child: (provider.loading && provider.currentPage==1)?Center(
                child:CircularProgressIndicator()
              ):
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey.withOpacity(0.4),
                      child: Row(
                        children: [
                          // txtbox('Dryfruits'),
                          // txtbox('Vegetables'),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.grey  .withOpacity(0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(margin: EdgeInsets.fromLTRB(10,0,0,0),child: Text('${provider.data_list.length} items', style: TextStyle(color: Colors.grey),)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, RouteNames.route_filter_screen).then((value) {
                                        /* {
                                           'price_filter':price_filter,
                                          'sort_by': sort_by,
                                          'cat_filter':cat_filter
                                        }*/
                                print('filters: ${value}');
                                List list=value as List;
                                provider.filterbyPrice=list[0]['price_filter'];
                                provider.short_by=list[0]['sort_by'];
                                provider.cat_filter=list[0]['cat_filter'];
                                provider.filterProducts(provider.search,context,);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10,5,10,5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.tune,color: Colors.white,),
                                  Text('Filter',style: TextStyle(color: Colors.white),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SmartRefresher(
                        controller: provider.refreshController,
                        onRefresh: () => provider.onRefresh(context),
                        onLoading: () =>provider.loadMoreData(),
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropHeader(),
                        footer: CustomFooter(
                          builder: (context, mode) {
                            Widget body ;
                            if(mode==LoadStatus.idle){
                              body =  Text("pull up load");
                            }
                            else if(mode==LoadStatus.loading){
                              body =  CupertinoActivityIndicator();
                            }
                            else if(mode == LoadStatus.failed){
                              body = Text("Load Failed!Click retry!");
                            }
                            else if(mode == LoadStatus.canLoading){
                              body = Text("release to load more");
                            }
                            else{
                              body = Text("No more Data");
                            }
                            return Container(
                              height: 55.0,
                              child: Center(child:body),
                            );
                          },
                        ),
                        child:
                        ListView.builder(
                          primary: false,
                          // controller: mScrollController,
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: provider.data_list.length,
                          itemBuilder: (context, index) {
                            return ProductItem(FROM.PRODUCT,provider.data_list[index],
                              (provider.PRODUCT_DET!=null && provider
                                  .data_list[index]['product_id']==provider.PRODUCT_DET['product_id'] &&
                                  provider.loading_add_to_cart) ,
                              onTap: (){

                                Navigator.pushNamed(context,RouteNames.route_product_details,arguments: [
                                  provider.data_list[index],
                                  provider.homeViewModel],
                                ).then((value) => provider.checkForCartQty());
                              },
                              onVariantChange:(_variant){
                                provider.setSelectedVarient(index,_variant);
                              } ,
                              onAddToCart: (_type,_indx){
                                provider.addToCart(index,_type, context);

                              },

                            );

                          },),
                      ),
                    )
                    // for(int index=0;index<provider.data_list.length;index++)...{
                    //   Container(
                    //     color: Colors.white,
                    //     padding: EdgeInsets.only(bottom: index==provider.data_list.length-1?MediaQuery.of(context).size.height*0.2:20,top: 20,left: 20,right: 20),
                    //     child: Column(
                    //       children: [
                    //         Row(
                    //           children: [
                    //             GestureDetector(
                    //               onTap: () {
                    //                 print('onNext line 211 ShopScreen');
                    //
                    //                 Navigator.pushNamed(context,RouteNames.route_product_details,arguments: provider
                    //                     .data_list[index]['product_id']
                    //                     .toString(),);
                    //
                    //               },
                    //               child: Container(
                    //                 margin: EdgeInsets.all(10),
                    //                 decoration: BoxDecoration(
                    //                   borderRadius:
                    //                   BorderRadius.all(Radius.circular(10)),
                    //                   boxShadow: [
                    //                     BoxShadow(
                    //                       color: Colors.grey.withOpacity(
                    //                           0.2),
                    //                       spreadRadius: 3,
                    //                       blurRadius: 5,
                    //                       offset: Offset(0, 0),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 child: Container(
                    //                     padding: EdgeInsets.all(10),
                    //                     height: 150,
                    //                     width: 150,
                    //                     decoration: BoxDecoration(
                    //                         color: Colors.white,
                    //                         borderRadius: BorderRadius.all(
                    //                             Radius.circular(10))),
                    //                     child: Image.network(
                    //                       'https://uat.rdfpl.com/uploads/${provider
                    //                           .data_list[index]['image1']}',
                    //                     )),
                    //               ),
                    //             ),
                    //             Expanded(
                    //                 child: Column(
                    //                   children: [
                    //                     Container(
                    //                         width: width,
                    //                         child: Text(
                    //                           '${provider
                    //                               .data_list[index]['category']}',
                    //                           style: TextStyle(
                    //                               fontSize: 12,
                    //                               color: Colors.grey),
                    //                         )),
                    //                     SizedBox(
                    //                       height: 6,
                    //                     ),
                    //                     Container(
                    //                         width: width,
                    //                         child: Text(
                    //                           '${provider
                    //                               .data_list[index]['product_name']}',
                    //                           maxLines: 2,
                    //                           overflow: TextOverflow
                    //                               .ellipsis,
                    //                         )),
                    //                     SizedBox(
                    //                       height: 6,
                    //                     ),
                    //                     Container(
                    //                       width: width,
                    //                       child: Row(
                    //                         children: [
                    //                           Text('${provider
                    //                               .data_list[index]['pack_size']}${provider
                    //                               .data_list[index]['units']}'),
                    //                           // SizedBox(
                    //                           //   width: 4,
                    //                           // ),
                    //                           // Text('₹ 1000'),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     SizedBox(
                    //                       height: 6,
                    //                     ),
                    //                     Container(
                    //                       width: width,
                    //                       child: Row(
                    //                         children: [
                    //                           Text('₹ ${provider
                    //                               .data_list[index]['price']}'),
                    //                           // SizedBox(
                    //                           //   width: 4,
                    //                           // ),
                    //                           // Text('₹ 1000'),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     SizedBox(
                    //                       height: 6,
                    //                     ),
                    //                     Container(
                    //                         width: width,
                    //                         child: Row(
                    //                           mainAxisAlignment:
                    //                           MainAxisAlignment
                    //                               .spaceBetween,
                    //                           children: [
                    //                             Container(),
                    //                             Container(
                    //                               margin:
                    //                               EdgeInsets.only(
                    //                                   right: 20),
                    //                               padding: EdgeInsets
                    //                                   .fromLTRB(
                    //                                   20, 3, 20, 3),
                    //                               alignment: Alignment
                    //                                   .center,
                    //                               decoration: BoxDecoration(
                    //                                   color: red,
                    //                                   borderRadius:
                    //                                   BorderRadius.all(
                    //                                     Radius.circular(5),
                    //                                   )),
                    //                               child: Text(
                    //                                 'ADD',
                    //                                 style: TextStyle(
                    //                                     fontSize: 16,
                    //                                     color: Colors
                    //                                         .white),
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ))
                    //                   ],
                    //                 )),
                    //           ],
                    //         ),
                    //         Container(
                    //           margin: EdgeInsets.only(top: 10),
                    //           width: width,
                    //           height: 1,
                    //           color: Colors.black.withOpacity(0.2),
                    //         )
                    //       ],
                    //     ),
                    //   )
                    // }

                  ],
                ),
              ),
            ),
          ],
        ),


      )

    );
  }

  txtbox2(String s) {

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      // color: Colors.white
    ),padding: EdgeInsets.fromLTRB(10,6,10,6),margin: EdgeInsets.all(10),child: Text(s,style: TextStyle(color: Colors.black.withOpacity(0.5))),);
  }
}






