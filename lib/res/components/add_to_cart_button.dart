import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  String? qty;
  Function? onTap;
  double width,height;
  bool? isLoading=false;

   AddToCartButton(this.qty,{this.isLoading,this.onTap,required this.width,required this.height,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: qty==null || qty=='0'?ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red
        ),
        onPressed: () {
          onTap!('+');
      }, child: (isLoading!=null && isLoading!)?Padding(padding:EdgeInsets.symmetric(vertical: 5),child: CircularProgressIndicator(color: Colors.white,)):Text('Add'),
      ):Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                // provider.addToCart('-',element, context);
                if(onTap!=null) {
                  onTap!('-');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color:Colors.red,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),
                        topLeft: Radius.circular(8))
                ),
                child: Center(
                  child: Text('-',style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  ),),
                ),
              ),
            ),
          ),
          SizedBox(width: width*0.09),
          Container(
            width: width*0.2,
            child: Stack(
              children: [
                if(isLoading!=null && isLoading==true)...{
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: CircularProgressIndicator(
                      strokeWidth: 5, color: Colors.grey.withOpacity(0.70),),),
                },
                Center(
                  child: Text(
                  '$qty',
                  style: TextStyle(fontSize: 18),
              ),
                ),]
            ),
          ),
          SizedBox(width: width*0.09),
          Expanded(
            child: GestureDetector(
              onTap: () {
                // provider.addToCart('+',element, context);
                if(onTap!=null) {
                  onTap!('+');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color:Colors.red,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8))
                ),
                child: Center(
                  child: Text('+',style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  ),),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
