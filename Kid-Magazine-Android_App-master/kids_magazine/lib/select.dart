import 'package:flutter/material.dart';
import 'package:kids_magazine/home.dart';

class SelectLanguage extends StatefulWidget {
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFC857),
      child: Column(
        children: [
          SizedBox(height: 120.0),
          Text(
            "Select your Language",
            style: TextStyle(
              fontSize: 30.0,
              fontFamily: 'JosefinSans',
              decoration: TextDecoration.none,
              color: Color(0xFF181621),
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
             padding: EdgeInsets.fromLTRB(45.0, 12.0, 45.0, 9.0),
            elevation: 20.0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            foregroundColor: Color(0xFF181621), 
            ),
            // padding: EdgeInsets.fromLTRB(45.0, 12.0, 45.0, 9.0),
            // elevation: 20.0,
            // shape: RoundedRectangleBorder(
            //   side: BorderSide(
            //     color: Colors.transparent,
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            // color: Color(0xFF181621),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage("Bengali")),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "Bengali",
                style: TextStyle(
                  fontSize: 23.0,
                  fontFamily: 'Amaranth',
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
               padding: EdgeInsets.fromLTRB(50.0, 12.0, 50.0, 9.0),
            elevation: 20.0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            foregroundColor: Color(0xFF181621),
            ),
            // padding: EdgeInsets.fromLTRB(41.0, 12.0, 41.0, 9.0),
            // elevation: 20.0,
            // shape: RoundedRectangleBorder(
            //   side: BorderSide(
            //     color: Colors.transparent,
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            // color: Color(0xFF181621),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage("Gujarati")),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "Gujarati",
                style: TextStyle(
                  fontSize: 23.0,
                  fontFamily: 'Amaranth',
                  color:Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
               padding: EdgeInsets.fromLTRB(50.0, 12.0, 50.0, 9.0),
            elevation: 20.0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            foregroundColor: Color(0xFF181621),
            ),
            // padding: EdgeInsets.fromLTRB(50.0, 12.0, 50.0, 9.0),
            // elevation: 20.0,
            // shape: RoundedRectangleBorder(
            //   side: BorderSide(
            //     color: Colors.transparent,
            //   ),
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            // color: Color(0xFF181621),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage("Telugu")),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "Telugu",
                style: TextStyle(
                  fontSize: 23.0,
                  fontFamily: 'Amaranth',
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}