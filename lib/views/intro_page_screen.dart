import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/view_models/intro_viewmodel.dart';

class IntroScreen extends StatelessWidget {
   IntroScreen({super.key});

  var green = Color(0xFF689f39);
  var darkgrey = Color(0xFF7b7c7a);

   late IntroViewModel provider;
  @override
  Widget build(BuildContext context) {
     provider=Provider.of(context);
    return Scaffold(
      body: Container(
        color: Color(0xFff6f9f3),
        child: Column(
          children: [
            SizedBox(height: 50),
            Expanded(
              child: PageView.builder(
                controller: provider.pageController,
                itemCount: provider.totalPages,
                onPageChanged: (index) {
                  provider.setPage(index);
                  // setState(() {
                  //   currentPage = index;
                  // });
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Expanded(flex: 7, child: Container(margin: EdgeInsets.all(50),child: provider.images[index])),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(45, 0, 45, 0),
                          child: Text(
                            provider.titles[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: green,fontWeight: FontWeight.w500,
                                fontFamily: 'Posterama1927'
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            provider.descriptions[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: darkgrey),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(30,15,30,15),
                            child: Text(
                              provider.buttonStrings[index],
                              style: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 16,fontWeight: FontWeight.w600),
                            ),
                            decoration: BoxDecoration(
                              color: green,
                              // borderRadius: Radius.circular(10),
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                          ),

                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text("Skip",style: TextStyle(color: darkgrey),),
                    onPressed: (){
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => MobNo_SignUpScreen()),
                      // );
                      provider.actionSkip(context);
                    },
                  ),
                  SizedBox(width: 30,),
                  Row(
                    children: List.generate(provider.totalPages, (index) {
                      return Indicator(provider.currentPage == index);
                    }),
                  ),
                  SizedBox(width: 30,),
                  TextButton(
                    child: Text("Next",style: TextStyle(color: darkgrey)),
                    onPressed: (){
                      if (provider.currentPage != provider.totalPages - 1) {
                        provider.pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      } else {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => MobNo_SignUpScreen()),
                        // );
                        provider.actionNext(context);
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }


}

class Indicator extends StatelessWidget {
  final bool isActive;

  Indicator(this.isActive);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.grey,
      ),
    );
  }
}
