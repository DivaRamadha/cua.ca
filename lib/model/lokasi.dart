// To parse this JSON data, do
//
//     final lokasi = lokasiFromJson(jsonString);

import 'dart:convert';

List<Lokasi> lokasiFromJson(String str) => List<Lokasi>.from(json.decode(str).map((x) => Lokasi.fromJson(x)));

String lokasiToJson(List<Lokasi> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Lokasi {
    Lokasi({
        this.id,
        this.name,
        this.state,
        this.country,
        this.coord,
    });

    int id;
    String name;
    String state;
    String country;
    Coord coord;

    factory Lokasi.fromJson(Map<String, dynamic> json) => Lokasi(
        id: json["id"],
        name: json["name"],
        state: json["state"],
        country: json["country"],
        coord: Coord.fromJson(json["coord"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "state": state,
        "country": country,
        "coord": coord.toJson(),
    };
}

class Coord {
    Coord({
        this.lon,
        this.lat,
    });

    double lon;
    double lat;

    factory Coord.fromJson(Map<String, dynamic> json) => Coord(
        lon: json["lon"].toDouble(),
        lat: json["lat"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
    };
}
