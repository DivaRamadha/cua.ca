import 'package:connectivity/connectivity.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:weatherdiva/api/sharedpred.dart';
import 'package:weatherdiva/api/weatherAPI.dart';
import 'package:weatherdiva/model/cuacaModel.dart';
import 'package:weatherdiva/page/nextDay.dart';
import 'package:weatherdiva/page/searchLocation.dart';
import 'package:weatherdiva/provider/posisiProvider.dart';
import 'package:weatherdiva/style/derajat.dart';
import 'package:weatherdiva/style/textstyle.dart';
import 'package:weatherdiva/widget/listItem.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var date = DateTime.now();
  bool tomorrow = false;
  SharedPref pref = new SharedPref();

  double lat;
  double lon;

  bool load = false;

  bool iswificonnected = false;
  bool isInternetOn = true;

  List dataa =[];

  loadSharedPrefs() async {
    final posisi = Provider.of<CurrentPositionProvider>(context, listen: false);
    double user = await pref.read("lat");
    double aa = await pref.read("lon");
    if (user != null) {
      setState(() {
        posisi.getalamat(lat: user, long: aa);
        lat = user;
        lon = aa;
        load = true;
        CuacaAPI().getCuaca(lat: user, long: aa, hourly: '24', daily: '7');
      });
    } else {
      setState(() {
        load = true;
      });
    }
  }

  Box box;
  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    return;
  }

 Future<bool> getAlldata() async {
    await openBox();
    final posisi = Provider.of<CurrentPositionProvider>(context, listen: false);
    try {
      CuacaAPI().getCuaca(
          lat: lat != null ? lat : posisi.posisi.latitude,
          long: lon != null ? lon : posisi.posisi.longitude,
          hourly: '24',
          daily: '7').then((value) => setState((){
            putdata(Cuaca.fromJson(value.toJson()));
          }));
    } catch (SocketException) {
      print('no internet');
    }

    var myMap = box.toMap().values.toList();
    if (myMap.isEmpty) {
      dataa.add('empty');
    }else{
      dataa = myMap;
    }

    return Future.value(true);
  }

  Future putdata(data) async {
    await box.clear();

    
      box.add(data);
    
  }

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    
  }

  @override
  Widget build(BuildContext context) {
    final posisi = Provider.of<CurrentPositionProvider>(context, listen: false);
    String dates = DateFormat('EE, d MMM').format(date);
    String time = DateFormat('h').format(date);
    String times = DateFormat('HH').format(date);
    String cek = DateFormat('a').format(date);
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            int.parse(times) > 5 && int.parse(times) <= 11
                ? 'assets/bgpagi.jpeg'
                : int.parse(times) > 11 && int.parse(times) <= 17
                    ? 'assets/bgsian.jpeg'
                    : int.parse(times) > 17 && int.parse(times) <= 20
                        ? 'assets/bg.jpeg'
                        : int.parse(times) > 20
                            ? 'assets/bgmalam.jpeg'
                            : 'assets/bgsian.jpeg',
          ),
        ),
      ),
      child: load == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder<Cuaca>(
                future: 
                CuacaAPI().getCuaca(
                    lat: lat != null ? lat : posisi.posisi.latitude,
                    long: lon != null ? lon : posisi.posisi.longitude,
                    hourly: '24',
                    daily: '7'),
                builder: (context, data) {
                  print('-----------------------------------------');
                  print(data.data.timezone);
                  if (!data.hasData || data == null)
                    return Center(child: CircularProgressIndicator());
                  return SafeArea(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          barAtas(data.data.timezone),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                              height: 204,
                              width: 200,
                              child: Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => loadSharedPrefs(),
                                    child: Text(
                                      'Today,',
                                      style: tittlePutihKurus,
                                    ),
                                  ),
                                  // Text(
                                  //   lat.toString() ?? 'a',
                                  //   style: tittlePutihKurus,
                                  // ),
                                  Text(
                                    dates,
                                    style: subtittlePutihKurus,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        // color: primaryColor,
                                        child: Text(
                                          (data.data.current.temp / 10)
                                              .toStringAsFixed(0),
                                          style: tittlePutihBesar,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 24.0),
                                        child: Text(
                                          tipesel,
                                          style: tittlePutih,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    // color: primaryColor,
                                    child: Text(
                                      'Feels Like ' +
                                          (data.data.current.feelsLike / 10)
                                              .toStringAsFixed(0) +
                                          tipeder,
                                      style: subtittlePutihKurus,
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      tomorrow = false;
                                    });
                                  },
                                  child: Container(
                                    height: 24,
                                    child: Text(
                                      'Today',
                                      style: tomorrow
                                          ? subtittlePutihKurus
                                          : tittlePutih,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      tomorrow = true;
                                    });
                                  },
                                  child: Container(
                                    height: 24,
                                    child: Text(
                                      'Tomorrow',
                                      style: tomorrow
                                          ? tittlePutih
                                          : subtittlePutihKurus,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NextDay(
                                                  cuaca: data.data,
                                                )));
                                  },
                                  child: Container(
                                    height: 24,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(99),
                                      // color: Colors.white
                                    ),
                                    child: Text(
                                      'Next 7 days >',
                                      style: subtittlePutihKurus,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1,
                          ),
                          Container(
                              height: 110,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                itemCount: data.data.hourly.length - 24,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) {
                                  Current min = data
                                      .data.hourly[tomorrow == true ? i + 24 : i];
                                  String im = min.weather.first.icon.toString();
                                  if (im == 'IconWeather.dd') {
                                    img = '02d';
                                  } else if (im == 'IconWeather.ee') {
                                    img = '03d';
                                  } else if (im == 'IconWeather.aa') {
                                    img = '03n';
                                  } else if (im == 'IconWeather.bb') {
                                    img = '04d';
                                  } else if (im == 'IconWeather.ff') {
                                    img = '04n';
                                  } else if (im == 'IconWeather.cc') {
                                    img = '10d';
                                  } else {
                                    img = '10n';
                                  }
                                  String iconurl =
                                      "http://openweathermap.org/img/wn/" +
                                          img +
                                          "@2x.png";
                                  return ListItemWidget(
                                    cek: cek,
                                    i: i,
                                    iconurl: iconurl,
                                    min: min,
                                    time: time,
                                    cektomorrow: tomorrow,
                                  );
                                },
                              )),

                          Spacer(),
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24))),
                            padding: EdgeInsets.all(14),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              'Sunrise',
                                              style: subtittle2,
                                            ),
                                            Text(
                                              getClockInUtcPlus3Hours(
                                                      data.data.current.sunrise)
                                                  .toString(),
                                              style: tittleHitam,
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              'Sunset',
                                              style: subtittle2,
                                            ),
                                            Text(
                                              getClockInUtcPlus3Hours(
                                                      data.data.current.sunset)
                                                  .toString(),
                                              style: tittleHitam,
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              'Wind Speed',
                                              style: subtittle2,
                                            ),
                                            Text(
                                              data.data.current.windSpeed
                                                      .toString() +
                                                  ' km/h',
                                              style: tittleHitam,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              'Humidity',
                                              style: subtittle2,
                                            ),
                                            Text(
                                              data.data.current.humidity
                                                      .toString() +
                                                  '%',
                                              style: tittleHitam,
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              'Precipitation',
                                              style: subtittle2,
                                            ),
                                            Text(
                                              (data.data.daily.first.pop * 100)
                                                      .toStringAsFixed(0) +
                                                  ' %',
                                              style: tittleHitam,
                                            )
                                          ],
                                        ),
                                        //diva
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              'Pressure',
                                              style: subtittle2,
                                            ),
                                            Text(
                                              data.data.current.pressure
                                                      .toString() +
                                                  ' hPa',
                                              style: tittleHitam,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                          // Container(
                          //   height: 200,
                          //   width: 200,
                          //   color: primaryColor,
                          //   child: ListView.builder(
                          //     itemCount: data.data.daily.length,
                          //     itemBuilder: (context, i){
                          //       return Text(data.data.daily[1].temp.max.toString());
                          //   })
                          // )
                        ],
                      ),
                    ),
                  );
                }
                // child: Column(
                //   children: <Widget>[

                //   ],
                // ),
                )
    ));
  }

  String img;
  ganti(String img) {
    setState(() {});
  }

  barAtas(String loc) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Spacer(),
          SizedBox(
            width: 60,
          ),
          Text(
            loc,
            style: tittlePutih,
          ),
          Spacer(),
          IconButton(
              icon: Icon(EvaIcons.menu2Outline, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchLocationPage(
                              function: loadSharedPrefs,
                            )));
              })
        ],
      ),
    );
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      title: Text(
        "You are not Connected to Internet",
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }

  // Center showWifi() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Text(
  //             " Your are connected to ${iswificonnected ? "WIFI" : "MOBILE DATA"}"),
  //         Text(iswificonnected ? "$wifiBSSID" : "Not Wifi"),
  //         Text("$wifiIP"),
  //         Text("$wifiName")
  //       ],
  //     ),
  //   );
  // }
  Center showMobile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(" Your are Connected to  MOBILE DATA"),
        ],
      ),
    );
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {
      iswificonnected = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      iswificonnected = true;
    }
  }
}

String getClockInUtcPlus3Hours(int timeSinceEpochInSec) {
  final time = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSec * 1000,
          isUtc: true)
      .add(const Duration(hours: 6));
  return '${time.hour}:${time.minute}';
}
