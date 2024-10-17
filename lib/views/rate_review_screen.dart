import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/res/colors.dart';
import 'package:royal_dry_fruit/res/components/app_button.dart';
import 'package:royal_dry_fruit/view_models/my_rate_review_viewmodel.dart';

import '../utils/Utils.dart';

class RateReviewScreen extends StatelessWidget {
  const RateReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RateReviewsViewModel provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate And Review"),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                              child: Image.network(
                            '${provider.itm_details['imagepath']}',
                          )),
                          Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${provider.itm_details['product_name']}'),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(5, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          // Handle star rating logic here
                                          provider.setRatings(index +
                                              1); // Increment by 1 to set the correct rating

                                        },
                                        child: Icon(
                                          index < provider.ratings
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product Review'),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: provider.tecReview,
                            maxLines: 5,
                            // keyboardType: authViewmodel.isemail_login?TextInputType.emailAddress:TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(15, 15, 15, 15),
                              hintText: 'I like or dislike this product because...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: provider.loading?Center(child: CircularProgressIndicator(),):AppButton(
                onTap: () {
                    provider.saveData(context);
                },
                title: "Save",
                colors: kGreen,
                // onPressed: () {
                //   // Handle the "Write Review" button press here
                //   // Navigator.pushNamed(context, RouteNames.route_rate_reviews_screen,arguments: [element]);
                // },
                // child: Text('Write Review'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
