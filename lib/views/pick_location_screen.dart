import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:lottie/lottie.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';

import 'package:shimmer/shimmer.dart';

const appBlue =  Color(0xFF008AFD);
class SelectAddressMap extends StatefulWidget {
  var data;
   SelectAddressMap({Key? key,required this.data}) : super(key: key);

  @override
  State<SelectAddressMap> createState() => _SelectAddressMapState();
}

class _SelectAddressMapState extends State<SelectAddressMap> {

  Completer<GoogleMapController> googleMapController = Completer();
  CameraPosition? cameraPosition;
  late LatLng defaultLatLng;
  late LatLng draggedLatLng;
  String draggedAddress = "";
  late String mapStyle;
  Placemark? address;
  List<Placemark>? placeMarks;

  @override
  void initState() {
    print('Map::::${widget.data}');
    Prediction prediction=widget.data['data'];
    Utils.prinAppMessages('latlng:${double.parse(prediction.lat.toString())} lng:${double.parse(prediction.lng.toString())}');
    defaultLatLng=LatLng(double.parse(prediction.lat.toString()), double.parse(prediction.lng.toString()));
    draggedLatLng = defaultLatLng;
    cameraPosition = CameraPosition(target: defaultLatLng, zoom: 15);
    _init();
    // _gotoUserCurrentPosition();


    /// If you have not map_style.json then you can remove it. if you want to generate map_style.json link: https://mapstyle.withgoogle.com/
    // rootBundle.loadString('assets/map_style.json').then((string) {
    //   mapStyle = string;
    // });
    setState(() {});
    super.initState();
  }

  _init() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
        body: Column(
          children: [
            Expanded(
                flex: 1,
                child: Stack(
                  children: [

                    _getMap(),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 10),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          // child: Image.asset('assets/rounded_back.png', scale: 3)),
                          child: Icon(Icons.arrow_back)),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                          onTap: () {
                            _gotoUserCurrentPosition();
                          },
                          // child: Image.asset('assets/go_to_current_location.png',
                          child: Icon(Icons.blur_circular_outlined)),
                    ),
                    _getCustomPin(),


                  ],
                )),
            Expanded(
                flex: 0,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset:
                            const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: _showDraggedAddress(()async{
                        // var placeId = widget.data['data'].placeId;
                        // await getPlaceDetails(placeId!);
                        print('on click map :${widget.data['addr_id']}');
                        Navigator.pushNamed(context, RouteNames.route_add_del_address_screen,arguments: [draggedLatLng,draggedAddress,widget.data['addr_id'],widget.data['isSkip']]);
                      }),
                    ),
                  ],
                ))
          ],
        ));
  }

  Widget _showDraggedAddress(Function onClick) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30, right: 10, top: 15),
          child:  Row(
            children: [
              Image.asset('assests/images/map_pin.png',width: 25,height: 25),
              const SizedBox(width: 10),
              Text("Address",
                  style:  TextStyle(
                      overflow: TextOverflow.ellipsis, fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black
                  )),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 10, top: 15),
          child: Row(
            children: [
              Flexible(
                child: Column(
                  children: <Widget>[
                    Shimmer.fromColors(
                      enabled: false,
                      baseColor: Colors.black,
                      highlightColor: Colors.grey,
                      child: Text(draggedAddress,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: "Gilroy",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                onClick();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(appBlue),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              child: const Text("Next",
                  style: TextStyle(
                      fontSize: 16, color: Colors.white, fontFamily: 'Gilroy')),
            ),
          ),
        )
      ],
    );
  }

  Widget _getMap() {
    return GoogleMap(
      initialCameraPosition:
      cameraPosition!, //initialize camera position for map
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      onCameraIdle: () {
        _getAddress(draggedLatLng);
      },
      onCameraMove: (cameraPosition) {
        draggedLatLng = cameraPosition.target;
      },
      onMapCreated: (GoogleMapController controller) {
        if (!googleMapController.isCompleted) {
          googleMapController.complete(controller);
          //controller.setMapStyle(mapStyle);
        }
      },
    );
  }

  Widget _getCustomPin() {
    return Center(
      child: SizedBox(
        width: 150,
        /// I used the map pin from the lottie. You can also use it if you want. Otherwise you can delete.
        child: Lottie.asset("assests/pin.json", width: 100, height: 100),
      ),
    );
  }

  /// get address from dragged pin
  Future _getAddress(LatLng position) async {
    placeMarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    address = placeMarks![0];
    String addressString =
        "${address!.street},${address!.locality},${address!.administrativeArea}, ${address!.country}";

    setState(() {
      draggedAddress = addressString;
    });
  }

  ///
  Future _gotoUserCurrentPosition() async {
    Position currentPosition = await _determineUserCurrentPosition();
    _gotoSpecificPosition(LatLng(currentPosition.latitude, currentPosition.longitude));
  }

  Future _gotoSpecificPosition(LatLng position) async {
    GoogleMapController mapController = await googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 15)));
    await _getAddress(position);
  }

  Future _determineUserCurrentPosition() async {
    LocationPermission locationPermission;
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      debugPrint("user don't enable location permission");
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        debugPrint("user denied location permission");
      }
    }
    if (locationPermission == LocationPermission.deniedForever) {
      debugPrint("user denied permission forever");
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}