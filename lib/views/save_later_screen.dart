import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../res/components/h_save_later_item.dart';
import '../view_models/save_later_viewmodel.dart';

class SaveLaterScreen extends StatelessWidget {
   SaveLaterScreen({super.key});
  var green = Color(0xFF689f39);
  @override
  Widget build(BuildContext context) {
    SaveLaterViewModel provider=Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(onTap: (){Navigator.pop(context);},child: Container(color: green,child: Icon(CupertinoIcons.back,))),
        backgroundColor: green,
        title: Text('Save Later',style: TextStyle(fontSize: 16,color: Colors.white)),
        centerTitle: true,
        actions: [
          // Container(color: green,padding: EdgeInsets.fromLTRB(20,0,20,0),child: Icon(Icons.search)),
        ],
      ),
      body: provider.list==null?Container(child:Center(child:Text("NO Data Found"))):ListView.builder(
        itemBuilder: (context, index) {
        return Slidable(
          key: ValueKey(provider.list[index]['product_id']),
          endActionPane: ActionPane(
            extentRatio: 0.35,
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                backgroundColor: Color(0xFF4D4D4D),
                foregroundColor: Colors.white,
                icon: Icons.delete_outline_sharp,
                label: 'Delete',
                onPressed: (BuildContext context) {
                  provider.deleteFromSaveLater(context,provider.list[index]);
                },
              ),
            ],
          ),
          child: HSaveLaterProductItem(provider.list[index],
            (provider.PRODUCT_DET!=null && provider
                .list[index]['save_id']==provider.PRODUCT_DET['save_id'] &&
                provider.loading_add_to_cart),
            onTap: (){

            },
            onVariantChange:(_variant){
              //provider.setSelectedVarient(index,_variant,prod_type: 'S');
            } ,
            onAddToCart: (_type,_indx){
              provider.addToCart(_type,provider.list[index],context);
            },),
        );
      },
      itemCount: provider.list.length,),
    );
  }
}
