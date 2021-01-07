import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class CurrentPositionProvider with ChangeNotifier {
  Position _currentPosition;
  String currentAddress;

  final Geolocator geolocator = Geolocator();

  Address _alamat;
  Address get alamat => _alamat;

  Position get posisi => _currentPosition;

  void getLocationFromloc() async {
   _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // await displayPrediction(_map);
    print('vasdasdasdas');
    notifyListeners();
  }

  // void getLocation(double lat, double long) {
  //   geolocator.placemarkFromCoordinates(lat, long).then((pos) {
  //     _currentPosition = pos.first.position;
  //      _getAddressFromLatLng();
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  Future<Null> getalamat({@required double lat, @required double long}) async {
    final coordinates = new Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    _alamat = first;
    notifyListeners();
  }

  // _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> p = await geolocator.placemarkFromCoordinates(
  //         _currentPosition.latitude, _currentPosition.longitude);
  //     Placemark place = p[0];

  //     currentAddress =
  //         "${place.locality}, ${place.postalCode}, ${place.country}";
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<Null> displayPrediction(Position p) async {
    if (p == null) {
      p = this.posisi;
    }
    print('LOKASI YANG DI PILIH ==================================');
    print(p.latitude);
    print(p.longitude);

    final coordinates = new Coordinates(p.latitude, p.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    _alamat = first;
    notifyListeners();
    // setState(() {
    //   lokasi = first.addressLine;
    //   latt = lat;
    //   lngg = lng;
    // });
  }
}
