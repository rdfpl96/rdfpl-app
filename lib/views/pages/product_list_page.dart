import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:royal_dry_fruit/res/components/product_item.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/view_models/home_viewmodel.dart';

import '../../res/components/add_to_cart_button.dart';
import '../../utils/Utils.dart';
import '../../view_models/product_viewmodel.dart';
import '../home_screen.dart';
import '../interfaces/on_scroll_change_listeners.dart';
import '../../res/components/product_item.dart';

class ProductListPage extends StatefulWidget {
  Function? onLoadMore;
  int cat_id;
  int sub_cat_id;
  int child_cat_id=0;
  var header_data;
   ProductListPage({required this.cat_id,required this.sub_cat_id,required this.child_cat_id,required this.header_data,super.key,this.onLoadMore});


  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> implements OnScrollChangeListener {
  ScrollController mScrollController=ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ProductViewModel productViewModel = Provider.of(context, listen: false);
      try {
        provider.data_list=[];
        provider.setLoading(true);
        productViewModel.getProduct(
            context, widget.cat_id, widget.sub_cat_id, widget.child_cat_id, 1);
      } catch (e) {}
    });


    // scrollController.addListener(_loadMOreData);
    mScrollController.addListener(() {

      if (mScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        print('Product Scrolling Up Current=${mScrollController.position.pixels} & MAX=${mScrollController.position.maxScrollExtent} MIN=${mScrollController.position.minScrollExtent}');

        // if(mScrollController.position.pixels<100) {
        if(mScrollController.position.minScrollExtent==mScrollController.position.pixels) {

          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn,);
        }else if(scrollController.position.maxScrollExtent==scrollController.position.pixels){
          // print('Up Scrolling to Last Reach:${mScrollController.position.pixels} & ${mScrollController.position.maxScrollExtent}');
            scrollController.jumpTo(0);
        }
      }
      else if (mScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {

        print('Product Scrolling Down Current=${mScrollController.position.pixels} & MAX=${mScrollController.position.maxScrollExtent} MIN=${mScrollController.position.minScrollExtent}');

        // if(mScrollController.position.pixels<100) {
        if(mScrollController.position.maxScrollExtent==mScrollController.position.pixels) {

          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn,);
        }
        // print('Product Scrolling Down');
        // if(mScrollController.position.pixels==500) {
        //
        //   scrollController.animateTo(
        //     scrollController.position.maxScrollExtent,
        //     duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn,);
        // }

      }

      // print('Scroll Position: ${mScrollController.position.pixels}');
      // print('Scroll position condition:${mScrollController.position.pixels == mScrollController.position.maxScrollExtent}');
      // if(mScrollController.position.pixels<100){
      //   print('Start Scrolling Main');
      //   if(scrollController.position.pixels!=0) {
      //     print('Succeeds Scrolling Main');
      //     scrollController.animateTo(
      //       0, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn,);
      //   }
      // }
    });
  }


  String selectedValue = '';
  late ProductViewModel provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    HomeViewModel provider_home=Provider.of(context);
    double width = MediaQuery.of(context).size.width;

    Utils.prinAppMessages("Product Refreshing..cat=${widget.cat_id} subcat=${widget.sub_cat_id} childcat=${widget.child_cat_id}");
    Utils.prinAppMessages("Product Refreshing.........................................");

    var green = Color(0xFF689f39);
    var darkgrey = Color(0xFF7b7c7a);
    var red = Color(0xFFf17523);

    var selectedValue;
    var filter_data=null;
    if(widget.cat_id!=0 && widget.sub_cat_id!=0 && widget.header_data!=null){
      filter_data=widget.header_data['child'];
    }else if(widget.cat_id!=0 && widget.sub_cat_id==0 && widget.header_data!=null){
      filter_data=widget.header_data['subcat'];
    }

    return Container(

      // color: Colors.red,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if((widget.cat_id!=0 || widget.sub_cat_id!=0)&& filter_data!=null)...{

            Container(
            color: Colors.grey.withOpacity(0.4),
            child: Container(
                  color: Colors.grey.withOpacity(0.4),
                  child: SizedBox(
                    height: 50, // Set a fixed height for the header
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:(filter_data as List).length,
                      // itemCount: widget.cat_id!=0?(widget.header_data['subcat'] as List).length:(widget.header_data['child'] as List).length,
                      itemBuilder: (context, index) {
                        if(widget.cat_id!=0 && widget.sub_cat_id!=0) {
                          return txtbox('${filter_data[index]['childCat_name']}',
                                  ()async{

                               // widget.header_data=null;
                                widget.child_cat_id=int.parse(filter_data[index]['child_cat_id'].toString());
                                print('Changing Child Cat Id:${widget.child_cat_id}');
                                await provider.getProduct(context, widget.cat_id, widget.sub_cat_id,widget.child_cat_id,1);
                              });

                        }else if(widget.cat_id!=0 && widget.sub_cat_id==0){
                          return txtbox('${filter_data[index]['subCat_name']}',
                                  ()async{
                                    widget.header_data=filter_data[index];
                                widget.sub_cat_id=int.parse(filter_data[index]['sub_cat_id'].toString());
                                print('Changing Sub Cat Id:${widget.sub_cat_id}');
                                await provider.getProduct(context, widget.cat_id, widget.sub_cat_id,widget.child_cat_id,1);
                              });
                        }
                      },
                    ),
                  ),

                )
          ),
          },
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      '${provider.data_list==null?0:provider.data_list.length} items',
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius:
                    BorderRadius.all(Radius.circular(4)),
                  ),
                  child: GestureDetector(
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
                        provider.filterProducts(context, widget.cat_id, widget.sub_cat_id, widget.child_cat_id,);
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.tune,
                          color: Colors.white,
                        ),
                        Text(
                          'Filter',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            // color: Colors.green,
            height: MediaQuery.of(context).size.height,
              child:
              (provider.loading && provider.currentPage==1)?
              Center(child: Column(
                children: [
                  SizedBox(height: 100,),
                  CircularProgressIndicator(),
                ],
              ),)
                  : (provider.data_list==null || provider.data_list.isEmpty)?
              Center(child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 100,),
                  Image.asset('assests/images/no_data.png',height: 100,width: 100,),
                  Text('No Data Found'),
                ],
              ),)
                  : SmartRefresher(
                controller: provider.refreshController,
                onRefresh: () => provider.onRefresh(context,widget.cat_id,widget.sub_cat_id,widget.child_cat_id),
                onLoading: () =>provider.loadMoreData(widget.cat_id,widget.sub_cat_id,widget.child_cat_id,),
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
                  controller: mScrollController,
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
                          provider_home],
                        ).then((value) => provider.checkForCartQty());
                      },
                      onVariantChange:(_variant){
                        provider.setSelectedVarient(index,_variant);
                      } ,
                      onAddToCart: (_type,_indx){
                        provider.addToCart(index,_type, context);

                      },

                    );
                    return Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(bottom: index==provider.data_list.length-1?MediaQuery.of(context).size.height*0.2:20,top: 20,left: 20,right: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print('onNext line 211 ShopScreen');

                                  Navigator.pushNamed(context,RouteNames.route_product_details,arguments: provider
                                      .data_list[index]['product_id']
                                      .toString(),);

                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.2),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Image.network(
                                        '${provider
                                            .data_list[index]['imageUrl']}${provider
                                            .data_list[index]['image1']}',
                                      )),
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                          width: width,
                                          child: Text(
                                            '${provider
                                                .data_list[index]['category']}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          )),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Container(
                                          width: width,
                                          child: Text(
                                            '${provider
                                                .data_list[index]['product_name']}',
                                            maxLines: 2,
                                            overflow: TextOverflow
                                                .ellipsis,
                                          )),
                                      SizedBox(
                                        height: 6,
                                      ),


                                      DropdownButtonFormField<dynamic>(
                                        isDense: true,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets
                                                .symmetric(horizontal: 5),
                                            isDense: true,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius
                                                    .all(
                                                    Radius.circular(5))
                                            )
                                        ),
                                        value: provider.getSelected(index),
                                        items: provider
                                            .data_list[index]['variants']
                                            .map<
                                            DropdownMenuItem<dynamic>>((
                                            item) {
                                          return DropdownMenuItem<
                                              dynamic>(
                                            value: item,
                                            child: Text(
                                                item['pack_size'] + ' ' +
                                                    item['units']),
                                          );
                                        }).toList(),

                                        onChanged: (value) {
                                          provider.setSelectedVarient(index,value);
                                        },
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Container(
                                        width: width,
                                        child: Row(
                                          children: [
                                            Text('₹ ${getSelectedPrice(provider,index)}'),
                                            // SizedBox(
                                            //   width: 4,
                                            // ),
                                            // Text('₹ 1000'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      // AddToCartButton(provider.getSelected(index)['qty'],
                                      //     width: MediaQuery.of(context).size.width*10,
                                      //     height: 30,
                                      // onTap: (operation){
                                      //   provider.addToCart(index, operation, context);
                                      // }),
                                      // if(provider.data_list[index]['qty']==null)...{
                                      if(provider.getSelected(index)['qty']==null)...{
                                        Container(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Container(),
                                              GestureDetector(
                                                onTap: () {
                                                  provider.addToCart(
                                                      index, '+', context);
                                                },
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.only(
                                                      right: 20),
                                                  padding: EdgeInsets
                                                      .fromLTRB(
                                                      20, 3, 20, 3),
                                                  alignment: Alignment
                                                      .center,
                                                  decoration: BoxDecoration(
                                                      color: red,
                                                      borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(5),
                                                      )),
                                                  child: Text(
                                                    'ADD',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                      },
                                      SizedBox(
                                        height: 6,
                                      ),
                                      // if(provider.data_list[index]['qty']!=null)...{
                                      if(provider.getSelected(index)['qty']!=null)...{
                                        Container(
                                        // width:150,
                                        padding: EdgeInsets.all(0),
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
                                                  provider.addToCart(index,'-', context);
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
                                              '${provider.getSelected(index)['qty']==null?'0':provider.getSelected(index)['qty']}',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            SizedBox(width: 30),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  provider.addToCart(index,'+', context);                                                },
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
                                      ),
                                      },
                                      if((provider.PRODUCT_DET!=null && provider
                                          .data_list[index]['product_id']==provider.PRODUCT_DET['product_id'] &&
                                          provider.loading_add_to_cart))...{
                                        Container(
                                          padding:EdgeInsets.only(top: 5,bottom: 5),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      },

                                    ],
                                  )),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: width,
                            height: 1,
                            color: Colors.black.withOpacity(0.2),
                          )
                        ],
                      ),
                    );
                    // return Card(
                    //   child: Text('Wkdjd: $index'),
                    // );
                  },),
              )

            ),

        ],
      ),
    );
  }

  //
  // void _loadMOreData()async {
  //
  //   if(scrollController.position.pixels == scrollController.position.maxScrollExtent) {
  //     provider.loadMoreData();
  //   }
  // }

  @override
  onLoadMore() {

  }


  getSelectedPrice(ProductViewModel provider, int index) {
    for(int i=0;i<(provider.data_list[index]['variants']as List).length;i++){
      if(provider.data_list[index]['variants'][i]['is_selected']==true){
        return provider.data_list[index]['variants'][i]['price'];
      }
    }
  }

}
txtbox(String s,void Function() click) {
  return InkWell(
    onTap: click,
    child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white),
        padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
        margin: EdgeInsets.all(10),
        child: Text(s)),
  );
}