import 'package:flutter/material.dart';
import 'package:weatherdiva/model/cuacaModel.dart';
import 'package:weatherdiva/style/colors.dart';
import 'package:weatherdiva/style/textstyle.dart';

class ListItemWidget extends StatelessWidget {
  final String cek;
  final int i;
  final String iconurl;
  final Current min;
  final String time;
  final bool cektomorrow;

  const ListItemWidget({Key key, this.cek, this.i, this.iconurl, this.min, this.time, this.cektomorrow}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 14.0, left: i == 0 ? 14 : 0),
      child: Column(
        children: <Widget>[
          Text(
            (cek == 'PM' && i > 12 && int.parse(time) == i - 12 && cektomorrow == false) ||
                    (cek == 'AM' && i <= 12 && int.parse(time) == i && cektomorrow == false)
                ? 'Now'
                : i < 12
                    ? (i).toString() + ' am'
                    : i - 12 == 0 ? '12.00' : (i - 12).toString() + ' pm',
            style: subtittlePutihKurus,
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color: Colors.white,
                ),
                color: (cek == 'PM' && i >= 12 && int.parse(time) == i - 12 && cektomorrow == false) ||
                        (cek == 'AM' && i < 12 && int.parse(time) == i && cektomorrow == false)
                    ? whiteColor
                    : Colors.transparent),
            child: Column(
              children: <Widget>[
                // Icon(Icons.web_asset,
                // color: Colors.white
                // ),
                Image.network(
                  iconurl,
                  height: 20,
                ),
                // Text(
                //  icon_url,
                //   style: tittlePutihKurus,
                // ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  (min.temp / 10).toStringAsFixed(0),
                  style: tittle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }
}
