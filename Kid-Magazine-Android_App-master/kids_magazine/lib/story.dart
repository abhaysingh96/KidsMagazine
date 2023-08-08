import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_magazine/highlighting.dart';
import 'package:kids_magazine/transliterate.dart';

bool isSwitched1 = false;
bool isSwitched2 = false;
bool isSwitched3 = true;

class Story extends StatefulWidget {
  final String _storyID;

  Story(this._storyID);

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> {
  CollectionReference stry = FirebaseFirestore.instance.collection('stories');
  FlutterTts flutterTts = FlutterTts();

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: stry.doc(widget._storyID).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          String t_text = snapshot.data!['transliterated_text'];
          String o_text = snapshot.data!['original_text'];
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: Color(0xFFFFC857),
                  size: 25.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Color(0xFF00073e),
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
                        color: Color(0xFFFFC857),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              color:Color(0xFFFFC857),
              child: RawScrollbar(
                thumbColor: Colors.white70,
                thickness: 4,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "Audio",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Amaranth',
                                        color: Color(0xFF181621),
                                      ),
                                    ),
                                  ),
                                  IconButton(icon: Icon(
                                    Icons.volume_up,
                                    color: Color(0xFF181621),
                                    size: 28.0,
                                  ), onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            elevation: 10.0,
                                            alignment: Alignment(0,0.3),
                                            child: Container(
                                              height: MediaQuery.of(context).size.height * 0.40,
                                              width: MediaQuery.of(context).size.width*0.80,
                                              decoration: BoxDecoration(
                                                color:Color(0xFFFFC857),
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black.withOpacity(0.3),
                                                      offset: Offset(0, -2),
                                                      blurRadius: 15.0,
                                                      spreadRadius: 0.0
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: RawScrollbar(
                                                      thumbColor: Colors.black26,
                                                      thickness: 4,
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.vertical,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: Transliterate(widget._storyID, flutterTts, o_text),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  })

                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.04,
                              ),
                              Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "Original",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Amaranth',
                                        color: Color(0xFF181621),
                                      ),
                                    ),
                                  ),
                                  Switch(
                                    value: isSwitched3,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isSwitched3 = value;
                                      });
                                    },
                                    activeTrackColor: Color(0xFF181621),
                                    activeColor:Colors.blue,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.04,
                              ),
                              Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "Transliteration",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'Amaranth',
                                        color: Color(0xFF181621),
                                      ),
                                    ),
                                  ),
                                  Switch(
                                    value: isSwitched2,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isSwitched2 = value;
                                      });
                                    },
                                    activeTrackColor: Color(0xFF181621),
                                    activeColor:Colors.blue,
                                  ),
                                ],
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                            ],
                          ),
                          // color: Color(0xFF181621),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        if (isSwitched2 == false && /* isSwitched1 == false && */  isSwitched3 == true ||
                            isSwitched2 == false && /* isSwitched1 == false && */ isSwitched3 == false)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.74,
                            width: MediaQuery.of(context).size.width*0.95,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 238, 222, 187),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, -2),
                                    blurRadius: 15.0,
                                    spreadRadius: 0.0
                                ),
                              ],

                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RawScrollbar(
                                    thumbColor: Colors.black26,
                                    thickness: 4,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: HighlightedText(text: o_text, flutterTts: flutterTts),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isSwitched2 == true /* && isSwitched1 == false */ && isSwitched3 == false)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.74,
                            width: MediaQuery.of(context).size.width*0.95,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 238, 222, 187),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, -2),
                                    blurRadius: 15.0,
                                    spreadRadius: 0.0
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RawScrollbar(
                                    thumbColor: Colors.black26,
                                    thickness: 4,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          t_text,
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

                        if (isSwitched2 == true && isSwitched3 == true)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width*0.95,
                            decoration: BoxDecoration(
                              color:Color.fromARGB(255, 238, 222, 187),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, -2),
                                    blurRadius: 15.0,
                                    spreadRadius: 0.0
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RawScrollbar(
                                    thumbColor: Colors.black26,
                                    thickness: 4,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: HighlightedText(text: o_text, flutterTts: flutterTts),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (isSwitched2 == true /* || isSwitched1 == true */)
                          SizedBox(
                            height: 15.0,
                          ),
                        if (isSwitched2 == true)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width*0.95,
                            decoration: BoxDecoration(
                              color:Color.fromARGB(255, 238, 222, 187),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(0, -2),
                                    blurRadius: 15.0,
                                    spreadRadius: 0.0
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RawScrollbar(
                                    thumbColor: Colors.black26,
                                    thickness: 4,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          t_text,
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
