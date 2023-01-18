
import 'package:flutter/material.dart';
import 'package:kids_magazine/select.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.65,
          color: Color(0xFFfea13a),
          child: ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/welcome.jpg"),
            ))),
            // color: Color(0xFF181621)
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.36,
              color: Color(0xFFfea13a),
              child: Column(
                children: [
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: Text(
                      "Welcome !!",
                      style: TextStyle(
                        fontSize: 30.0,
                        decoration: TextDecoration.none,
                        fontFamily: 'Amaranth',
                        color: Color(0xFF181621),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      "Soar through a magnificent world of dreams",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        decoration: TextDecoration.none,
                        fontFamily: 'JosefinSans',
                        color: Color(0xFF181621),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  RaisedButton(
                    padding: EdgeInsets.fromLTRB(41.0, 12.0, 41.0, 9.0),
                    elevation: 20.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Color(0xFFfea13a),
                    onPressed: () {
                      Navigator.push(
                        context,
                        // MaterialPageRoute(builder: (context) => Transliterate()),
                        MaterialPageRoute(
                            builder: (context) => SelectLanguage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "HERE WE GO!",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Amaranth',
                          color: Color(0xFF181621),
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
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
