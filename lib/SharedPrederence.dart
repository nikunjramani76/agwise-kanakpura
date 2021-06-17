// import 'dart:convert';
//
// import 'package:chatbot/Chat.dart';
// import 'package:chatbot/Constant.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SharedPreference{
//   static String CHATLISTKEY="CHATLIST";
//
//   static Future<void> saveUserChat(chat) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool result = await prefs.setString(CHATLISTKEY, jsonEncode(chat));
//   }
//
//   static getUserChat() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<dynamic> chatMap;
//     final String chatStr = prefs.getString(CHATLISTKEY);
//     if (chatStr != null) {
//       chatMap = jsonDecode(chatStr) ;
//       Constant.chatlist=[];
//       for(int i=0;i<chatMap.length;i++){
//         Constant.chatlist.add(new Chat(chatMap[i]["msg"], chatMap[i]["issendbyme"], chatMap[i]["type"]));
//       }
//       // print(Constant.chatlist);
//     }
//   }
//   static clearUserChat() async{
//     Constant.chatlist=[];
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool result = await prefs.clear();
//     print(result);
//   }
// }