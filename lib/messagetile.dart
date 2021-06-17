import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BarChart.dart';
import 'Chat.dart';
import 'Constant.dart';
import 'DataGridTable.dart';
import 'main.dart';

class MessageTile extends StatelessWidget {
  final String message, type;
  final bool isSendByMe;
  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  var _onPressed;
  static final Random random = Random();
  Directory externalDir;
  File _file;

  MessageTile(this.message, this.isSendByMe, this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        margin: EdgeInsets.symmetric(vertical: 5),
        width: MediaQuery.of(context).size.width,
        alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: type == "message"
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                decoration: buildBoxDecoration(),
                child: Container(
                  child: Text(
                    message,
                    style: buildTextStyle(),
                  ),
                ))
            : (type == "image"
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: buildBoxDecoration(),
                    child: Column(
                      children: [
                        Image.file(
                          File(message.toString()),
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text("Can You Identify Crop Diseases",
                              style:buildTextStyle()),
                        )
                      ],
                    ))
                : (type == "ploatgraph"
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: buildBoxDecoration(),
                        child: Container(
                            width: 600, height: 600, child: BarGraph()))
                    : (type == "buttonplot"
                        ? Container(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: buildBoxDecoration(),
                                child: Text(
                                    message,
                                    style: buildTextStyle(),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 50,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      padding: EdgeInsets.all(10),
                                      decoration: buildBoxDecoration(),
                                      child: GestureDetector(
                                        onTap: () => {
                                          },
                                        child: Text(
                                          'Email',
                                          style: buildTextStyle(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 120,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      padding: EdgeInsets.all(10),
                                      decoration: buildBoxDecoration(),
                                      child: GestureDetector(
                                        onTap: () => {
                                        },
                                        child: Text(
                                          'PloatChart',
                                          style: buildTextStyle(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ))
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: buildBoxDecoration(),
                            child: Container(
                                width: 600,
                                height: 600,
                                child: buildDataGridTable()))))));
  }

  buildBoxDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
          colors: isSendByMe
              ? [
                  // Colors.black
                  Color.fromRGBO(12, 177, 75, .9),
                  Color.fromRGBO(12, 177, 75, .9),
                ]
              : [
                  Color.fromRGBO(240, 239, 245, .9),
                  Color.fromRGBO(240, 239, 245, .9),
                ],
        ),
        borderRadius: isSendByMe
            ? BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10))
            : BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)));
  }

  buildTextStyle(){
    return isSendByMe
        ? TextStyle(
        color: Colors.white, fontSize: 17)
        : TextStyle(
        color: Colors.black, fontSize: 17);
  }
}
