import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/view_models/category_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/filter_viewmodel.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController; // Declare TabController

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2, // Number of tabs
      vsync: this, // Use 'this' as the vsync parameter
    );
    Future.microtask(() {
      CategoryViewModel pro=Provider.of(context,listen: false);
      pro.getCategory(context);
    });

  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of TabController
    super.dispose();
  }

  late CategoryViewModel categoryViewModel;
  late FilterViewmodel filterViewmodel;
  @override
  Widget build(BuildContext context) {
    categoryViewModel=Provider.of(context);
    filterViewmodel=Provider.of(context);
    var green = Color(0xFF689f39);
    var darkgrey = Color(0xFF7b7c7a);
    var red = Color(0xFFf17523);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: green,
            child: Icon(Icons.close),
          ),
        ),
       // backgroundColor:green,
        title: Text(
          'Filter',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          // Container(
          //   color: green,
          //   padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          //   child: Icon(Icons.search),
          // ),
        ],

        bottom: TabBar(

          indicatorColor: Colors.black,
          // Indicator color (bottom line)
          labelColor: Colors.white, // Selected tab label color
          unselectedLabelColor: Colors.white60, // Unselected tab label color
          // Change TabBar background color
          labelStyle: TextStyle(// Background color of selected tab
          ),
          controller: _tabController,

          // Assign TabController to TabBar
          tabs: [

            Tab(text: 'Refine by',),
            Tab(text: 'Sort by'),
          ],

        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController, // Assign TabController to TabBarView
                  children: [

                    Theme(
                      data: ThemeData(dividerColor: Colors.transparent),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 100),
                          child: Column(
                            children: [
                              categoryViewModel.loading?CircularProgressIndicator():ExpansionTile(
                                title: Text('Categories',style: TextStyle(fontWeight: FontWeight.w500),),
                                textColor: Colors.black.withOpacity(0.8),
                                iconColor: darkgrey,
                                initiallyExpanded: false,
                                collapsedIconColor: darkgrey,
                                collapsedTextColor: darkgrey,
                                backgroundColor: Colors.transparent,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20,5,20,5),
                                    child: Column(
                                      children:
                                        categoryViewModel.cat_list.map((e) =>
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('${e['category']}',style: TextStyle(color: darkgrey),),
                                                Checkbox(value: e['is_selected']==null?false:e['is_selected'], onChanged: (bool? value) {
                                                  categoryViewModel.setSelected(e,value!);
                                                  filterViewmodel.addFilter(value,e['cat_id']);
                                                },)
                                              ],
                                            ),).toList()
                                      // [
                                      //   Row(
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       Text('Fruits & Vegetables',style: TextStyle(color: darkgrey),),
                                      //       Checkbox(value: false, onChanged: (bool? value) {  },)
                                      //     ],
                                      //   ),
                                      //   Row(
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       Text('Fresh Fruits',style: TextStyle(color: darkgrey)),
                                      //       Checkbox(value: false, onChanged: (bool? value) {  },)
                                      //     ],
                                      //   ),
                                      // ],
                                    ),
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: Text('Price',style: TextStyle(fontWeight: FontWeight.w500),),
                                textColor: Colors.black.withOpacity(0.8),
                                iconColor: darkgrey,
                                initiallyExpanded: false,
                                collapsedIconColor: darkgrey,
                                collapsedTextColor: darkgrey,
                                backgroundColor: Colors.transparent,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20,5,20,5),
                                    child: Column(
                                      children: filterViewmodel.filterPriceList.map((e) =>
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${e.filterName}',style: TextStyle(color: darkgrey)),
                                              Checkbox(value: e.isSelected, onChanged: (bool? value) {
                                                filterViewmodel.setPriceFilter( value!,e);
                                              },)
                                            ],
                                          ),
                                      ).toList(),


                                    ),
                                  ),
                                ],
                              ),
                              // ExpansionTile(
                              //   title: Text('Brands',style: TextStyle(fontWeight: FontWeight.w500),),
                              //   textColor: Colors.black.withOpacity(0.8),
                              //   iconColor: darkgrey,
                              //   initiallyExpanded: false,
                              //   collapsedIconColor: darkgrey,
                              //   collapsedTextColor: darkgrey,
                              //   backgroundColor: Colors.transparent,
                              //   children: [
                              //     Container(
                              //       margin: EdgeInsets.fromLTRB(20,5,20,5),
                              //       child: Column(
                              //         children: [
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              ExpansionTile(
                                title: Text('Product Rating',style: TextStyle(fontWeight: FontWeight.w500),),
                                textColor: Colors.black.withOpacity(0.8),
                                iconColor: darkgrey,
                                initiallyExpanded: false,
                                collapsedIconColor: darkgrey,
                                collapsedTextColor: darkgrey,
                                backgroundColor: Colors.transparent,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20,5,20,5),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('🌟🌟🌟',style: TextStyle(color: darkgrey)),
                                            Checkbox(value: false, onChanged: (bool? value) {  },)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('🌟🌟🌟🌟',style: TextStyle(color: darkgrey)),
                                            Checkbox(value: false, onChanged: (bool? value) {  },)
                                          ],
                                        ),Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('🌟🌟🌟🌟🌟',style: TextStyle(color: darkgrey)),
                                            Checkbox(value: false, onChanged: (bool? value) {  },)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20,5,20,5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Relevance',style: TextStyle(color: darkgrey)),
                              Radio(value: SORT_BY.RELE, groupValue: filterViewmodel.selected_sort, onChanged: ( value) {
                                filterViewmodel.setSort(1, SORT_BY.RELE);
                              },)
                            ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Price - Low to High',style: TextStyle(color: darkgrey)),
                              Radio(value: SORT_BY.LTOH, groupValue: filterViewmodel.selected_sort, onChanged: ( value) {
                                filterViewmodel.setSort(2, SORT_BY.LTOH);

                              },)
                            ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Price - High to Low',style: TextStyle(color: darkgrey)),
                              Radio(value: SORT_BY.HTOL, groupValue: filterViewmodel.selected_sort, onChanged: ( value) {
                                filterViewmodel.setSort(3,  SORT_BY.HTOL);
                              },)
                            ],),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Rupee Saving - High to Low',style: TextStyle(color: darkgrey)),
                          //     Radio(value: false, groupValue: null, onChanged: ( value) {  },)
                          //   ],),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Rupee Saving - Low to High',style: TextStyle(color: darkgrey)),
                          //     Radio(value: false, groupValue: null, onChanged: ( value) {  },)
                          //   ],),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('% Off - High to Low',style: TextStyle(color: darkgrey)),
                          //     Radio(value: false, groupValue: null, onChanged: ( value) {  })
                          //   ],)
                        ],
                      ),
                    ),

                    // Sort by TabView content

                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color:Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 1,
                    color: darkgrey,
                  ),

                  Container(
                    margin: EdgeInsets.all(20),
                    height: 50,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: darkgrey,
                              border: Border.all(
                              color: darkgrey,
                              width: 1
                          )
                          ),
                          child: Text('CLEAR ALL',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            var lst=filterViewmodel.filter;
                            String cat_filter="";
                            for(int i=0;i<lst.length;i++){

                                cat_filter = cat_filter +lst[i]+",";

                            }
                            if(cat_filter.endsWith(",")){
                              cat_filter=cat_filter.substring(0,cat_filter.length-1);
                            }

                            String price_filter=filterViewmodel.getPriceSelectedFilter();
                            String sort_by="";
                            if(filterViewmodel.selected_sort==SORT_BY.RELE){
                              sort_by="";
                            }else if(filterViewmodel.selected_sort==SORT_BY.LTOH){
                              sort_by="ASC";
                            }if(filterViewmodel.selected_sort==SORT_BY.HTOL){
                              sort_by="DESC";
                            }
                            print('Filter= ${cat_filter} price_filter:$price_filter SortBy:${filterViewmodel.selected_sort} ==$sort_by');
                            Navigator.pop(context, [
                              {
                                'price_filter':price_filter,
                                'sort_by': sort_by,
                                'cat_filter':cat_filter
                              }
                            ]);
                          },
                          child: Container(

                            padding: EdgeInsets.all(8),
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: darkgrey,
                                    width: 1
                                )
                            ),
                            child: Text('DONE',style: TextStyle(fontWeight: FontWeight.w500,color: darkgrey),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
