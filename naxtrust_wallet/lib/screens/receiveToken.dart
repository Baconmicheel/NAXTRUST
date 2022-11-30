import 'package:cryptowallet/screens/constants/locals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hash/hash.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:defichaindart/defichaindart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/web3dart.dart';
import 'package:bech32/bech32.dart';

class ReceiveToken extends StatefulWidget {
  var data;
  var seedPhrase;
  ReceiveToken({this.data, this.seedPhrase});

  @override
  _ReceiveTokenState createState() => _ReceiveTokenState();
}

class _ReceiveTokenState extends State<ReceiveToken> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: StreamBuilder(stream: () async* {
  
        while (true) {
          // Delay for 1 sec
          await Future.delayed(Duration(seconds: 1));

          // For BitCoin
          if (widget.data['default'] == 'BTC') {
            var bitCoinAddr = (await SharedPreferences.getInstance()).getString(userBitCoinAddress);
            if (bitCoinAddr != null) {
              yield {'address': bitCoinAddr};
              return;
            }
            
            var seedPhrase = (await SharedPreferences.getInstance()).getString('mmemomic');
            var seed = bip39.mnemonicToSeed(seedPhrase!);
            var hdWallet = HDWallet.fromSeed(seed);           
            // PERFORM A HASH: seed -> sha256 -> ripemd160
            var shapp256 = SHA256().update(seed).digest();
            var ripmd160 = RIPEMD160().update(shapp256).digest();

            print("RIPEMD160 digest as bytes: ${RIPEMD160().update(shapp256).digest()}"); // testing
            print("SHA256 digest as bytes: ${SHA256().update(seed).digest()}");  // testing
              
            // Generate a segwit bitcoin address
            var buildSegwitAddress = Segwit('bc', 1, ripmd160);
            var segwitBitcoinAddress = segwit.encode(buildSegwitAddress);

            print("HD WALLET ADDRESS ::: ${hdWallet.address}");
            
            // var address = getWalletAddress(45);
            // save address in locals
            (await SharedPreferences.getInstance()).setString('bitCoinAddr', segwitBitcoinAddress);
            (await SharedPreferences.getInstance()).setString(userBitCoinAddress, segwitBitcoinAddress);

            yield {'address': segwitBitcoinAddress};
            return;
          }
          // For Ethereum & Other Coins
          if (widget.data['default'] != null) {
            var ethAddress = (await SharedPreferences.getInstance()).getString(userEthereumAddress);
            if (ethAddress != null) {
              yield {'address': ethAddress};
              return;
            }

            var seedPhrase = (await SharedPreferences.getInstance()).getString('mmemomic');
            var seed = bip39.mnemonicToSeed(seedPhrase!);
            var hdWallet = HDWallet.fromSeed(seed);
            
            var privateKey = hdWallet.privKey;
            final credentials = EthPrivateKey.fromHex(privateKey!);
            final ethereumAddress = credentials.address;
            print("This is ethereum address =  $ethereumAddress");

            // save address in locals
            (await SharedPreferences.getInstance()).setString(userEthereumAddress, ethereumAddress.toString());

            yield {'address': ethereumAddress};
            return;
          }
          
          // var response = json.decode(
          //     (await get(Uri.parse('$mmenomicToPrivateKeyUrl$seedPhrase')))
          //         .body);
          // yield {'address': response['eth_wallet_address']};
          // yield {'address': staticAddress};
        }
      }(), builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (Navigator.canPop(context))
                                Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 30,
                            )),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Receive ${widget.data['symbol']}',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    QrImage(
                      backgroundColor: Colors.white,
                      // backgroundColor:
                      //     MediaQuery.of(context).platformBrightness ==
                      //             Brightness.dark
                      //         ? Colors.white
                      //         : Colors.black,
                      data: (snapshot.data as Map)['address'],
                      version: QrVersions.auto,
                      size: 250,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text((snapshot.data as Map)['address'],
                        textAlign: TextAlign.center),
                    SizedBox(
                      height: 40,
                    ),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(text: 'Send only '),
                          TextSpan(
                              text:
                                  '${widget.data['name']} (${widget.data['symbol']})',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  ' to this address. Sending any other coins may result in permanent loss.'),
                        ])),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: (snapshot.data as Map)['address']));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Copied')));
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.copy,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Copy',
                                  style: TextStyle(fontSize: 17),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Share.share(
                                  'My Public Address to Receive ${widget.data['symbol']} ${(snapshot.data as Map)['address']}');
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.share,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Share',
                                  style: TextStyle(fontSize: 17),
                                )
                              ],
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          );
        } else
          return Center(child: CircularProgressIndicator());
      }),
    );
  }
}






