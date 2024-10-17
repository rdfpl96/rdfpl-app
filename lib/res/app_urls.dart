import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrls{
  static final String BASE_URL=dotenv.env["BASE_URL"] as String;
  static final String FILE_UPLOAD_PATH=dotenv.env["IMG_PATH"] as String;


  //Login Page
  static final String login_with_mobile=BASE_URL+"auth/login-with-mobile";
  static final String login_with_email=BASE_URL+"auth/login-with-email";
  static final String verify_otp_by_mobile=BASE_URL+"auth/otp-verity-by-mobile";
  static final String verify_otp_by_email=BASE_URL+"auth/otp-verity-by-email";

  //Home Page
  static final String ep_home=BASE_URL+"home";
  static final String ep_category_list=BASE_URL+"product/categories";

  //Whishlist
  static final String ep_whishlist=BASE_URL+"wishlist";
  static final String ep_add_to_whishlist=BASE_URL+"wishlist/add-to-wishlist";

  //Product
  static final String ep_save_for_later=BASE_URL+"cart/save-to-later";
  static final String ep_add_to_cart=BASE_URL+"cart/add-to-cart";
  static final String ep_delete_whishlist=BASE_URL+"wishlist/delete";
  static final String ep_delete_from_cart=BASE_URL+"cart/delete/";
  static final String ep_cart=BASE_URL+"cart";
  static final String ep_getproductlist=BASE_URL+"product/list";
  static final String getproduct_details_end_point=BASE_URL+"product/detail";
  static final String get_add_gst_details_end_point=BASE_URL+"customer/save-gst";
  static final String ep_get_delivery_slots=BASE_URL+"customer/slote-list";
  static final String get_place_order_end_point=BASE_URL+"payment/place-order";


  // Address
  static final String ep_addresslist=BASE_URL+"customer/address-list";
  static final String ep_default_address=BASE_URL+"customer/setdefault";
  static final String get_state_list_end_point=BASE_URL+"customer/stateList";
  static final String get_add_edit_address_end_point=BASE_URL+"customer/address_save";
  static final String ep_edit_address=BASE_URL+"customer/address_update";
  static final String ep_get_gst=BASE_URL+"customer/gst";
  static final String ep_my_ratings=BASE_URL+"customer/rate-review-list";
  static final String ep_rate_review=BASE_URL+"customer/rate-reviews";




  static final String login_end_point=BASE_URL+"send-otp";
  static final String verfyotp_end_point=BASE_URL+"login";
  static final String updateuserdetails_end_point=BASE_URL+"customer/updateProfile";

  //homerepository
  static final String getcategory_end_point=BASE_URL+"get-category-list";
  static final String getbanners_end_point=BASE_URL+"banner-list"; //old for banners
  static final String get_dashboard_details_end_point=BASE_URL+"dashboard";
  static final String getcustomerdetails_end_point=BASE_URL+"customer/detail";
  static final String getadd_to_whishlist_end_point=BASE_URL+"add-wishlist";
  static final String getwhishlist_end_point=BASE_URL+"wishlist";
  static final String get_basket_end_point=BASE_URL+"cart-list";
  static final String get_add_to_cart_end_point=BASE_URL+"add-cart";
  static final String get_delte_from_cart_end_point=BASE_URL+"remove-cart-item";
  static final String get_search_product_end_point=BASE_URL+"search-product";
  static final String get_apply_coupon_end_point=BASE_URL+"coupon/apply-code";
  static final String get_get_coupons_ep=BASE_URL+"coupon/list";

  //account set get address
  static final String get_default_address_end_point=BASE_URL+"get-default-address";

  static final String get_delivery_address_end_point=BASE_URL+"get-shipping-address";

  static final String get_city_list_end_point=BASE_URL+"city-list";
  static final String get_delete_address_end_point=BASE_URL+"delete-address";

  static final String get_order_list_end_point=BASE_URL+"customer/order-list";
  static final String get_order_cancel_end_point=BASE_URL+"order-cancel-by-customer";
  static final String get_product_rating_end_point=BASE_URL+"review-rating-list";

  static String ep_move_to_cart=BASE_URL+"cart/move-to-cart";
  static String ep_delete_save_later=BASE_URL+"cart/delete-from-saveforlater/";

  static var ep_checkout=BASE_URL+"cart/checkout";

  static String rp_resend_otp_mobile=BASE_URL+"auth/resend-on-mobile";
  static String rp_resend_otp_email=BASE_URL+"auth/resend-on-email";

}