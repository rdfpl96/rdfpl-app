

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

Status_bar(){
  return SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFF63933a)), // Set your desired status bar color
  );
}

class CustomTopPopup extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
   // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Request focus and open the keyboard when the widget is built
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_textFocusNode);
      SystemChannels.textInput.invokeMethod('TextInput.show');
    });

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 400,
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: Container(),
              floating: false,
              expandedHeight: 120.0,
              pinned: false,
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
                                //   _scaffoldKey.currentState?.openDrawer();
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                height: 40,
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Icon(
                                      CupertinoIcons.back,
                                      color: Colors.white,
                                    )),
                              ),
                            )),
                        Container(
                            alignment: Alignment.center,
                            height: 50,
                            margin: EdgeInsets.all(5),
                            child: Text(
                              'Search Products',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white),
                            )),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    // height: 45,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: TextFormField(
                        controller: _textController,
                        focusNode: _textFocusNode,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.black54,
                            size: 20,
                          ),
                          hintText: 'Search Products',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          border: InputBorder.none, // Hide the border
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



void NavigateToScreen(BuildContext context,Widget screen){
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
      transitionDuration: Duration(seconds: 0), // Set the duration to 0 to remove the animation.
    ),
  );
}


