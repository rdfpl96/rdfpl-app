import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/res/colors.dart';
import 'package:royal_dry_fruit/res/theme.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/view_models/product_viewmodel.dart';
import '../../res/app_urls.dart';
import '../../res/components/product_item.dart';
import '../../utils/routes/routes_name.dart';
import '../../view_models/subcategory_viewmodel.dart';

class SubCatListPage extends StatelessWidget {
  SubCatListPage({Key? key}) : super(key: key);
  late SubCategoryViewModel provider;
  final paddingMain = EdgeInsets.symmetric(vertical: 20, horizontal: 10);

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SubCategoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () { Navigator.pop(context); },
          child: Container(color: kGreen, child: Icon(CupertinoIcons.back)),
        ),
        backgroundColor: kGreen,
        title: Text('Category', style: TextStyle(fontSize: 16, color: Colors.white)),
        centerTitle: true,
        actions: [
          // Container(color: kGreen, padding: EdgeInsets.fromLTRB(20, 0, 20, 0), child: Icon(Icons.search)),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: paddingMain,
                child: Text(
                  'Shop By Category',
                  style: kSmallDarkText.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 15),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (provider.data['subcat'] as List).length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        try {
                          //Utils.showFlushbarError("Ok ${provider.data['sub_cat'][index]['sub_cat_id']}", context);
                          // Utils.showFlushbarError("Cliked ID:${provider
                          //     .data['sub_cat'][index]['sub_cat_id']}", context);
                          //provider.onCategoryClick(provider.data['sub_cat'][index]['sub_cat_id']);
                          // Map map=
                          Navigator.pop(context, [
                            {
                              'type':'sub_cat',
                              'data': provider.data['subcat'][index]
                            }
                          ]);
                        }catch(e){
                          Utils.showFlushbarError("$e", context);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.lime.withOpacity(0.5),
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Image.network('${AppUrls.FILE_UPLOAD_PATH}${provider.data['subcat'][index]['subcat_image']}'),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('${provider.data['subcat'][index]['subCat_name']}', maxLines: 3, textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: paddingMain,
                child: Text(
                  "View All",
                  style: kSmallDarkText.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: provider.data_list.length,
          itemBuilder: (context, index) {
            Widget _mainWidget= ProductItem(FROM.PRODUCT,provider.data_list[index],
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

            if(index==provider.data_list.length-1){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _mainWidget,
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: () {
                      print("-------------------------------------------------View All");
                      Navigator.pop(context,[
                        {
                          'type':'cat',
                          'data': provider.data}
                      ]/*provider.data['cat_id']*/);

                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View All',style: kSmallDarkText.copyWith(color: CupertinoColors.destructiveRed,fontWeight: FontWeight.bold,fontSize: 18),),
                        SizedBox(width: 10,),
                        CircleAvatar(radius:15,
                            backgroundColor: Colors.grey.shade100,
                            child: Icon(Icons.navigate_next))
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),


                ],
              );
            }else{return _mainWidget;}

          },
        ),
      ),
    );
  }
}
