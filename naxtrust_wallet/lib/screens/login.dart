import 'dart:convert';

import 'package:cryptowallet/screens/constants/locals.dart';
import 'package:cryptowallet/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import './signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  var hidePassword = true;
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: FutureBuilder(future: () async {
          var instancePref = await SharedPreferences.getInstance();
          var userVerified = instancePref.getString('userVerified');
          return jsonDecode((await get(Uri.parse(
                  'https://naxtrust.com/checklogin?userVerified=${userVerified}')))
              .body);
        }(), builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            var response = snapshot.data as Map;
            if (response['success']) {
              return MainScreen();
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text('NAXTRUST LOG IN'),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(hintText: 'Email'),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: hidePassword,
                        controller: passwordController,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(hidePassword
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                            )),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) => signUp()));
                        },
                        child: Text('SIGN UP'),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                             shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          // splashColor: Colors.grey,
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                          onPressed: () async {
                            if (emailController.text.trim() != '' &&
                                passwordController.text.trim() != '') {
                              setState(() {
                                isLoading = true;
                              });
                              var response = jsonDecode((await post(
                                      Uri.parse(
                                          'https://naxtrust.com/user/login'),
                                      headers: {
                                        'content-type': 'application/json'
                                      },
                                      body: jsonEncode({
                                        'email': emailController.text.trim(),
                                        'password':
                                            passwordController.text.trim(),
                                      })))
                                  .body);

                              if (response['success']) {                                
                                var instancePref =
                                    await SharedPreferences.getInstance();
                                await instancePref.setString(emailLocals, emailController.text.trim());                                  
                                await instancePref.setString(
                                    'userVerified', response['userVerified']);
                                await instancePref.setString(
                                    'userId', response['user_id'].toString());
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Logged In')));

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => MainScreen()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Failed to login, invalid username or password')));
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('please fill all fields')));
                            }
                          },                         
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }
}
