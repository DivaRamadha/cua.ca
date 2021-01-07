import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherdiva/api/sharedpred.dart';
import 'package:weatherdiva/model/lokasi.dart';
import 'package:weatherdiva/provider/posisiProvider.dart';
import 'package:weatherdiva/style/colors.dart';


class PhoneAuthWidgets {
  static Widget getLogo({String logoPath, double height}) => Material(
        type: MaterialType.transparency,
        elevation: 10.0,
        child: Image.asset(logoPath, height: height),
      );

  static Widget searcCountry(TextEditingController controller) => Padding(
        padding:
            const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0, right: 8.0),
        child: Card(
          child: TextFormField(
            autofocus: true,
            controller: controller,
            decoration: InputDecoration(
                hintText: 'Search your country',
                contentPadding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                border: InputBorder.none),
          ),
        ),
      );

  static Widget phoneNumberField(
          TextEditingController controller, String prefix) =>
      TextField(
        cursorColor: Colors.white,
        style:
            new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          // isDense: true,
          prefix: Text('' + prefix + ' ',
          style: TextStyle(
            color: Colors.grey[200]
          ),
          ),
         
          prefixStyle: TextStyle(
            color: Colors.grey[200]
          ),
          contentPadding: EdgeInsets.all(16.0),
          hintText: 'Phone',
          hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: primaryColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: new BorderSide(color: primaryColor)),
          filled: true,
          fillColor: Colors.transparent,
        ),
      );

  static Widget selectableWidget(BuildContext context,
          Lokasi country, Function(Lokasi) selectThisCountry) {
            SharedPref pref = new SharedPref();
            final posisi = Provider.of<CurrentPositionProvider>(context, listen: false);
     return Material(
        color: Colors.white,
        type: MaterialType.canvas,
        child: InkWell(
          onTap: () {selectThisCountry(country);
          pref.save('lat','lon' , country.coord.lat, country.coord.lon);
          // posisi.getLocation(country.coord.lat, country.coord.lon);
          // posisi.setAlamat(lat: country.coord.lat, long: country.coord.lon);
          }, //selectThisCountry(country),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Text(
              "  " +
                  country.name +
                  "  " +
                  country.country +
                  " (",
                 
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
          }

  static Widget selectCountryDropDown(Lokasi country, Function onPressed) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: primaryColor,
          )
        ),
        height: 54,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 4.0, top: 8.0, bottom: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(' ${country.name}  ${country.country} ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
                )),
                Icon(Icons.arrow_drop_down, size: 24.0)
              ],
            ),
          ),
        ),
      );

  static Widget subTitle(String text) => Align(
      alignment: Alignment.centerLeft,
      child: Text(' $text',
          style: TextStyle(color: Colors.white, fontSize: 14.0)));
}
