import 'package:flutter/material.dart';

class DrpButton extends StatelessWidget {
  Map<String,dynamic>? _value;
  List<Map<String,dynamic>>? list_items;
  Function? onChange;
  String? hintText;
  Color? background_color;
  DrpButton(this._value, this.list_items, this.onChange, this.hintText,[this.background_color]);

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(10),
      //     color: background_color==null?Colors.grey[200]:background_color),
      // padding: EdgeInsets.only(left: 10, right: 10),
      child: DropdownButton<Map<String,dynamic>>(
        underline: Container(
          height: 1,
        ),
        value: _value,
        items: list_items?.map((Map<String,dynamic> item) {
          return DropdownMenuItem<Map<String,dynamic>>(
            child: Text("${item['name']}"),
            value: item,
          );
        }).toList(),
        onChanged: (value) {
          onChange!(value);
        },
        hint: Text("${hintText}",style: TextStyle(color: Colors.black54),),
        style: TextStyle(color: Colors.black54),
        disabledHint: Text("Disabled"),
        elevation: 8,
        //style: TextStyle(color: Colors.green, fontSize: 16),
        icon: Icon(Icons.keyboard_arrow_down_rounded),
        //iconDisabledColor: Colors.red,
        //iconEnabledColor: Colors.green,
        isExpanded: true,
      ),
    );
  }
}
