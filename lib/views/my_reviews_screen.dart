import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/view_models/my_reviewsviewmodel.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MyReviewsViewModel provider=Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Reviews"
        ),
      ),
      body: SafeArea(
        child: provider.loading?Center(child: CircularProgressIndicator(),):
        ListView.builder(itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Image.network('${provider.data_list[index]['imagepath']}',)),
                      Expanded(flex:4,child: Text('${provider.data_list[index]['product_name']}'))
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.lightGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Row(
                          children: [
                            Text('${provider.data_list[index]['cust_rate']}'),
                            Icon(Icons.star,size: 15,color: Colors.green,),
                          ],
                        ),
                      ),
                      SizedBox(width: 10,),

                    ],
                  ),
                  SizedBox(height: 10,),
                  Text('${provider.data_list[index]['comment']}',style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey
                  ),)
                ],
              ),
            ),
          );
        },
        itemCount: provider.data_list.length),
      ),
    );
  }
}
