import 'dart:convert';

import 'package:cryptowallet/screens/constants/data.dart';
import 'package:cryptowallet/screens/constants/locals.dart';
import 'package:cryptowallet/screens/constants/otp.dart';
import 'package:cryptowallet/screens/enterPhrase.dart';
import 'package:cryptowallet/screens/list_of_my_seedphrases.dart';
import 'package:cryptowallet/screens/login.dart';
import 'package:cryptowallet/screens/main_screen.dart';
import 'package:cryptowallet/screens/recovery_pharse.dart';
import 'package:cryptowallet/screens/view_seedPhrases.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Settings extends StatefulWidget {
  var isDarkMode;
  Settings({this.isDarkMode});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  var otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.brightness_2_outlined),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Dark Mode',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: StreamBuilder(stream: () async* {
                        while (true) {
                          await Future.delayed(Duration(seconds: 1));
                          var pref = await SharedPreferences.getInstance();
                          if (pref.getBool('useDark') == null) {
                            yield true;
                            return;
                          }
                          yield pref.getBool('useDark');
                        }
                      }(), builder: (context, snapshot) {
                        if (snapshot.hasError) print('error');
                        if (snapshot.hasData) {
                          return CupertinoSwitch(
                              onChanged: (value) async {
                                var pref =
                                    await SharedPreferences.getInstance();
                                pref.setBool('useDark', value);
                                MyApp.themeNotifier.value =
                                    value ? ThemeMode.dark : ThemeMode.light;
                              },
                              value: snapshot.data as bool);
                        }
                        return CupertinoSwitch(
                            onChanged: (value) async {
                              var pref = await SharedPreferences.getInstance();
                              pref.setBool('useDark', value);
                              MyApp.themeNotifier.value =
                                  value ? ThemeMode.dark : ThemeMode.light;
                            },
                            value: widget.isDarkMode);
                      }),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                InkWell(
                  onTap: () async {
                    // var localAuth = LocalAuthentication();
                    // bool didAuthenticate = await localAuth.authenticate(
                    //     localizedReason:
                    //         'Please authenticate to show account balance');
                    // if (didAuthenticate) {
                    //   String seedPhrase =
                    //       (await SharedPreferences.getInstance())
                    //           .getString('mmemomic') as String;
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (ctx) => RecoveryPhrase(
                    //               data: seedPhrase, verify: false)));
                    // }
                    String message = "You currently requested to see your Seed Phrase.";
                    var instance = await SharedPreferences.getInstance();
                    String? currentUserEmail = instance.getString(emailLocals);
                    int generatedCode = OTP.generateOTPcode();
                    if(currentUserEmail != null){  
                      // calling send email function
                      await OTP.sendOTPMail(generatedCode, currentUserEmail, context, message);                  
                      // Dialog for code
                      showDialog(context: context, barrierDismissible: false, builder: (context) => AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Verification Code"),
                            SizedBox(height: 30),
                            Container(
                              height: 40,
                              child: TextFormField(                                      
                                controller: otpController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                    hintText: 'Enter code here',                                            
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Resend'),
                            onPressed: () async {
                              generatedCode = OTP.generateOTPcode();
                              await OTP.sendOTPMail(generatedCode, currentUserEmail, context, message);
                            },
                          ),
                          TextButton(
                            child: const Text('Continue'),
                            onPressed: () async {                            
                              if(int.parse(otpController.text.trim()) == generatedCode){                                                          
                                Navigator.pop(context);   
                                // Load data if userData is null
                                  if(currentUserEmail !=null && importedSeedPhrasesList.isEmpty && createdSeedPhrasesList.isEmpty){
                                    await fetchImportedSeedPhrases(currentUserEmail);
                                    await fetchCreatedSeedPhrases(currentUserEmail);
                                  }             
                                // going to see seedphrase                                         
                                Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ListOfMySeedPhrases()));
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Incorrect code. Try again',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              }                              
                            },
                          ),
                        ],
                      ));                 
                      
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.vpn_key),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Show Seed Phrase',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => MainScreen(add: true)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.vpn_key),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Import Phrase',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                InkWell(
                  onTap: () async {
                     var seedPhrases = (await SharedPreferences.getInstance());
                     String seed = seedPhrases.getString('seedPhrases')!;
                     print(seed);
                    var localAuth = LocalAuthentication();
                    bool didAuthenticate = await localAuth.authenticate(
                        localizedReason:
                            'Please authenticate to show account balance');
                    if (didAuthenticate) {
                      var seedPhrases = (await SharedPreferences.getInstance())
                          .getString('seedPhrases');
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (ctx) => ViewSeedPhrase(
                      //               data: jsonDecode(seedPhrases!) as List,
                      //             )));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.vpn_key),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'View Wallets',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                InkWell(
                  onTap: () async {
                    var sharedPrefInstance = await SharedPreferences.getInstance();
                    sharedPrefInstance.clear();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => login()), (route) => false); 
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged out')));                   
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(FontAwesomeIcons.signOut),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Log out',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
