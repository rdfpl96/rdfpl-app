import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/view_models/auth_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/delivery_options_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/filter_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/intro_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/location_search_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/myaccount_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/my_order_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/offer_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/save_later_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/splash_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/wishlist_viewmodel.dart';
import 'package:royal_dry_fruit/views/account/AddAddressScreen.dart';
import 'package:royal_dry_fruit/views/account/DeliveryAddress.dart';
import 'package:royal_dry_fruit/views/account/MyAccountScreen.dart';
import 'package:royal_dry_fruit/views/account/MyOrders.dart';
import 'package:royal_dry_fruit/views/account/add_new_address_location_screen.dart';
import 'package:royal_dry_fruit/views/after_review_screen.dart';
import 'package:royal_dry_fruit/views/basket_screen.dart';
import 'package:royal_dry_fruit/views/cancel_order_screen.dart';
import 'package:royal_dry_fruit/views/coupons_screen.dart';
import 'package:royal_dry_fruit/views/deliver_options_screen.dart';
import 'package:royal_dry_fruit/views/filter_screen.dart';
import 'package:royal_dry_fruit/views/home_screen.dart';
import 'package:royal_dry_fruit/views/intro_page_screen.dart';
import 'package:royal_dry_fruit/views/login_signup_screen.dart';
import 'package:royal_dry_fruit/views/my_reviews_screen.dart';
import 'package:royal_dry_fruit/views/offer_screen.dart';
import 'package:royal_dry_fruit/views/order_screen.dart';
import 'package:royal_dry_fruit/views/rate_review_screen.dart';
import 'package:royal_dry_fruit/views/save_later_screen.dart';
import 'package:royal_dry_fruit/views/pages/sub_catlist_page.dart';
import 'package:royal_dry_fruit/views/payment_gateway_screen.dart';
import 'package:royal_dry_fruit/views/product_detail_screen.dart';
import 'package:royal_dry_fruit/views/search_location_screen.dart';
import 'package:royal_dry_fruit/views/search_screen.dart';
import 'package:royal_dry_fruit/views/thank_you_screen.dart';
import 'package:royal_dry_fruit/views/update_profile_screen.dart';
import 'package:royal_dry_fruit/views/verify_otp_screen.dart';

import '../../view_models/auth2_viewmodel.dart';
import '../../view_models/current_location_viewmodel.dart';
import '../../view_models/add_edit_address_viewmodel.dart';
import '../../view_models/basket_viewmodel.dart';
import '../../view_models/category_viewmodel.dart';
import '../../view_models/coupons_viewModel.dart';
import '../../view_models/delivery_address_viewmodel.dart';
import '../../view_models/home_viewmodel.dart';
import '../../view_models/my_rate_review_viewmodel.dart';
import '../../view_models/my_reviewsviewmodel.dart';
import '../../view_models/order_details_viewmodel.dart';
import '../../view_models/payment_options_viewmodel.dart';
import '../../view_models/product_det_viewmodel.dart';
import '../../view_models/product_viewmodel.dart';
import '../../view_models/search_product_viewmodel.dart';
import '../../view_models/subcategory_viewmodel.dart';
import '../../view_models/update_userdet_viewmodel.dart';
import '../../views/pick_location_screen.dart';
import '../../views/re_verify_otp_screen.dart';
import '../../views/splash_screen.dart';
import 'routes_name.dart';

