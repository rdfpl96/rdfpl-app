import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hidable/hidable.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/view_models/wishlist_viewmodel.dart';
import 'package:royal_dry_fruit/views/interfaces/on_scroll_change_listeners.dart';
import 'package:royal_dry_fruit/views/pages/category_page.dart';
import 'package:royal_dry_fruit/views/pages/home_page.dart';
import 'package:royal_dry_fruit/views/pages/product_list_page.dart';
import 'package:royal_dry_fruit/views/pages/wish_list_page.dart';
import 'package:royal_dry_fruit/views/pick_location_screen.dart';

import '../view_models/home_viewmodel.dart';

final ScrollController scrollController = ScrollController();

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // late WishListViewModel wishListViewModel;
  ProductListPage? productListPage;
  Function? onLoadMore;

  @override
  Widget build(BuildContext context) {

    // wishListViewModel=Provider.of(context);
    HomeViewModel provider = Provider.of(context);
    Utils.prinAppMessages("Refreshimng homescreen DEAdd;:::${provider.default_address}");
    productListPage = ProductListPage(
      cat_id: provider.cat_id,
      sub_cat_id: provider.sub_cat_id,
      child_cat_id: provider.child_cat_id,
      header_data: provider.header_data,
      onLoadMore: (double visibility, type) {
        provider.hidable = visibility;
      },
    );
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Utils.prinAppMessages('OnLoadMore');
      }
    });
    /*if(provider.selectedIndex==3){
      wishListViewModel.getProduct(context);
    }*/
    final _pageOptions = [
      HomePage(),
      //   Home_Screen(scrollController,context,_scaffoldKey),
      CategoryPage(),
      productListPage,
      WishListPage(/*provider: wishListViewModel*/),
      //
      // Home_Screen(scrollController,context,_scaffoldKey),
    ];


    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: provider.scaffoldKey,

      // appBar:Hidable(
      //   preferredWidgetSize: Size.fromHeight(kToolbarHeight+50),
      //   controller: scrollController,
      //   child: AppBar(
      //     toolbarHeight: kToolbarHeight,
      //     leading: GestureDetector(
      //         onTap: () {
      //           provider.scaffoldKey.currentState?.openDrawer();
      //         },
      //         child:  Container(
      //           padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      //           height: 40,
      //           alignment: Alignment.centerLeft,
      //           child: SizedBox(
      //             height: 30,
      //             width: 30,
      //             child: SvgPicture.asset(
      //               "assests/images/menu.svg",
      //               color: Colors.white,
      //             ),
      //           ),
      //         )
      //
      //     ),
      //     title: Container(width:40,child: Image.asset("assests/images/rd_logo.png")),
      //     actions: [
      //       GestureDetector(
      //           onTap: (){
      //             // Navigator.push(
      //             //   context,
      //             //   MaterialPageRoute(builder: (context) =>
      //             //       ChangeNotifierProvider(create: (context) => MyAccountViewModel(context),
      //             //         child:MyAccountScreen() ,
      //             //       ),
      //             //   ),
      //             // );
      //           },
      //           child:  Container(
      //             color: Colors.transparent,
      //             padding: EdgeInsets.fromLTRB(0,0,20,0),
      //             height: 40,
      //             alignment: Alignment.centerRight,
      //             child: SizedBox(
      //               height: 30,
      //               width: 30,
      //               child: SvgPicture.asset(
      //                 "assests/images/profile.svg",
      //                 color: Colors.white,
      //               ),
      //             ),
      //           )
      //
      //       ),
      //     ],
      //     /*shadowColor: Colors.transparent,toolbarHeight: 0,*/),
      // ),
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),

      drawer: Drawer(
        // backgroundColor: Color(0xFF689f39),
        child: provider.loading_address?CircularProgressIndicator():Column(
          children: [
            Container(
              height: 35,
              color: Color(0xFF689f39),
            ),
            Container(
              width: width,
              color: Color(0xFF689f39),
              child: provider.loading_address
                  ? Center(child: CircularProgressIndicator())
                  : provider.cust_details!= null
                      ? Padding(
                padding: EdgeInsets.only(top: kToolbarHeight/2,left: 15,right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${provider.cust_details['name']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                              Text('${provider.cust_details['mobile']}',style: TextStyle(fontSize: 14,color: Colors.white),),
                              SizedBox(height: 10,)
                            ],
                          ),
                      )
                      : Container(
                          margin: EdgeInsets.fromLTRB(60, 10, 60, 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(2),
                            ),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Text(
                            'Login/Sign up',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
            ),

            (provider.default_address==null || ((provider.default_address is List)?(provider.default_address as List).isEmpty:provider.default_address==null))?
                Container():Container(
              margin: EdgeInsets.all(10),
              //   padding: EdgeInsets.fromLTRB(15, 0, 15, 0),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Container(
                        padding: EdgeInsets.only(left: 2, right: 2),
                        child: SvgPicture.asset(
                          "assests/images/navigation.svg",
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      "${provider.default_address==null ?'':"${provider.default_address['area']}, ${provider.default_address['city']}, ${provider.default_address['state']}"}",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    padding: EdgeInsets.all(2),
                    child: Container(
                      margin: EdgeInsets.all(2),
                      child: Icon(
                        CupertinoIcons.pen,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey,
              width: width,
              height: 0.5,
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      //NavigateToScreen(context,main_screen());
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        color: Colors.grey.shade50,
                        width: width,
                        child: Text(
                          'Home',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 15,
                              fontWeight: FontWeight.w100),
                          textAlign: TextAlign.left,
                        )),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                      //     create: (context) => MyAccountViewModel(context),
                      //     child: MyAccountScreen(),
                      //   )),
                      // );
                      Navigator.pushNamed(
                          context, RouteNames.route_myaccount_screen,arguments: [provider]);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                      color: Colors.grey.shade50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('My Account',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w100)),
                          Icon(
                            CupertinoIcons.plus,
                            color: Colors.black.withOpacity(0.5),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.route_basket)
                          .then((value) {
                        provider.getBasketList();
                        provider.sub_cat_id = 0;
                        provider.child_cat_id = 0;
                        provider.cat_id = 0;
                        provider.header_data = null;
                        provider.selectedIndexOfNavigation(0);
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                        color: Colors.grey.shade50,
                        width: width,
                        child: Text(
                          'Basket / My List',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 15,
                              fontWeight: FontWeight.w100),
                          textAlign: TextAlign.left,
                        )),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      provider.changeSelectedIndex(1);
                      provider.scaffoldKey.currentState?.closeDrawer();
                      // setState(() {
                      //   _selectedIndex = 1;
                      //   _scaffoldKey.currentState?.closeDrawer();
                      // });
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                      color: Colors.grey.shade50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shop By Category',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w100)),
                          Icon(CupertinoIcons.right_chevron,
                              color: Colors.black.withOpacity(0.5), size: 20),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                      color: Colors.grey.shade50,
                      width: width,
                      child: Text(
                        'Offers',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 15,
                            fontWeight: FontWeight.w100),
                        textAlign: TextAlign.left,
                      )),
                  SizedBox(height: 20),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                      color: Colors.grey.shade50,
                      width: width,
                      child: Text(
                        'Customer Service',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 15,
                            fontWeight: FontWeight.w100),
                        textAlign: TextAlign.left,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Scaffold(
        // body: _pageOptions[provider.selectedIndex],
        body: SafeArea(
          child: CustomScrollView(controller: scrollController, slivers: [
            SliverAppBar(
              leading: Container(),
              floating: false,
              pinned: false,
              shadowColor: Colors.transparent,
              flexibleSpace: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              provider.scaffoldKey.currentState?.openDrawer();
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              height: 40,
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: SvgPicture.asset(
                                  "assests/images/menu.svg",
                                  color: Colors.white,
                                ),
                              ),
                            ))),
                    Container(
                        height: 50,
                        margin: EdgeInsets.all(5),
                        child: Image.asset("assests/images/rd_logo.png")),
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) =>
                              //       ChangeNotifierProvider(create: (context) => MyAccountViewModel(context),
                              //         child:MyAccountScreen() ,)),
                              // );
                              Navigator.pushNamed(
                                  context, RouteNames.route_myaccount_screen,arguments: [provider]);
                            },
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              height: 40,
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: SvgPicture.asset(
                                  "assests/images/profile.svg",
                                  color: Colors.white,
                                ),
                              ),
                            ))),
                  ],
                ),
                // width: double.infinity,
              ),
            ),
            SliverAppBar(
              leading: Container(),
              expandedHeight: 110.0,
              floating: false,
              pinned: true,
              toolbarHeight: 110,
              flexibleSpace: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context,
                            RouteNames.route_delivery_address_screen).then((value) => provider.getDefaultAddress(context));
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => SelectAddressMap(),));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Container(
                                padding: EdgeInsets.only(left: 6, right: 6),
                                child: SvgPicture.asset(
                                  "assests/images/navigation.svg",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${provider.getLocation()}",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100),
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            padding: EdgeInsets.all(2),
                            child: Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              padding: EdgeInsets.fromLTRB(6, 4, 4, 4),
                              child: Image.asset(
                                "assests/images/next.png",
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchScreen()));
                      Navigator.pushNamed(
                          context, RouteNames.route_search_screen,
                          arguments: [provider]);
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.grey.shade100,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          enabled: false,
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
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: _pageOptions[provider.selectedIndex],
            )
          ]),
        ),
      ),

      bottomNavigationBar: Hidable(
        visibility: (position, currentVisibility) {
          return currentVisibility;
        },
        controller: scrollController,

        //  wOpacity: true,
        preferredWidgetSize: Platform.isAndroid?const Size.fromHeight(kToolbarHeight+20):const Size.fromHeight(kToolbarHeight+70),
        child: BottomNavigationBar(
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          type:BottomNavigationBarType.fixed,
          items: [
            _buildCustomBottomNavigationBarItem(
                provider, 0, Icons.home_outlined, Icons.home, 'Home'),
            _buildCustomBottomNavigationBarItem(provider, 1,
                Icons.grid_view_outlined, Icons.grid_view_rounded, 'Category'),
            _buildCustomBottomNavigationBarItem(provider, 2,
                Icons.storefront_outlined, Icons.storefront_rounded, 'Shop'),
            _buildCustomBottomNavigationBarItem(
                provider, 3, Icons.favorite_border, Icons.favorite, 'Wishlist'),
            _buildCustomBottomNavigationBarItem(provider, 4, CupertinoIcons.bag,
                CupertinoIcons.bag_fill, 'Basket'),
          ],
          currentIndex: provider.selectedIndex,
          selectedItemColor: Color(0xFF689f39),
          unselectedItemColor: Colors.black,
          onTap: (int index) {
            if (index == 2) {
              provider.sub_cat_id = 0;
              provider.child_cat_id = 0;
              provider.cat_id = 0;
              provider.header_data = null;
            }
            if (index == 4) {
              Navigator.pushNamed(context, RouteNames.route_basket)
                  .then((value) {
                provider.getBasketList();
                provider.sub_cat_id = 0;
                provider.child_cat_id = 0;
                provider.cat_id = 0;
                provider.header_data = null;
                provider.selectedIndexOfNavigation(0);
              });
            }
            provider.selectedIndexOfNavigation(index);
            // setState(() {
            //   _selectedIndex = index;
            //
            //   if(index == 2){
            //
            //   }
            // });
            // if (index == 0) {
            //   scrollController.animateTo(
            //     0.0,
            //     duration: const Duration(milliseconds: 500),
            //     curve: Curves.easeOut,
            //   );
            // }
            // if (index == 4) {
            //   Navigator.push(context,MaterialPageRoute(builder: (context) => BasketScreen()));
            // }
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildCustomBottomNavigationBarItem(
      HomeViewModel provider,
      int index,
      IconData outlineIcon,
      IconData filledIcon,
      String label) {
    bool isSelected = index == provider.selectedIndex;
    Color selectedColor = Color(0xFF689f39); // Blue color for selected items
    Color unselectedColor = Colors.grey; // Grey color for unselected items

    return BottomNavigationBarItem(
      icon: new Stack(
        children: <Widget>[
          Column(
            children: [
              new Icon(
                isSelected ? filledIcon : outlineIcon,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              SizedBox(
                height: 5,
              ),
              // Text(
              //   label,
              //   style: TextStyle(color: unselectedColor, fontSize: 10),
              // ),
            ],
          ),
          if (index == 4 || index==3) ...{
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
                  '${index==4?provider.cart_count:provider.whishlist_count}',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          }
        ],
      ),
      // Stack(
      //   children: [
      //     Column(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Icon(
      //           isSelected ? filledIcon : outlineIcon,
      //           color: isSelected ? selectedColor : unselectedColor,
      //         ),
      //         Text(label,style: TextStyle(color: unselectedColor,fontSize: 10),),
      //
      //       ],
      //     ),
      //     if (isSelected)
      //       Positioned(
      //         bottom: 0,
      //         left: 0,
      //         right: 0,
      //         child: Icon(
      //           filledIcon,
      //           color: selectedColor,
      //         ),
      //       ),
      //
      //   ],
      // ),
      label: label,
      // Customize label text color based on selection
      activeIcon: Stack(
        children: [
          Icon(
            filledIcon,
            color: selectedColor,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Icon(
              filledIcon,
              color: selectedColor,
            ),
          ),
        ],
      ),
    );
  }
}
