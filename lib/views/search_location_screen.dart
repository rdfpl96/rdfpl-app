import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/view_models/location_search_viewmodel.dart';
import 'package:royal_dry_fruit/views/account/AddAddressScreen.dart';
import 'package:royal_dry_fruit/views/pick_location_screen.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  @override
  void dispose() {
    // Your custom cleanup logic here
    super.dispose(); // <-- Ensure this line is included
  }
  @override
  Widget build(BuildContext context) {
    LocationSearchViewModel provider=Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Location'),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
           Form(
             child: TextFormField(
               controller: provider.tec_location,
               onChanged: (value) => provider.searchLocations(context),
               textInputAction: TextInputAction.search,

               decoration: InputDecoration(
                 contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                 fillColor: Colors.grey.shade300,
                 filled: true,
                 isDense: true,
                 hintText: "Search for Area, Pincode or Landmark",
                 prefixIcon: Icon(Icons.location_on_outlined),
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                   borderSide: BorderSide.none

                 ),
               ),
             ),
           ),
            SizedBox(height: 15,),
            Divider(height: 1,),
            SizedBox(height: 15,),
            Container(
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
            SizedBox(height: 15,),
            Divider(height: 1,),
            SizedBox(height: 15,),

            if(provider.list_locations!=null && provider.list_locations['predictions']!=null)...{
              Expanded(child:ListView.builder(itemBuilder: (context, index) {
                return LocationItem(provider.list_locations['predictions'][index],click: (){
                  Navigator.pushNamed(context, RouteNames.route_search_google_address_screen);
                },);
              },
              itemCount: provider.list_locations['predictions'].length,))
            }
          ],
        ),
      ),
    );
  }
}

class LocationItem extends StatelessWidget {
  var item;
  Function click;

  LocationItem(this.item,{required this.click,super.key});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        click();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item['structured_formatting']['main_text']}',style: TextStyle(fontWeight: FontWeight.w500),),
            Text('${item['structured_formatting']['secondary_text']}',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.grey,
            fontSize: 12),),
            Divider(height: 15,),
          ],
        ),
      ),
    );
  }
}

