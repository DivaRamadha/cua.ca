import 'dart:async';
import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherdiva/api/sharedpred.dart';
import 'package:weatherdiva/model/lokasi.dart';
import 'package:weatherdiva/provider/posisiProvider.dart';
import 'package:weatherdiva/style/colors.dart';
import 'package:weatherdiva/style/textstyle.dart';

class SearchLocationPage extends StatefulWidget {
  final Function function;

  const SearchLocationPage({Key key, @required this.function})
      : super(key: key);
  @override
  _SearchLocationPageState createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  List<Lokasi> countries = [];

  bool _isCountriesDataFormed = false;
  List<Lokasi> results = [];

  String query = '';
  TextEditingController tc = TextEditingController();

  Future<List<Lokasi>> loadCountriesJson() async {
    countries.clear();
    var value =
        await DefaultAssetBundle.of(context).loadString("assets/city.json");
    var countriesJson = json.decode(value);
    for (var country in countriesJson) {
      countries.add(Lokasi.fromJson(country));
    }
    return countries;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((Duration d) {
      if (countries.length < 50) {
        loadCountriesJson().whenComplete(() {
          setState(() {
            _isCountriesDataFormed = true;
          });
        });
      }
    });
    return getBody();
  }

  getBody() {
    final posisi = Provider.of<CurrentPositionProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              EvaIcons.arrowBack,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: TextField(
          controller: tc,
          decoration: InputDecoration(hintText: 'Search...'),
          onChanged: (v) {
            setState(() {
              query = v;
              setResults(query);
            });
          },
        ),
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: _isCountriesDataFormed
            ?
            // PhoneAuthWidgets.searchCountry(searchCountries())
            SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: query.isEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: countries.length,
                              itemBuilder: (con, ind) {
                                return listSearchItemWidget(countries[ind]);
                              },
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: results.length,
                              itemBuilder: (con, ind) {
                                return listSearchItemWidget(results[ind]);
                              },
                            ),
                    ),
                  ],
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  listSearchItemWidget(Lokasi loc) {
    final posisi = Provider.of<CurrentPositionProvider>(context, listen: false);
    SharedPref pref = new SharedPref();
    return ListTile(
      leading: Icon(
        EvaIcons.pinOutline,
        color: primaryColor,
      ),
      title: Text(
        loc.name,
        style: tittleHitam,
      ),
      subtitle: Container(
        child: Row(
          children: <Widget>[
            Text(
              loc.country + '',
              style: subtittle,
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          tc.text = loc.name;
          query = loc.name;
          setResults(query);
          pref.save('lat', 'lon', loc.coord.lat, loc.coord.lon);
          posisi.getalamat(lat: loc.coord.lat, long: loc.coord.lon);
          widget.function();
        });
        Navigator.pop(context);
      },
    );
  }

  void setResults(String query) {
    results = countries
        .where((elem) =>
            elem.name.toString().toLowerCase().contains(query.toLowerCase()) ||
            elem.name.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
