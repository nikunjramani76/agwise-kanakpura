import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/smtp_server/mailgun.dart';

import 'package:chatbot/BarChart.dart';
import 'package:chatbot/Chat.dart';
import 'package:chatbot/Constant.dart';
import 'package:chatbot/DatabaseMethods.dart';
import 'package:chatbot/SharedPrederence.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'DataGridTable.dart';
import 'messagetile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'AgWise'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController messageController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<String> question = [
    'Will it rain today?',
    'ಇವತ್ತು ಮಳೆ ಇದೆಯಾ?',
    'Will it rain this week?',
    'Today’s Weather Forecast?',
    'Yesterday’s Weather?',
    'Current Soil Moisture Level for All Zones',
    'My Activity For 2021-05-29',
    'ನಮಸ್ಕಾರ'
  ];
  static const regEx1 = '\\\\u([0-9a-fA-F]{4})';
  static const regEx2 = '$regEx1$regEx1';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppbar(widget.title),
      body: Container(
        // width: MediaQuery.of(context).size.width,
        // height:MediaQuery.of(context).size.height,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ChatMessageList()
            ),
            buildChatController()
          ],
        ),
      ),
    );
  }

  Widget buildAppbar(title) {
    return AppBar(
      backgroundColor: Color.fromRGBO(12,177,75,.9),
      title: Wrap(
        spacing: 10,
        children: [
          Image.asset(
            'images/logo3.png',
            width: 25,
            height: 25,
            color: Colors.white,
          ),
          Text(
            title,
            style: new TextStyle(fontSize: 23),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: handleClick,
          itemBuilder: (BuildContext context) {
            return {'Clear Chat'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  void handleClick(String value) {
    setState(() {
      // DatabaseMethod.deleteAll();
      Constant.chatlist=[];
      // SharedPreference.clearUserChat();
    });
  }

  Widget ChatMessageList() {
    return Constant.chatlist != null
        ? Container(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: Constant.chatlist.length,
                itemBuilder: (context, index) {
                  String type= Constant.chatlist[index].type;
                  String message=Constant.chatlist[index].msg;
                  bool isSendByMe=Constant.chatlist[index].issendbyme == "true";
                  return Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: MediaQuery.of(context).size.width,
                      alignment:  isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: type == "message"
                          ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                          decoration: buildBoxDecoration(isSendByMe),
                          child: Container(
                            child: Text(
                              message,
                              style: buildTextStyle(isSendByMe),
                            ),
                          ))
                          : (type == "image"
                          ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: buildBoxDecoration(isSendByMe),
                          child: Image.file(
                                File(message.toString()),
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                           )
                          : (type == "ploatgraph"
                          ? Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: buildBoxDecoration(isSendByMe),
                          child: Container(
                              width: 600, height: 600, child: BarGraph()))
                          : (type == "buttonplot"
                          ? Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                decoration: buildBoxDecoration(isSendByMe),
                                child: Text(
                                  message,
                                  style: buildTextStyle(isSendByMe),
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
                                    decoration: buildBoxDecoration(isSendByMe),
                                    child: GestureDetector(
                                      onTap: () => {
                                        getResponse("Email")
                                      },
                                      child: Text(
                                        'Email',
                                        style: buildTextStyle(isSendByMe),
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
                                    decoration: buildBoxDecoration(isSendByMe),
                                    child: GestureDetector(
                                      onTap: () => {
                                        getResponse("Plot Chart")
                                      },
                                      child: Text(
                                        'Plot Chart',
                                        style: buildTextStyle(isSendByMe),
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
                          decoration: buildBoxDecoration(isSendByMe),
                          child: Container(
                              width: 600,
                              height: 500,
                              child: buildDataGridTable()))))));
                }))
        : Container();
  }


  buildBoxDecoration(bool isSendByMe) {
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

  buildTextStyle(bool isSendByMe){
    return isSendByMe
        ? TextStyle(
        color: Colors.white, fontSize: 17)
        : TextStyle(
        color: Colors.black, fontSize: 17);
  }

  Widget BuildsuggestedQuestion(){
    return  Container(
      child:  SizedBox( // Horizontal ListView
        height: 50,
        child:  ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: question.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                    height: 50,
                    alignment:Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color.fromRGBO(12,177,75,.9), Color.fromRGBO(12,177,75,.9)],
                        ),
                        border: new Border.all(color: Color.fromRGBO(12,177,75,.9), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: GestureDetector(
                      onTap: () => {
                        getResponse(question[index])
                        // messageController.text =
                        // question[index],
                        // Navigator.of(context)
                        //     .pop()
                      },
                      child: Text('${question[index]}',
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  );
            })
      ),
    );
  }

  Widget buildChatController() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          BuildsuggestedQuestion(),
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: 55,
                width: MediaQuery.of(context).size.width - 65,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.white],
                    ),
                    border: new Border.all(color: Color.fromRGBO(12,177,75,.9), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: new Row(
                  children: [
                    Expanded(
                        child: Container(
                          margin:EdgeInsets.only(left: 20),
                          child: TextField(
                            maxLines: null,
                            maxLengthEnforced: false,
                            keyboardType: TextInputType.multiline,
                            controller: messageController,
                            style: TextStyle(color: Colors.black54),
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.black54),
                                hintText: "Enter Message",
                                border: InputBorder.none),
                          ),
                        )),
                    IconButton(
                        color: Color.fromRGBO(12,177,75,.9),
                        icon: Icon(
                          Icons.camera_alt,
                        ),
                        onPressed: () {
                          _takePhoto();
                        }),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => {
                  if (messageController.text.isNotEmpty)
                    {getResponse(messageController.text)}
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(12,177,75,.9),
                        Color.fromRGBO(12,177,75,.9),
                      ]),
                      borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getResponse(String msg) async {
    // await DatabaseMethod.insert(new Chat(0,msg,"true","message"));
    setState(() {
      messageController.text = "";
      Constant.chatlist.add(new Chat(0,msg, "true", "message"));
    });

    final Map<String, String> header = {
      'Accept-Language': '*',
      'X-user': Constant.xuser,
      "Authorization":
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI2MDZkMjRjMTRjZDFlYTE0N2MzYjUxYjNAaW50ZWdyYXRpb24uY29tIn0.mASrAcnbVDabG0JkXy2Cis7OGMqL19t9HEOvXHP5L28"
    };
    // tumkur "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhbW9vbHlhLnNoZXR0eUBkaWdpdGUuY29tIiwiZXhwIjoxNjE4MjgyNzY2fQ.HOk9ik4v65DGlr0T1eJfPRBEgkPiYJToKRPaeJ3Pf10"

    var data = jsonEncode(<String, String>{
      'data': msg,
    });

    // var url = "https://run.mocky.io/v3/c3746a84-fc30-43f6-ab3e-c46646e98810";
    var url = "https://kairon-api.digite.com/api/bot/chat";
   // var response = await http.post(url);
    var response=await http.post(url,headers: header,body: data);
    var response1 = json.decode(utf8.decode(response.bodyBytes));
    print(response1);
    var kontan = StringBuffer();
    List<String> replication3,replication2,replication1;
    String type=response1['data']['response'][0]['text'];
    if(type.contains("plotGraph")){
      var test1=jsonDecode((response1['data']['response'][0]['text'].toString().replaceAll("'", '"')));
      print(test1['bar_group']['C1']["R1"]);
      Constant.ploatData.add(PlotGraph("C1", test1['bar_group']['C1']["R1"], 0, 0));
      Constant.ploatData.add(PlotGraph("C2", test1['bar_group']['C2']["R1"], 0, 0));
      Constant.ploatData.add(PlotGraph("I1F1", test1['bar_group']['I1F1']["R1"], test1['bar_group']['I1F1']["R2"],test1['bar_group']['I1F1']["R3"]));
      Constant.ploatData.add(PlotGraph("I1F2", test1['bar_group']['I1F2']["R1"], test1['bar_group']['I1F2']["R2"],test1['bar_group']['I1F2']["R3"]));
      Constant.ploatData.add(PlotGraph("I1F3", test1['bar_group']['I1F3']["R1"], test1['bar_group']['I1F3']["R2"],test1['bar_group']['I1F3']["R3"]));
      Constant.ploatData.add(PlotGraph("I2F1", test1['bar_group']['I2F1']["R1"], test1['bar_group']['I2F1']["R2"],test1['bar_group']['I2F1']["R3"]));
      Constant.ploatData.add(PlotGraph("I2F2", test1['bar_group']['I2F2']["R1"], test1['bar_group']['I2F2']["R2"],test1['bar_group']['I2F2']["R3"]));
      Constant.ploatData.add(PlotGraph("I2F3", test1['bar_group']['I2F3']["R1"], test1['bar_group']['I2F3']["R2"],test1['bar_group']['I2F3']["R3"]));
      Constant.ploatData.add(PlotGraph("I3F1", test1['bar_group']['I3F1']["R1"], test1['bar_group']['I3F1']["R2"],test1['bar_group']['I3F1']["R3"]));
      Constant.ploatData.add(PlotGraph("I3F2", test1['bar_group']['I3F2']["R1"], test1['bar_group']['I3F2']["R2"],test1['bar_group']['I3F2']["R3"]));
      Constant.ploatData.add(PlotGraph("I3F3", test1['bar_group']['I3F3']["R1"], test1['bar_group']['I3F3']["R2"],test1['bar_group']['I3F3']["R3"]));

            setState(() {
              _scrollToBottom();
              Constant.chatlist.add(new Chat(0,replaceEmoji(test1['text']), "false", "message"));
              Constant.chatlist.add(new Chat(0,"data", "false", "ploatgraph"));
            });
    }else if(type.contains("PlotTable")){
      var test1=jsonDecode((response1['data']['response'][1]['text'].toString().replaceAll("'", '"')));
      print(test1['activities'][0]);

      for (int i = 1; i < test1['activities'].length; i++) {
          var tmp=test1["activities"][i];
          Constant.popschedule.add(new PopSchedule(tmp['FIELD'], tmp['on_date'], tmp['FERTILIZER'],tmp['MODE'],tmp['Per Plant(gm)'].toString(),tmp['Total(kg)'].toString(),tmp['APPLICATION DESCRIPTION']));
      }
      setState(() {
        _scrollToBottom();
        Constant.chatlist.add(new Chat(0,"Your Activities for the Week are as Follows", "false", "message"));
        Constant.chatlist.add(new Chat(0,"data", "false", "ploattable"));
      });
    }else if(type.contains("PlotButtons")){
      String newmsg1=type.replaceAll("PlotButtons  ", "");
      String newmsg=replaceEmoji(newmsg1);
      setState(() {
        _scrollToBottom();
        Constant.chatlist.add(new Chat(0,newmsg, "false", "buttonplot"));
      });
    } else{
      for (int i = 0; i < response1['data']['response'].length; i++) {
        kontan.writeln(
            response1['data']['response'][i]['text']);
      }
      String newmsg=replaceEmoji(kontan.toString());

      // await DatabaseMethod.insert(new Chat(0,kontan.toString(),"false","message"));
      setState(() {
        _scrollToBottom();
        Constant.chatlist.add(new Chat(0,newmsg, "false", "message"));
      });
    }

  }

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  static String _regExEmojiUnicode(String text, String regEx) {
    final regexCheck = RegExp(regEx, caseSensitive: false);
    String newText = '';
    int _lastEndText = 0;
    int _lastEndNewText = 0;

    regexCheck.allMatches(text).forEach((match) {
      final start = match.start;
      final end = match.end;

      final String replacement = jsonDecode('"${match.group(0)}"');

      String startString;
      newText == ''
          ? startString = '${text.substring(0, start)}$replacement'
          : startString =
      '${newText.substring(0, _lastEndNewText)}${text.substring(_lastEndText, start)}$replacement';

      _lastEndNewText = startString.length;
      _lastEndText = end;

      newText =
      '$startString${text.substring(end)}';

    });

    if(newText == '') newText = text;

    return newText;
  }

  static String replaceEmoji(String text) {
    String newText = text;

    // Checking for 2-bytes and single bytes emojis
    if(newText.contains('\\u'))
      newText = _regExEmojiUnicode(newText, regEx2);
    if(newText.contains('\\u'))
      newText = _regExEmojiUnicode(newText, regEx1);

    return newText;
  }
  void _takePhoto() async {
    ImagePicker.pickImage(source: ImageSource.camera)
        .then((File recordedImage) async {
      if (recordedImage != null && recordedImage.path != null) {
        // UploadTask uploadTask = reference.putFile(recordedImage);
        setState(() {
          Constant.chatlist.add(new Chat(0,recordedImage.path, "true", "image"));
        });
        showAlertDialog(context, recordedImage);



        // GallerySaver.saveImage(recordedImage.path).then((path) {
        //   setState(() {
        //   });
        // });
      }
    });
  }

  showAlertDialog(BuildContext context,recordedImage) async{

    // set up the button
    Widget okButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        setState(() {
          Constant.chatlist.add(new Chat(0,"Okay Sure", "false", "message"));
        });
      },
    );
    Widget EmailButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        setState(() {
          Constant.chatlist.add(new Chat(0,"Okay, an email is sent", "false", "message"));
          // Constant.chatlist.add(new Chat(0,"Sure. Is there anything else that I can help you with?", "false", "message"));
        });
        String username = 'nikunjramani9157@gmail.com';
        String password = 'tbsuobgisu';

        final smtpServer = gmail(username, password);
        final message = new Message()
          ..from = new Address(username, 'Nikunj Ramani')
          ..recipients.add('nikunj.ramani@digite.com')
          ..recipients.add('amoolya.shetty@digite.com')
        // ..ccRecipients.addAll(['nikunjramani7624@gmail.com', 'nikunjramani7624@gmail.com'])
          ..subject = 'Crop Diseases'
          ..text = 'Can You Identifies This Crop Diseases'
          ..attachments.add(FileAttachment(recordedImage));
        // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";
        final sendReports = send(message, smtpServer);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Do you want me to send an Email to Dr. Jaya Bhaskaran?"),
      actions: [
        okButton,
        EmailButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}