//@dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:cryptowallet/screens/constants/locals.dart';
import 'package:cryptowallet/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import './login.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bip39/bip39.dart' as bip39;

class signUp extends StatefulWidget {
  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var countryName = '';
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  var hidePassword = true;
  var isLoading = false;
  File image;
  File image1;
  File image2;
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
                      Text('NAXTRUST SIGN UP'),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(hintText: 'Email'),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(hintText: 'Name'),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(hintText: 'Phone'),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: CountryCodePicker(
                          alignLeft: true,
                          onChanged: (countryCode) {
                            countryName = countryCode.toCountryStringOnly();
                          },
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                        ),
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
                      SizedBox(height: 50),
                      // GestureDetector(
                      //   onTap: () {
                      //     showDialog<ImageSource>(
                      //       context: context,
                      //       builder: (context) => AlertDialog(
                      //           content: Text("Choose image source"),
                      //           actions: [
                      //             TextButton(
                      //               child: Text("Camera"),
                      //               onPressed: () => Navigator.pop(
                      //                   context, ImageSource.camera),
                      //             ),
                      //             TextButton(
                      //               child: Text("Gallery"),
                      //               onPressed: () => Navigator.pop(
                      //                   context, ImageSource.gallery),
                      //             ),
                      //           ]),
                      //     ).then((ImageSource source) async {
                      //       if (source != null) {
                      //         image = File((await ImagePicker().pickImage(
                      //           source: source,
                      //         ))
                      //             .path);
                      //         setState(() {});
                      //       }
                      //     });
                      //   },
                      //   child: Container(
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //         color: Colors.blue,
                      //         borderRadius: BorderRadius.circular(10)),
                      //     height: 200,
                      //     child: image != null
                      //         ? Image.file(image)
                      //         : Center(
                      //             child: Text(
                      //               'Upload Face ID',
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 16),
                      //             ),
                      //           ),
                      //   ),
                      // ),
                      // SizedBox(height: 20),
                      // GestureDetector(
                      //   onTap: () {
                      //     showDialog<ImageSource>(
                      //       context: context,
                      //       builder: (context) => AlertDialog(
                      //           content: Text("Choose image source"),
                      //           actions: [
                      //             TextButton(
                      //               child: Text("Camera"),
                      //               onPressed: () => Navigator.pop(
                      //                   context, ImageSource.camera),
                      //             ),
                      //             TextButton(
                      //               child: Text("Gallery"),
                      //               onPressed: () => Navigator.pop(
                      //                   context, ImageSource.gallery),
                      //             ),
                      //           ]),
                      //     ).then((ImageSource source) async {
                      //       if (source != null) {
                      //         image1 = File((await ImagePicker().pickImage(
                      //           source: source,
                      //         ))
                      //             .path);
                      //         setState(() {});
                      //       }
                      //     });
                      //   },
                      //   child: Container(
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //         color: Colors.blue,
                      //         borderRadius: BorderRadius.circular(10)),
                      //     height: 200,
                      //     child: image1 != null
                      //         ? Image.file(image1)
                      //         : Center(
                      //             child: Text(
                      //               'Upload ID card Front',
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 16),
                      //             ),
                      //           ),
                      //   ),
                      // ),
                      // SizedBox(height: 20),
                      // GestureDetector(
                      //   onTap: () {
                      //     showDialog<ImageSource>(
                      //       context: context,
                      //       builder: (context) => AlertDialog(
                      //           content: Text("Choose image source"),
                      //           actions: [
                      //             TextButton(
                      //               child: Text("Camera"),
                      //               onPressed: () => Navigator.pop(
                      //                   context, ImageSource.camera),
                      //             ),
                      //             TextButton(
                      //               child: Text("Gallery"),
                      //               onPressed: () => Navigator.pop(
                      //                   context, ImageSource.gallery),
                      //             ),
                      //           ]),
                      //     ).then((ImageSource source) async {
                      //       if (source != null) {
                      //         image2 = File((await ImagePicker().pickImage(
                      //           source: source,
                      //         ))
                      //             .path);
                      //         setState(() {});
                      //       }
                      //     });
                      //   },
                      //   child: Container(
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //         color: Colors.blue,
                      //         borderRadius: BorderRadius.circular(10)),
                      //     height: 200,
                      //     child: image2 != null
                      //         ? Image.file(image2)
                      //         : Center(
                      //             child: Text(
                      //               'Upload ID card Back',
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 16),
                      //             ),
                      //           ),
                      //   ),
                      // ),
                      // SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) => login()));
                        },
                        child: Text('LOGIN'),
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
                                passwordController.text.trim() != '' &&
                                nameController.text.trim() != '' &&
                                phoneController.text.trim() != '' &&
                                countryName != ''                               
                              ) {
                              setState(() {
                                isLoading = true;
                              });
                              // List<int> imageBytes = image.readAsBytesSync();
                              // String faceId = base64Encode(imageBytes);
                              // List<int> imageBytes1 = image1.readAsBytesSync();
                              // String idCardFront = base64Encode(imageBytes1);
                              // List<int> imageBytes2 = image2.readAsBytesSync();
                              // String idCardBack = base64Encode(imageBytes2);
                              var response = jsonDecode((await post(
                                      Uri.parse(
                                          'https://naxtrust.com/user/signup'),
                                      body: jsonEncode({
                                        'faceId': 'null',
                                        'idCardFront': 'null',
                                        'idCardBack': 'null',
                                        'userName': nameController.text.trim(),
                                        'email': emailController.text.trim(),
                                        'password':
                                            passwordController.text.trim(),
                                        'phone': phoneController.text.trim(),
                                        'country': countryName,
                                        'cryptoAccount':
                                            bip39.generateMnemonic(),
                                      })))
                                  .body);

                              print(response);
                              if (response['success']) {
                                var instancePref = await SharedPreferences.getInstance();
                                await instancePref.setString(emailLocals, emailController.text.trim());                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Sign up successful')));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Sign up failed')));
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'please fill all fields, and choose a country')));
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

upload(File imageFile, String fileName, MediaType imageMediaType, uploadURL,
    Map fieldsMap) async {
  try {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(uploadURL);

    var request = http.MultipartRequest("POST", uri);

    var instancePref = await SharedPreferences.getInstance();
    var userVerified = instancePref.getString('userVerified');

    request.headers.addAll({'Cookie': 'userVerified=${userVerified}'});
    for (var key in fieldsMap.keys) {
      request.fields[key] = fieldsMap[key];
    }

    var multipartFile = http.MultipartFile(fileName, stream, length,
        filename: basename(imageFile.path), contentType: imageMediaType);

    request.files.add(multipartFile);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  } catch (e) {
    print('failed upload' + e.toString());
  }
}

uploadMultiple(List<File> imageFile, List<String> fileName,
    MediaType imageMediaType, uploadURL, Map fieldsMap) async {
  try {
    var uri = Uri.parse(uploadURL);

    var request = http.MultipartRequest("POST", uri);

    var instancePref = await SharedPreferences.getInstance();
    var userVerified = instancePref.getString('userVerified');

    request.headers.addAll({'Cookie': 'userVerified=${userVerified}'});
    for (var key in fieldsMap.keys) {
      request.fields[key] = fieldsMap[key];
    }

    for (int i = 0; i < imageFile.length; i++) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile[i].openRead()));
      var length = await imageFile[i].length();
      var multipartFile = http.MultipartFile(fileName[i], stream, length,
          filename: basename(imageFile[i].path), contentType: imageMediaType);
      request.files.add(multipartFile);
    }
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  } catch (e) {
    print('failed upload' + e.toString());
  }
}
