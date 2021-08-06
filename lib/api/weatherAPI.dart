import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weatherdiva/model/cuacaModel.dart';

const String apiKey = "4a3afcdef7ee5ade701f8b0bba7d554d";

class CuacaAPI {
  static final String urlNearby = "https://api.openweathermap.org/data/2.5";

  Future<Cuaca> getCuaca(
      {@required double lat,@required double long, String hourly, String daily}) async {
   String url =
        '$urlNearby/onecall?lat=$lat&lon=$long&exclude=$hourly,$daily&appid=$apiKey';
    // print(url);
    var response = await http.get(url).then((val) => json.decode(val.body));
    return Cuaca.fromJson(response);
  }


}