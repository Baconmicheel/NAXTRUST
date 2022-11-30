import 'package:bech32/bech32.dart';
import 'package:cryptowallet/screens/constants/data.dart';
import 'package:cryptowallet/screens/constants/locals.dart';
import 'package:cryptowallet/screens/enterPhrase.dart';
import 'package:cryptowallet/screens/recovery_pharse.dart';
import 'package:cryptowallet/screens/wallet.dart';
import 'package:defichaindart/defichaindart.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:hash/hash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';





class MainScreen extends StatefulWidget {
  var add;
  MainScreen({this.add});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Future<void> getUserData() async{
    var instance = await SharedPreferences.getInstance();
    String? userEmail = instance.getString(emailLocals);
    if(userEmail !=null && importedSeedPhrasesList.isEmpty && createdSeedPhrasesList.isEmpty){
      await fetchImportedSeedPhrases(userEmail);
      await fetchCreatedSeedPhrases(userEmail);
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(stream: () async* {
        if (widget.add != null) {
          yield false;
          return;
        }
        var SPref = await SharedPreferences.getInstance();
        getUserData();
        
        yield SPref.get('mmemomic') != null && SPref.getBool(isSeedPhraseSaved) != null;
      }(), builder: (context, snapshot) {
        return snapshot.data == true
            ? WalletScreen()
            : Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                    ),
                    SizedBox(
                      height: 10,
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
                          var SPref = await SharedPreferences.getInstance();
                          String mmemnomic = bip39.generateMnemonic();
                          
                          var seed = bip39.mnemonicToSeed(mmemnomic);
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
                         
                          // move to the recoveryPhrase screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => RecoveryPhrase(
                                      data: mmemnomic, add: true)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'CREATE A WALLET',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => EnterPhrase(add: true)));
                      },
                      child: Container(
                        width: double.infinity,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'IMPORT SEED PHRASE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),                          
                  ],
                ),
              );
      })),
    );
  }
}