class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.route_splash:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => SplashViewModel(context),
            child: SplashScreen(),
          ),
        );
      case RouteNames.route_intro:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => IntroViewModel(),
            child: IntroScreen(),
          ),
        );
      case RouteNames.route_login_signup:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => AuthViewModel(),
            child: LoginSignUpScreen(),
          ),
        );
      case RouteNames.route_verfy_otp:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => AuthViewModel(),
            child: VerifyOtpScreen(
              data: args,
            ),
          ),
        );
      case RouteNames.route_re_verify_screen:
        var args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => Auth2ViewModel(),
            child: ReVerifyOtpScreen(
              data: args,
            ),
          ),
        );
      case RouteNames.route_update_profile_details:
        var args = settings.arguments as List;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => UpdateUserDetailViewModel(),
            child: UpdateProfileScreen(
              data: args[0]as  Map<String, dynamic>,
              view_type: args[1],
            ),
          ),
        );

      case RouteNames.route_product_details:
        var list_args = settings.arguments as List;
        var arg_id = list_args[0];

        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => ProductDetViewModel(list_args[1], context),
              ),
            ],
            builder: (context, child) =>
                ProductDetScreen(model: arg_id, homeViewModel: list_args[1]),
          ),
        );
      case RouteNames.route_basket:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => BasketViewModel(context),
            child: BasketScreen(),
          ),
        );

      case RouteNames.route_delivery_options:
        var args = settings.arguments as List;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) =>
                DeliveryOptionsViewModel(context, args[0], args[1]),
            child: Delivery_Options(),
          ),
        );
      case RouteNames.route_payment_options:
        var args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => PaymentOptionsViewModel(context, args),
            child: Payment_Gateway(),
          ),
        );
      case RouteNames.route_subcategory_screen:
        var args = settings.arguments as List;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) =>
                SubCategoryViewModel(context, args[0], args[1], args[2]),
            child: SubCatListPage(),
          ),
        );

      case RouteNames.route_cancel_order:
        return MaterialPageRoute(
            builder: (context) =>
                CancelOrder() /*ChangeNotifierProvider(create: (context) => ProductViewModel(context),child: BasketScreen(),),*/);

      case RouteNames.route_order_details:
        var arg = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => OrderDetailsViewModel(context, arg),
            child: OrderDetScreen(),
          ),
        );

      case RouteNames.route_thankyou_page:
        var args = settings.arguments as List;
        return MaterialPageRoute(
            builder: (context) => ThankYou(args[
                0]) /*ChangeNotifierProvider(create: (context) => ProductViewModel(context),child: BasketScreen(),),*/);

      case RouteNames.route_after_review_screen:
        var args = settings.arguments as List;
        return MaterialPageRoute(
            builder: (context) => AfterReviewScreen(data:args[
                0]) /*ChangeNotifierProvider(create: (context) => ProductViewModel(context),child: BasketScreen(),),*/);

      case RouteNames.route_my_orders_screen:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => MyOrderViewModel(context),
            child: MyOrders(),
          ),
        );

      case RouteNames.route_delivery_address_screen:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => DeliveryAddressViewModel(context),
              ),
              ChangeNotifierProvider(
                create: (context) => LocationViewModel(),
              ),
            ],
            builder: (context, child) => DeliveryAddress(),
          ),
        );

      case RouteNames.route_add_del_address_screen:
        var args = settings.arguments as List;
        LatLng latLng = args[0];
        String address = args[1];
        String? addr_id = args[2];
        bool isSkip = false;
        if (args[3] != null) {
          isSkip = args[3];
        }
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => AddEditAddressViewModel(
                context, latLng, address, addr_id, isSkip),
            child: AddAddressScreen(
              address: addr_id,
            ),
          ),
        );

      case RouteNames.route_search_screen:
        var args = settings.arguments as List;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => SearchProductViewModel(context, args[0]),
            child: SearchScreen(),
          ),
        );

      case RouteNames.route_coupons_screen:
        var arg = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => CouponsViewModel(context, arg),
            child: CouponsScreen(),
          ),
        );

      case RouteNames.route_search_location_screen:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => LocationSearchViewModel(
              context,
            ),
            child: LocationSearchScreen(),
          ),
        );

      case RouteNames.route_myaccount_screen:
        var args=settings.arguments==null?[]: settings.arguments as List;
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => MyAccountViewModel(context),
            child: MyAccountScreen(homeProvider: args[0],),
          ),
        );
      case RouteNames.route_home:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => HomeViewModel(context),
              ),
              ChangeNotifierProvider(
                create: (context) => ProductViewModel(context),
              ),
              ChangeNotifierProvider(
                create: (context) => WishListViewModel(context),
              ),
              ChangeNotifierProvider(
                create: (context) => CategoryViewModel(context),
              ),
            ],
            child: HomeScreen(),
          ),
        );
      case RouteNames.route_search_address_screen:
        var args =
            settings.arguments == null ? null : settings.arguments as List;
        String? addr_id = null;

        if (args != null && args[0] != null) {
          addr_id = args[0] as String;
        }
        Utils.prinAppMessages('addr_id=$addr_id');
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (context) => LocationViewModel(),
              child: AddAddressLocationScreen(
                addr_id: addr_id,
              )),
        );
      case RouteNames.route_search_google_address_screen:
        var args = settings.arguments as List;
        var data = args[0] as Map;

        return MaterialPageRoute(
          builder: (context) => SelectAddressMap(data: data),
        );

      case RouteNames.route_filter_screen:
        return MaterialPageRoute(
            builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => FilterViewmodel(),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => CategoryViewModel(context),
                    )
                  ],
                  child: FilterScreen(),
                ));
      case RouteNames.route_save_later_screen:
        var args=settings.arguments as List;

        return MaterialPageRoute(
            builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => SaveLaterViewModel(args[0]),
                    )
                  ],
                  child: SaveLaterScreen(),
                ));

      case RouteNames.route_rate_reviews_screen:

        var arg=settings.arguments as List;

        return MaterialPageRoute(
            builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => RateReviewsViewModel(context,arg[0]),
                    )
                  ],
                  child: RateReviewScreen(),
                ));


      case RouteNames.route_my_reviews_screen:


        return MaterialPageRoute(
            builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => MyReviewsViewModel(context),
                    )
                  ],
                  child: MyReviewsScreen(),
                ));
      case RouteNames.route_offer_screen:
        var args=settings.arguments as List;

        return MaterialPageRoute(
            builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => OfferViewModel(context,args[0]),
                    )
                  ],
                  child: OfferScreen(),
                ));
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No Route Defined'),
            ),
          ),
        );
    }
  }
}
