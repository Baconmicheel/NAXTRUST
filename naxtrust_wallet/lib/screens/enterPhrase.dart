import 'dart:convert';

import 'package:bech32/bech32.dart';
import 'package:cryptowallet/screens/constants/locals.dart';
import 'package:cryptowallet/screens/wallet.dart';
import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:defichaindart/defichaindart.dart';
import 'package:flutter/material.dart';
import 'package:hash/hash.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/web3dart.dart';

class EnterPhrase extends StatefulWidget {
  var add;
  EnterPhrase({this.add});
  @override
  State<EnterPhrase> createState() => _EnterPhraseState();
}

class _EnterPhraseState extends State<EnterPhrase> {
  var seedPhraseController = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> getEmail() async{
    SharedPreferences a = await SharedPreferences.getInstance();
    var email = a.getString(emailLocals);
    print(email);
    return email!;
  }

  
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 5,
                  controller: seedPhraseController,
                  decoration: InputDecoration(
                    hintText: 'Enter Seed Phrase eg rabbit skill home great etc.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.blue,
                    ),                    
                    onPressed: () async {
                      try {
                        const defaultSeedPhraseLength = 12;
                        if (seedPhraseController.text.trim() == '') return;

                        if (seedPhraseController.text.trim().split(' ').length != defaultSeedPhraseLength) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('seed phrase can only be 12 words')),
                          );
                          return;
                        }

                        var seedPhrases =
                            (await SharedPreferences.getInstance())
                                .getString('seedPhrases');

                        if (seedPhrases != null && (jsonDecode(seedPhrases) as List).contains(seedPhraseController.text.trim())) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('seed phrase already imported')));
                          return;
                        }

                        if (seedPhrases == null) {
                          (await SharedPreferences.getInstance()).setString(
                              'seedPhrases',
                              jsonEncode([seedPhraseController.text.trim()]));
                        } else {
                          var decodedSeedPhrase =
                              jsonDecode(seedPhrases) as List;

                          (await SharedPreferences.getInstance()).setString(
                              'seedPhrases',
                              jsonEncode(decodedSeedPhrase
                                ..add(seedPhraseController.text.trim())));
                        }

                        var SPref = await SharedPreferences.getInstance();

                        await SPref.setString('mmemomic', seedPhraseController.text.trim());
                            
                        await SPref.setString('seedPhrases', jsonEncode([seedPhraseController.text.trim()]));

                        var seed = bip39.mnemonicToSeed(seedPhraseController.text.trim());
                        var hdWallet = HDWallet.fromSeed(seed);
                       // PERFORM A HASH: seed -> sha256 -> ripemd160
                        var shapp256 = SHA256().update(seed).digest();
                        var ripmd160 = RIPEMD160().update(shapp256).digest();

                        print("RIPEMD160 digest as bytes: ${RIPEMD160().update(shapp256).digest()}"); // testing
                        print("SHA256 digest as bytes: ${SHA256().update(seed).digest()}");  // testing
                          
                        // Generate a segwit bitcoin address
                        var buildSegwitAddress = Segwit('bc', 1, ripmd160);
                        var segwitBitcoinAddress = segwit.encode(buildSegwitAddress);
                        // Saving the Bitcoin Address to Locals
                        await SPref.setString(userBitCoinAddress , segwitBitcoinAddress);

                        // Ethereum
                        var privateKey = hdWallet.privKey;
                        final credentials = EthPrivateKey.fromHex(privateKey!);
                        final ethereumAddress = credentials.address;
                        await SPref.setString(userEthereumAddress , ethereumAddress.toString());

                        // Saving seedPhrase to DataBase
                        if(seedPhraseController.text.trim().isNotEmpty){
                          var seedList = seedPhraseController.text.trim().split(' ');
                          if(seedList.length == defaultSeedPhraseLength){
                            var sharedPInstance = await SharedPreferences.getInstance();
                            var userEmail = sharedPInstance.getString(emailLocals);
                            await userWalletRef.doc(userEmail).collection('Imported_Wallets').doc('Imported_seedphrase').set({'seed_phrase': seedList});
                            print("Imported Phrase Saved in DB"); //testing
                            await sharedPInstance.setBool(isSeedPhraseSaved, true);                          
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => WalletScreen()), (r) => false);
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('seed phrase can only be 12 words')),
                            );
                          }
                          
                        }

                        
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
