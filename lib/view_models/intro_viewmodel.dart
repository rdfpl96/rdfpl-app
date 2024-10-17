import 'package:flutter/material.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';

class IntroViewModel extends ChangeNotifier{
  final PageController _pageController = PageController(initialPage: 0);

  PageController get pageController => _pageController;

  int totalPages = 3;


  List<Image> images = [
    Image.asset("assests/images/intro1.png"),
    Image.asset("assests/images/intro2.png"),
    Image.asset("assests/images/intro3.png"),
  ];

  List<String> titles = [
    "VISIT OUR ONLINE SHOP",
    "CHOOSE WHAT YOU WANT",
    "PLACE YOUR ORDER",
  ];

  List<String> descriptions = [
    "We have millions of one-of-a-kind items, so you can find whatever you need for you or anyone you love.",
    "Buy directly from our sellers who put their heart and soul into making something special.",
    "We use the best-in-class technology to protect any of your transactions on our website.",
  ];

  List<String> buttonStrings = [
    "VISIT NOW",
    "SEARCH",
    "ADD TO CART",
  ];

  int currentPage = 0;

  void setPage(int index) {
    currentPage=index;
    notifyListeners();
  }

  void actionSkip(BuildContext context) {
    Navigator.pushNamed(context, RouteNames.route_login_signup);
  }

  void actionNext(BuildContext context) {

  }
}