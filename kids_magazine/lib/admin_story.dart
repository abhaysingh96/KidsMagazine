import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kids_magazine/user_model.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';

String original_text = "";
String language = "";
String audioUrl = "";
String title = "";
String? audioFilePath;
String? UploadAudioUrl;

class AdminStory extends StatefulWidget {
  final String _storyID;

  AdminStory(this._storyID);

  @override
  _AdminStoryState createState() => _AdminStoryState();
}

Future<UserModel?> transliterate(String original_text, String language) async {
  final String apiUrl = "https://transliteration-api.herokuapp.com/api";
  final body = {"language": language, "original_text": original_text};

  final response = await http.post(Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body));

  print(response.statusCode);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return userModelFromJson(responseString);
  } else {
    return null;
  }
}

class _AdminStoryState extends State<AdminStory>
    with SingleTickerProviderStateMixin {
  CollectionReference stry = FirebaseFirestore.instance.collection('stories');
  UserModel? _user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: stry.doc(widget._storyID).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          original_text = snapshot.data!['original_text'];
          title = snapshot.data!['title'];
          print(original_text);
          language = snapshot.data!['language'];
          print("*****************************");
          _user == null ? print("Nothing") : print(_user!.transliteratedText);
          print("*****************************");
          print(snapshot.data!['audio']);
          print("****************************************");
          audioUrl = snapshot.data!['audio'];

          if (audioUrl != "none") print(audioUrl);

          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData)
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_sharp,
                    color: Color(0xFFfea13a),
                    size: 25.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Color(0xFF181621),
                title: Row(
                  children: [
                    Flexible(
                      child: Text(
                        snapshot.data!['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'JosefinSans',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFfea13a),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                color: Color(0xFFfea13a),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.70,
                      color: Colors.transparent,
                      child: Column(
                        children: [

                          // TODO audio player
                          
                          SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            flex: 1,
                            child: RawScrollbar(
                              thumbColor: Colors.black26,
                              thickness: 4,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data!['original_text'],
                                    style: TextStyle(
                                      fontFamily: 'JosefinSans',
                                      fontSize: 18.0,
                                      color: Color(0xFF181621),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 9.0),
                          elevation: 20.0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: Color(0xFF181621),
                          onPressed: () async {
                            await stry
                                .doc(widget._storyID)
                                .update({'status': 'approved'});
                            final UserModel? user =
                                await transliterate(original_text, language);
                            setState(() {
                              _user = user;
                            });
                            await stry.doc(widget._storyID).update({
                              'transliterated_text': _user!.transliteratedText
                            });
                            await stry
                                .doc(widget._storyID)
                                .update({'audio': audioUrl});

                            Navigator.pop(context, '/');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "Approve",
                              style: TextStyle(
                                fontSize: 23.0,
                                fontFamily: 'Amaranth',
                                color: Color(0xFFfea13a),
                              ),
                            ),
                          ),
                        ),
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 9.0),
                          elevation: 20.0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: Color(0xFF181621),
                          onPressed: () async {
                            // await stry.doc(widget._storyID).update({'status': 'removed'});
                            await stry.doc(widget._storyID).delete();
                            Navigator.pop(context, '/');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "Remove",
                              style: TextStyle(
                                fontSize: 23.0,
                                fontFamily: 'Amaranth',
                                color: Color(0xFFfea13a),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          return Container(
            color: Color(0xFFfea13a),
          );
        });
  }
}
