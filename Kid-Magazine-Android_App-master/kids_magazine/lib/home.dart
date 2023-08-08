import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kids_magazine/register.dart';
import 'package:kids_magazine/select.dart';
import 'package:kids_magazine/story.dart';
import 'package:kids_magazine/uploadStory.dart';
//import 'package:kids_magazine/welcome.dart';

import 'admin.dart';
import 'my_uploads.dart';

class HomePage extends StatefulWidget {
  final String _SelectedLanguage;

  HomePage(this._SelectedLanguage);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CollectionReference img = FirebaseFirestore.instance.collection('stories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(widget._SelectedLanguage),
      appBar: AppBar(
        backgroundColor: Color(0xFF00073e),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color(0xFFFFC857),
            size: 30.0,
          ),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        title: Text(
          "StoryTime",
          style: TextStyle(
            fontSize: 25.0,
            fontFamily: 'Amaranth',
            color:Color(0xFFFFC857),
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
                          .where("language", isEqualTo: widget._SelectedLanguage)
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
                                  color: Color.fromARGB(255, 238, 222, 187),
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
                                                  color:Colors.black,
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
                                                      color: Colors.black,
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
                                                        color: Colors.black,
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
                                  style: Theme.of(context).textTheme.titleLarge,
                                )
                              ],
                            )));
                        return new ListView(children: stories);
                      }),
                ),
              ),
            ],
          )),
    );
  }
}

class NavDrawer extends StatefulWidget {
  final String _SelectedLanguage;

  NavDrawer(this._SelectedLanguage);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    void signOut() {
      googleSignIn.signOut();
      Navigator.pop(context);
    }

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    // final String email = googleUser.email;

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential _currentUser =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (_currentUser.additionalUserInfo!.isNewUser) {
      // The user is just created
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
    } else {
      // The user is already there, so redirect to feed

      if (_currentUser.user!.email == 'irlabiit0@gmail.com' ||
          _currentUser.user!.email == 'pkenny.mukeshbhai.cse19@itbhu.ac.in') {
        //take to the admin side
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(widget._SelectedLanguage)),
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        color: Color(0xFFFFC857),
        child: ListView(
          padding: EdgeInsets.all(0.0),
          children: [
            DrawerHeader(
              child: Text(
                "Parental Kids Magazine",
                style: TextStyle(
                    fontFamily: 'JosefinSans',
                    fontSize: 21.0,
                    color: Color(0xFF181621),
                    fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/sidebar.jpg"),
              )),
            ),
            Container(
              color: Color(0xFFFFC857),
              child: Column(
                children: [
                  if (user == null)
                    ListTile(
                      leading: Icon(
                        Icons.login,
                        color: Color(0xFF181621),
                      ),
                      title: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xFF181621),
                        ),
                      ),
                      onTap: () {
                        signInWithGoogle();
                      },
                    ),
                  if (user == null)
                    ListTile(
                      leading: Icon(
                        Icons.login_sharp,
                        color: Color(0xFF181621),
                      ),
                      title: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xFF181621),
                        ),
                      ),
                      onTap: () {
                        signInWithGoogle();
                      },
                    ),
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: Color(0xFF181621),
                    ),
                    title: Text(
                      'Change Language',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF181621),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectLanguage()),
                      );
                    },
                  ),
                  if (user != null)
                    ListTile(
                      leading: Icon(
                        Icons.upload_rounded,
                        color: Color(0xFF181621),
                      ),
                      title: Text(
                        'Upload Story',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xFF181621),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UploadStory(widget._SelectedLanguage)),
                        );
                      },
                    ),
                  if (user != null &&
                      (user!.email == 'pkenny.mukeshbhai.cse19@itbhu.ac.in' ||
                          user!.email == "irlabiit0@gmail.com"))
                    ListTile(
                      leading: Icon(
                        Icons.upload_file,
                        color: Color(0xFF181621),
                      ),
                      title: Text(
                        'Uploaded Stories',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xFF181621),
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminPage()),
                        );
                      },
                    ),
                  if (user != null)
                    ListTile(
                      leading: Icon(
                        Icons.folder_rounded,
                        color: Color(0xFF181621),
                      ),
                      title: Text(
                        'My Uploads',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xFF181621),
                        ),
                      ),
                      onTap: () {
                        // print(user.uid);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyUploads(user!.uid)),
                        );
                      },
                    ),
                  if (user != null)
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Color(0xFF181621),
                      ),
                      title: Text(
                        'LogOut',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xFF181621),
                        ),
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        await GoogleSignIn().signOut();
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
