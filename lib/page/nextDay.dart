import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherdiva/model/cuacaModel.dart';
import 'package:weatherdiva/style/colors.dart';
import 'package:weatherdiva/style/derajat.dart';
import 'package:weatherdiva/style/textstyle.dart';
import 'package:weatherdiva/widget/listHari.dart';

class NextDay extends StatefulWidget {
  final Cuaca cuaca;

  const NextDay({Key key, this.cuaca}) : super(key: key);
  @override
  _NextDayState createState() => _NextDayState();
}

class _NextDayState extends State<NextDay> {
  Cuaca c;
  // DateTime dateTime = DateTime.now();
  // var lastMonday;
  List<DateTime> list = [];
  List<bool> cekList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c = widget.cuaca;
    // DateTime date = DateTime.now();
    DateTime start = DateTime.now();
    DateTime end = DateTime.now().add(Duration(hours: 168));

    while (start.isBefore(end)) {
      list.add(start);
      if (list.length < 2) {
        cekList.add(true);
      }
      cekList.add(false);
      start = start.add(Duration(days: 1));
    }
    print(list);
    // final daysToGenerate = end.difference(dateTime).inDays;
    // days = List.generate(daysToGenerate, (i) => DateTime(dateTime.year, dateTime.month, dateTime.day + (i)));
  }

  String img;
  bool cek = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              EvaIcons.arrowBack,
              color: secondaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          c.timezone,
          style: subtittle,
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'Next 7 days',
                style: tittleHitam,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListView.builder(
                itemCount: c.daily.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  Daily m = c.daily[i];
                  String a = DateFormat('EEEE').format(list[i]);
                  // print(im);
                  // print('-------------------------------------');
                  // if (im == 'IconWeather.dd') {
                  //   img = '02d';
                  // } else if (im == 'IconWeather.ee') {
                  //   img = '03d';
                  // } else if (im == 'IconWeather.aa') {
                  //   img = '03n';
                  // } else if (im == 'IconWeather.bb') {
                  //   img = '04d';
                  // } else if (im == 'IconWeather.ff') {
                  //   img = '04n';
                  // } else if (im == 'IconWeather.cc') {
                  //   img = '10d';
                  // } else {
                  //   img = '10n';
                  // }

                  String iconurl = "http://openweathermap.org/img/wn/" +
                      m.weather[0].icon +
                      "@2x.png";
                  return _listWidget(i, m, iconurl, a);
                }),
          ],
        ),
      ),
    );
  }

  _listWidget(int i, Daily m, String iconurl, String a) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: cekList[i] == true ? Colors.grey[100] : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]
          )
        )
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              setState(() {
                cekList[i] = !cekList[i];
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: 50,
              // color: primaryColor,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 30,
                    width: 30,
                    child: Image.network(iconurl),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    a + ',',
                    style: tittleHitam,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    list[i].day.toString(),
                    style: subtittle,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    list[i].year.toString(),
                    style: subtittle,
                  ),
                  Spacer(),
                  //rama
                  Text(
                    (m.temp.max / 10).toStringAsFixed(0) + tipeder,
                    style: tittleHitam,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    (m.temp.min / 10).toStringAsFixed(0) + tipeder,
                    style: subtittle,
                  ),
                ],
              ),
            ),
          ),
          ExpandedSection(
            expand: cekList[i],
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 6,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        tittleRow((m.pop*100).toStringAsFixed(0), ' Precipitation', '%'),
                        SizedBox(
                          height: 14,
                        ),
                        tittleRow(m.humidity.toString(), 'Humidity', '%'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        tittleRow(m.windSpeed.toString() , 'Wind', 'km/h'),
                        SizedBox(
                          height: 14,
                        ),
                        tittleRow(m.pressure.toString(), 'Pressure', 'hPa'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Divider(),
        ],
      ),
    );
  }

  tittleRow(String desc, String tittle, String satuan) {
    return Row(
      children: <Widget>[
        Container(
          width: 90,
          // color: primaryColor,
          child: Text(
            tittle,
            style: subtittleHitam,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(desc + ' ' +satuan,
        style: subtittleAbu
        )
      ],
    );
  }
}
