import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medical/routes/home.dart';
import 'package:flutter_medical/widgets.dart';
import 'package:flutter_medical/services/authenticate.dart';
import 'package:flutter_medical/services/authentication.dart';
import 'package:flutter_medical/services/database.dart';
import 'package:flutter_medical/services/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage(this.toggleView);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  AuthMethods authService = new AuthMethods();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot = await DatabaseMethods()
              .getUserInfo(emailTextEditingController.text);

          CheckSharedPreferences.saveUserLoggedInSharedPreference(true);
          CheckSharedPreferences.saveNameSharedPreference(
              userInfoSnapshot.docs[0].data()["name"]);
          CheckSharedPreferences.saveUserEmailSharedPreference(
              userInfoSnapshot.docs[0].data()["email"]);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        } else {
          setState(() {
            isLoading = false;
            // TODO
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: SingleChildScrollView(
            child: Container(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.75,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-1.0, 0.0),
                          end: Alignment(1.0, 0.0),
                          colors: [
                            const Color(0xFF6aa6f8),
                            const Color(0xFF1a60be)
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                                left: 40.0,
                                right: 40.0,
                              ),
                              child: Text(
                                'Lorem ipsum dolor sit amet, aliqua consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore. ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            transform:
                                Matrix4.translationValues(0.0, 60.0, 0.0),
                            margin: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                            ),
                            width: double.infinity,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              color: Color(0xFFFFFFFF),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 50.0,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 20.0,
                                    left: 20.0,
                                    right: 20.0,
                                    bottom: 20.0,
                                  ),
                                  child: TextFormField(
                                    controller: emailTextEditingController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val) {
                                      return RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+|.[a-zA-Z]+")
                                              .hasMatch(val)
                                          ? null
                                          : "Please enter a valid email address";
                                    },
                                    textCapitalization: TextCapitalization.none,
                                    decoration: InputDecoration(
                                      hintText: 'email@emailaddress.com',
                                      hintStyle: TextStyle(
                                        color: Color(0xFFb1b2c4),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF6aa6f8),
                                            width: 0.0),
                                      ),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20.0,
                                          left: 10.0,
                                          bottom: 1.0,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: Color(0xFF6aa6f8),
                                        ),
                                      ),
                                      //
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    bottom: 20.0,
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (val) {
                                      return val.length > 6
                                          ? null
                                          : "Password must be greater than 6 characters";
                                    },
                                    controller: passwordTextEditingController,
                                    textCapitalization: TextCapitalization.none,
                                    decoration: InputDecoration(
                                      hintText: 'password',
                                      hintStyle: TextStyle(
                                        color: Color(0xFFb1b2c4),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF6aa6f8),
                                            width: 0.0),
                                      ),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20.0,
                                          left: 10.0,
                                          bottom: 1.0,
                                        ),
                                        child: Icon(
                                          Icons.lock_outline,
                                          color: Color(0xFF6aa6f8),
                                        ),
                                      ),
                                      //
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 90.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: RaisedButton(
                        color: Color(0xFF4894e9),
                        padding: EdgeInsets.all(15),
                        onPressed: () {
                          signIn();
                        },
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Need an account? Create one instead.',
                            style: TextStyle(
                                color: Color(0xFF4894e9),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () {
                          widget.toggleView();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
