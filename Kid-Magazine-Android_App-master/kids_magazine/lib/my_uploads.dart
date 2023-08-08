import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_magazine/story.dart';

class MyUploads extends StatefulWidget {
  final String userId;
  MyUploads(this.userId);
  @override
  _MyUploadsState createState() => _MyUploadsState();
}

class _MyUploadsState extends State<MyUploads> {
  CollectionReference img = FirebaseFirestore.instance.collection('stories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00073e),
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
        title: Text(
          "My Uploaded Stories",
          style: TextStyle(
            fontSize: 23.0,
            fontFamily: 'Amaranth',
            color: Color(0xFFFFC857),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFFFC857),
        child: Column(
          children: [
            SizedBox(
              height: 15.0,
            ),
            Flexible(
              child: RawScrollbar(
                thumbColor: Colors.black38,
                thickness: 4,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stories')
                        .where("uid", isEqualTo: widget.userId)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List<Widget> stories =
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                        print(document['image']);
                        if (document['image'] == null)
                          img.doc(document.id).update({
                            'image':
                            'https://firebasestorage.googleapis.com/v0/b/kids-magazine-c41d5.appspot.com/o/storyImages%2F4ea7b85bef0659b784f05faec7664278.jpg?alt=media&token=4326548d-263a-4a19-b509-5a18477c3ce6'
                          });
                        if (document['status'] == 'approved')
                          return GestureDetector(
                            onTap: () {
                              // Story(document.id);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Story(document.id)),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 2.0, 10.0, 2.0),
                              child: Card(
                                color: Color(0xFF181621),
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  // if you need this
                                  side: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                child: Container(
                                  color: Colors.transparent,
                                  width: 180,
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Container(
                                        width: 70.0,
                                        height: 70.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              document['image'],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              document['title'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                fontFamily: 'JosefinSans',
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFFFFC857),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 7.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 70.0,
                                                ),
                                                Text(
                                                  "~ ",
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontFamily: 'JosefinSans',
                                                    color: Color(0xFFFFC857),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    document['author'],
                                                    maxLines: 1,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontFamily: 'JosefinSans',
                                                      color: Color(0xFFFFC857),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        else {
                          return Container(
                            height: 0,
                          );
                        }
                      }).toList();
                      stories.add(Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 40,
                                color: Color(0xFF181621),
                              ),
                              Text(
                                "You're All Caught Up",
                                style: Theme.of(context).textTheme.headline6,
                              )
                            ],
                          )));
                      return new ListView(children: stories);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
