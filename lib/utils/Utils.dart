import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class Utils{

  static void prinAppMessages(dynamic msg){
    if(kDebugMode){
      print('App Messages:$msg');
    }
  }

  static void showFlushbarError(String mesg, BuildContext context,[bool isError=true]) {
    Future.delayed(Duration.zero,() {
      Flushbar(title: 'Message',
        duration: Duration(seconds: 3),
        message: '$mesg',
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: isError?Colors.red:Colors.green,
        reverseAnimationCurve: Curves.easeInOut,
        icon: Icon(Icons.error,size: 25,color: Colors.white,),
      ).show(context);
    },);

  }

  static getDate(dateStr, String fr_format, String to_format) {
    try {
      // Parse the date string using the fromFormat
      final DateFormat inputFormat = DateFormat(fr_format);
      final DateTime dateTime = inputFormat.parse(dateStr);

      // Format the date using the toFormat
      final DateFormat outputFormat = DateFormat(to_format);
      final String formattedDate = outputFormat.format(dateTime);

      return formattedDate;
    } catch (e) {
      // Handle any parsing or formatting errors
      return 'Error: ${e.toString()}';
    }
  }
  static getDateInFormat( String fr_format) {
    try {
      // Parse the date string using the fromFormat
      final DateTime dt=DateTime.now();

      // Format the date using the toFormat
      final DateFormat outputFormat = DateFormat(fr_format);

      final String formattedDate = outputFormat.format(dt);

      return formattedDate;
    } catch (e) {
      // Handle any parsing or formatting errors
      return 'Error: ${e.toString()}';
    }
  }


  static int getDateInNumber() {
    DateTime dt=DateTime.now();
    return dt.millisecond;
  }
  static String getDateInISO(){
    DateTime dt=DateTime.now();
    return dt.toIso8601String();
  }
}