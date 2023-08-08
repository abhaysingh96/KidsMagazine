import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin.dart';
import 'register.dart';
import 'select.dart';
import 'welcome.dart';

class KidsMagazine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'KidsMagazine',
      routes: {
        // '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/': (context) => WelcomePage(),
        '/select': (context) => SelectLanguage(),
        // '/home' : (context) => HomePage(),
        // '/story' : (context) => Story(),
        '/admin': (context) => AdminPage(),
        // '/uploadStory' : (context) => UploadStory(),
        // '/adminStory' : (context) => AdminStory(),
      },
    );
  }
}
