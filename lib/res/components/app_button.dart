import 'package:royal_dry_fruit/res/colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onTap;
  Color? colors;
  double size;
   AppButton({Key? key,required this.title,this.loading=false,required this.onTap,this.size=250,this.colors=null}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 250,
        height: 45,
        child: ElevatedButton(
        style: ElevatedButton.styleFrom(
        backgroundColor:(colors==null?kButtonColor:colors)),
    onPressed: () {
      onTap();
    },
    child: loading?Container(
        padding:EdgeInsets.symmetric(vertical: 5),child: CircularProgressIndicator()):Text(
    '$title',
    style: TextStyle(
    fontSize: 16, color: Colors.white),
    ),
    ));
  }
}
