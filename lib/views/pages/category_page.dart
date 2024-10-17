import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/res/app_urls.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/views/home_screen.dart';
import 'package:royal_dry_fruit/views/pages/sub_catlist_page.dart';

import '../../view_models/category_viewmodel.dart';
import '../../view_models/home_viewmodel.dart';
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  ScrollController mScrollController=ScrollController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      CategoryViewModel pro=Provider.of(context,listen: false);
      pro.getCategory(context);
    });
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
  @override
  Widget build(BuildContext context) {
    CategoryViewModel provider = Provider.of(context);
    HomeViewModel home_provider = Provider.of(context);




    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // color: Colors.red,
        child: SingleChildScrollView(
          controller: mScrollController,
          child: provider.loading?Center(child: CircularProgressIndicator(),):
          Column(
            children: provider.cat_list.map((cat_mod) {
              print('CCCCCCCCCCCCCCCCCC- ${cat_mod['cat_id']}');
              print('DDDDDDDDDDDDDDDDD- ${cat_mod['subcat']}');
              if(cat_mod['subcat']==null){
                return Container(height: 0,);
              }else {
                return getCatItem(context, cat_mod, provider,home_provider);
              }

            }).toList(),
          ),
        )


    );
  }

  Widget getCatItem(BuildContext context,Map<String, dynamic> cat_mod,CategoryViewModel provider,HomeViewModel homeViewModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "${cat_mod['category']}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              Spacer(

              ),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.route_subcategory_screen,arguments: [cat_mod,provider,homeViewModel]).then((value) {
                      Utils.prinAppMessages("Result Back :$value");

                      context.read<HomeViewModel>().header_data=(value as List)[0]['data'];

                      // If category then from category array part will go to next screen.
                      if( value!=null && value[0]['type']=='sub_cat' ){

                        context
                            .read<HomeViewModel>()
                            .sub_cat_id = int.parse(value[0]['data']['sub_cat_id'].toString());

                        context
                            .read<HomeViewModel>()
                            .cat_id = 0;

                        context.read<HomeViewModel>().selectedIndexOfNavigation(
                            2);
                      }else if(value!=null && value[0]['type']=='cat') {
                        context
                            .read<HomeViewModel>()
                            .cat_id = int.parse(value[0]['data']['cat_id']);
                        context
                            .read<HomeViewModel>()
                            .sub_cat_id = 0;
                        context.read<HomeViewModel>().selectedIndexOfNavigation(
                            2);
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(width: 1,color: Colors.black54)
                    ),
                    child: Row(
                      children: [
                        Text("Explore",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12),),
                        Icon(Icons.navigate_next)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 8.0),
          Container(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cat_mod==null?0:(cat_mod['subcat'] as List).length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.read<HomeViewModel>().header_data=cat_mod['subcat'][index];
                    context.read<HomeViewModel>().cat_id = int.parse(cat_mod['subcat'][index]['cat_id'].toString());
                    context.read<HomeViewModel>().child_cat_id = 0;
                    context.read<HomeViewModel>().sub_cat_id = int.parse(cat_mod['subcat'][index]['sub_cat_id'].toString());
                    context.read<HomeViewModel>().selectedIndexOfNavigation(
                        2);
                  },
                  child: Container(
                    width: 140,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex:2,child: Material(
                              elevation: 5,
                              color: Colors.green,//.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  '${AppUrls.FILE_UPLOAD_PATH}${cat_mod['subcat'][index]['subcat_image']}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(

                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: Center(
                                  child: Text(
                                    '${cat_mod['subcat'][index]['subCat_name']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )

                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


