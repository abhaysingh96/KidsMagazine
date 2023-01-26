import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kids_magazine/welcome.dart';

import 'home.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _nameController.text = user!.displayName!;
  }

  void formProcessor() async {
    /*
      Add the document of the UserDetails to the usercollection class
      For model reference, check models.dart
    */
    final database = FirebaseFirestore.instance.collection('users');
    await database.doc('${user!.uid}').set({
      'name': _nameController.text,
      'uid': user!.uid,
      'email': user!.email,
      'phone': int.parse(_phoneNoController.text),
      'age': _ageController.text,
      'type': 'user',
    });
  }

  void _showDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF181D3D)),
          ),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("  Registering...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // Doesn't allow the dialog box to pop
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: alert);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  height: MediaQuery.of(context).size.height,
                  color: Color(0xFFfea13a),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.88,
                  height: MediaQuery.of(context).size.height,
                  color: Color(0xFF181621),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70.0,
                      ),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: 'Amaranth',
                          color: Color(0xFFfea13a),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return 'Name field cannot be Empty ';
                                    }
                                    return null;
                                  },
                                  controller: _nameController,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Color(0xFFfea13a),
                                    ),
                                    labelText: 'Username',
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                      borderSide: BorderSide(
                                        color: Color(0xFFfea13a),
                                        width: 3.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                      borderSide: BorderSide(
                                        color: Color(0xFFfea13a),
                                        width: 3.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == "") {
                                      return 'Phone Number cannot be left Empty';
                                    }
                                    final n = num.tryParse(value!);
                                    if (n == null) {
                                      return '"$value" is not a valid phone number';
                                    }
                                    if (value.length != 10)
                                      return 'Roll Number must contain 10 digits';
                                    return null;
                                  },
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  cursorColor: Colors.white,
                                  controller: _phoneNoController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Color(0xFFfea13a),
                                    ),
                                    labelText: 'Phone No.',
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                      borderSide: BorderSide(
                                        color: Color(0xFFfea13a),
                                        width: 3.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                      borderSide: BorderSide(
                                        color: Color(0xFFfea13a),
                                        width: 3.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == "") {
                                      return 'Age cannot be left Empty';
                                    }
                                    final n = num.tryParse(value!);
                                    if (n == null) {
                                      return '"$value" is not a Age';
                                    }

                                    return null;
                                  },
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  cursorColor: Colors.white,
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Color(0xFFfea13a),
                                    ),
                                    labelText: 'Age',
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                      borderSide: BorderSide(
                                        color: Color(0xFFfea13a),
                                        width: 3.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                      borderSide: BorderSide(
                                        color: Color(0xFFfea13a),
                                        width: 3.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text("Establishing contact with server"),
                                          duration: Duration(milliseconds: 300),
                                        ),
                                      );
                                      formProcessor();
                                      Navigator.pop(context, '/');
                                      Navigator.pop(context, '/RegisterPage');
                                      Navigator.pushReplacementNamed(
                                          context, '/home');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    padding: EdgeInsets.fromLTRB(
                                        30.0, 12.0, 30.0, 9.0),
                                    foregroundColor: Colors.orange,
                                  ),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontFamily: 'Amaranth',
                                      color: Color(0xFF181621),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
