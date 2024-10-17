import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:http/http.dart' as http;

import '../../view_models/current_location_viewmodel.dart';
class AddAddressLocationScreen extends StatefulWidget {
  String? addr_id;
   AddAddressLocationScreen({required this.addr_id,super.key});

  @override
  State<AddAddressLocationScreen> createState() => _AddAddressLocationScreenState();
}

class _AddAddressLocationScreenState extends State<AddAddressLocationScreen> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode=FocusNode();
  late LocationViewModel locationViewModel;
  @override
  Widget build(BuildContext context) {
    locationViewModel=Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Search Address"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              placesAutoCompleteTextField((prediction){
                if(prediction!=null){
                  print("placeDetails" + prediction.lat.toString());
                  print("placeDetails" + prediction.lng.toString());
                  print("placeDetails" + prediction.structuredFormatting!.mainText.toString());
                  print("placeDetails" + prediction.structuredFormatting!.secondaryText.toString());
                  print("placeDetails" + prediction.description.toString());
                  print("placeDetails" + prediction.matchedSubstrings![0].offset.toString());
                  print("addr_id ${widget.addr_id}");

                  Navigator.pushNamed(context, RouteNames.route_search_google_address_screen,arguments: [{'data':prediction,'addr_id':widget.addr_id}]);
                }
              }),
              SizedBox(height: 15,),
              Divider(height: 1,),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: () {
                  locationViewModel.getCurrentLocation(context,widget.addr_id,false);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade300,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on),
                      Text('Use Current Location'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Divider(height: 1,),
              SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }


  // @override
  // void dispose() {
  //   controller.dispose();
  //   focusNode.dispose();
  // }
  @override
  void dispose() {
    // Your custom cleanup logic here
    controller.dispose();
    focusNode.dispose();
    super.dispose(); // <-- Ensure this line is included
  }

  placesAutoCompleteTextField(Function onSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),  // Circular border
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: GooglePlaceAutoCompleteTextField(
        focusNode: focusNode,
        boxDecoration: BoxDecoration(),
        textEditingController: controller,
        googleAPIKey:"AIzaSyDUksStRc1nu8vDYcb8245lsuPz7l9GUg0",
        // inputDecoration: InputDecoration(
        //   // contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        //   fillColor: Colors.grey.shade300,
        //   filled: true,
        //   isDense: true,
        //   hintText: "Search for Area, Pincode or Landmark",
        //   prefixIcon: Icon(Icons.location_on_outlined),
        //   border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(10),
        //       borderSide: BorderSide.none
        //
        //   ),
        // ),
        inputDecoration: InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,

          // border: OutlineInputBorder(
          //       // borderRadius: BorderRadius.circular(10),
          //       borderSide: BorderSide.none
          //
          //   ),
        ),
        debounceTime: 400,
        countries: ["in", "fr"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction)async {
          // Use the prediction.placeId to fetch place details
          // final placeDetails = await getPlaceDetails(prediction.placeId!);
          //
          // if (placeDetails != null) {
          //   String? city;
          //   String? state;
          //   String? postalCode;
          //
          //   List<
          //       dynamic> addressComponents = placeDetails['address_components'];
          //
          //   for (var component in addressComponents) {
          //     List<dynamic> types = component['types'];
          //
          //     if (types.contains('locality')) {
          //       city = component['long_name'];
          //     } else if (types.contains('administrative_area_level_1')) {
          //       state = component['long_name'];
          //     } else if (types.contains('postal_code')) {
          //       postalCode = component['long_name'];
          //     }
          //   }
          //
          //   print("City: $city, State: $state, Postal Code: $postalCode");
          // }
          onSelected(prediction);

        },
        itemClick: (Prediction prediction) {
          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
          focusNode.requestFocus();
        },
        seperatedBuilder: Divider(),
        containerHorizontalPadding: 10,
        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          focusNode.requestFocus();
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description ?? ""}"))
              ],
            ),
          );
        },

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }


  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    final String apiKey = "AIzaSyDUksStRc1nu8vDYcb8245lsuPz7l9GUg0";
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);
      return result['result'];
    } else {
      print("Failed to fetch place details: ${response.statusCode}");
      return null;
    }
  }
}
