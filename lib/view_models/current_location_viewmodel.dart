import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../utils/routes/routes_name.dart';
class LocationViewModel extends ChangeNotifier {
  String _location = 'Unknown';

  String get location => _location;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getCurrentLocation(BuildContext context, var addr_id, bool isSkip) async {
    try {
      isLoading = true;
      Position position = await _determinePosition();
      _location = '${position.latitude}, ${position.longitude}';

      Prediction prediction = Prediction(
        description: "",
        id: "1",
        lat: '${position.latitude}',
        lng: '${position.longitude}',
      );

      Navigator.pushNamed(
        context,
        RouteNames.route_search_google_address_screen,
        arguments: [
          {'data': prediction, 'addr_id': addr_id, 'isSkip': isSkip}
        ],
      );
    } catch (e) {
      isLoading = false;
      _location = 'Failed to get location: $e';
      showLocationErrorDialog(context, e.toString());
    }
    isLoading = false;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // When permissions are granted, get the current position
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void showLocationErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

// class LocationViewModel extends ChangeNotifier {
//   String _location = 'Unknown';
//
//   String get location => _location;
//   bool _is_loading=false;
//
//
//   bool get is_loading => _is_loading;
//
//   set is_loading(bool value) {
//     _is_loading = value;
//   }
//
//   Future<void> getCurrentLocation(BuildContext context,bool isSkip) async {
//     try {
//       is_loading=true;
//       Position position = await _determinePosition();
//       _location = '${position.latitude}, ${position.longitude}';
//       is_loading=false;
//       Prediction prediction=Prediction(description: "",id: "1",lat: '${position.latitude}',lng: '${position.longitude}');
//       Navigator.pushNamed(context, RouteNames.route_search_google_address_screen,arguments: [{'data':prediction,'addr_id':null,'isSkip':isSkip}]);
//     } catch (e) {
//       is_loading=false;
//       _location = 'Failed to get location: $e';
//     }
//     notifyListeners();
//   }
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied.');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Location permissions are permanently denied.');
//     }
//
//     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   }
// }
