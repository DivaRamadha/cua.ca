import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weatherdiva/page/homePage.dart';
import 'package:weatherdiva/provider/posisiProvider.dart';
import 'package:weatherdiva/style/colors.dart';
import 'package:weatherdiva/style/textstyle.dart';
import 'package:geolocator/geolocator.dart' as geo;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentPositionProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> initPlatformState(BuildContext context) async {
    int a = 0;
    // final auth = Provider.of<AuthProvider>(context, listen: false);
    // auth.getUser();
    if (!mounted) return;

    // PermissionStatus permissionRequestResult = await LocationPermissions()
    //     .requestPermissions(permissionLevel: LocationPermissionLevel.location);

    // while (permissionRequestResult != PermissionStatus.granted) {
    //   permissionRequestResult = await LocationPermissions().requestPermissions(
    //       permissionLevel: LocationPermissionLevel.location);
    // }
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.requestPermission();
    while (a != 2) {
      print(permission);
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        a = 2;
        break;
      } else {
        if (permission == LocationPermission.deniedForever) {
          await Geolocator.openAppSettings();
          permission = await Geolocator.checkPermission();
          // Navigator.pushReplacementNamed(context, '/NoLocationPermission');
        } else {
          permission = await Geolocator.requestPermission();
        }
      }
    }

    while (!isLocationServiceEnabled) {
      await Geolocator.openLocationSettings();
      isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    }

    if (a == 2) {
      final posisi =
          Provider.of<CurrentPositionProvider>(context, listen: false);
      await Future.delayed(
              Duration(milliseconds: 200), () => posisi.getLocationFromloc())
          .then((_) async => await posisi.displayPrediction(null));
      print('aaaaa');

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          ModalRoute.withName('\homePage'));
    }
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  navigationPage() {
    return initPlatformState(context);
  }

  @override
  void initState() {
    final posisi = Provider.of<CurrentPositionProvider>(context, listen: false);
    startTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Spacer(),
            Container(
              height: 300,
              width: 300,
              child: Image.asset('assets/splash.gif'),
            ),
            Spacer(),
            Text(
              'Cua.ca',
              style: tittlePutih,
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
