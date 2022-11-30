import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:cryptowallet/screens/constants/locals.dart';
import 'package:cryptowallet/screens/constants/otp.dart';
import 'package:cryptowallet/screens/receiveToken.dart';
import 'package:cryptowallet/screens/sendToken.dart';
import 'package:cryptowallet/utils/format_money.dart';
import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:web3dart/web3dart.dart' as web3;
import 'package:web3dart/web3dart.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:defichaindart/defichaindart.dart';
import 'package:bip39/bip39.dart' as bip39;

class Token extends StatefulWidget {
  var data;
  Token({this.data});

  @override
  _TokenState createState() => _TokenState();
}

class _TokenState extends State<Token> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  var gestureRecognizers = [Factory(() => EagerGestureRecognizer())].toSet();

  var sendVerifyController = TextEditingController();

  UniqueKey _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                        )),
                    Text(
                      widget.data['name'],
                      style: TextStyle(fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await launch(buyCryptoLink);
                      },
                      child: Text(
                        'BUY',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Coin',
                      style: TextStyle(fontSize: 18),
                    ),
                    widget.data['noPrice'] != null
                        ? Text(
                            '\$0',
                            style: TextStyle(fontSize: 18),
                          )
                        : StreamBuilder(
                            stream: () async* {
                              while (true) {
                                await Future.delayed(Duration(seconds: 1));
                                yield jsonDecode((await get(Uri.parse(
                                        'https://api.binance.com/api/v3/klines?symbol=${widget.data['symbol']}USDT&interval=1m&limit=1')))
                                    .body);
                              }
                            }(),
                            builder: (ctx, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  '\$${formatMoney((snapshot.data as List)[0][4])}',
                                  style: TextStyle(fontSize: 18),
                                );
                              } else
                                return Text(
                                  '\$0',
                                  style: TextStyle(fontSize: 18),
                                );
                            },
                          )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                StreamBuilder(stream: () async* {
                  while (true) {
                    await Future.delayed(Duration(seconds: 1));
                    if (widget.data['contractAddress'] != null) {
                      final client = web3.Web3Client(
                        bscRpcUrl,
                        Client(),
                      );
                      final contract = web3.DeployedContract(
                          web3.ContractAbi.fromJson(erc20Abi, 'MetaCoin'),
                          web3.EthereumAddress.fromHex(
                              widget.data['contractAddress']));

                      var seedPhrase = (await SharedPreferences.getInstance())
                          .getString('mmemomic');
                      var response = json.decode((await get(
                              Uri.parse('$mmenomicToPrivateKeyUrl$seedPhrase')))
                          .body);

                      final balanceFunction = contract.function('balanceOf');

                      final balance = await client.call(
                          contract: contract,
                          function: balanceFunction,
                          params: [
                            EthereumAddress.fromHex(
                                response['eth_wallet_address'])
                          ]);

                      yield balance.first.toString();
                      return;
                    } else if (widget.data['default'] != null &&
                            widget.data['default'] == 'BNB' ||
                        widget.data['default'] == 'ETH') {
                      await Future.delayed(Duration(seconds: 1));
                      var seedPhrase = (await SharedPreferences.getInstance())
                          .getString('mmemomic');
                      var response = json.decode((await get(
                              Uri.parse('$mmenomicToPrivateKeyUrl$seedPhrase')))
                          .body);
                      (await SharedPreferences.getInstance()).setString(
                          'privateKey', response['eth_wallet_privateKey']);

                      var httpClient = Client();
                      var ethClient = Web3Client(bscRpcUrl, httpClient);

                      yield (await ethClient.getBalance(EthereumAddress.fromHex(
                                  response['eth_wallet_address'])))
                              .getInWei
                              .toDouble() /
                          pow(10, 18);

                      return;
                    } else if (widget.data['default'] != null &&
                        widget.data['default'] == 'BTC') {
                      await Future.delayed(Duration(seconds: 1));
                      var seedPhrase = (await SharedPreferences.getInstance())
                          .getString('mmemomic');
                      var response = json.decode((await get(
                              Uri.parse('$mmenomicToPrivateKeyUrl$seedPhrase')))
                          .body);
                      (await SharedPreferences.getInstance()).setString(
                          'privateKey', response['eth_wallet_privateKey']);

                      var httpClient = Client();
                      var ethClient = Web3Client(ethRpcUrl, httpClient);

                      yield (await ethClient.getBalance(EthereumAddress.fromHex(
                                  response['eth_wallet_address'])))
                              .getInWei
                              .toDouble() /
                          pow(10, 18);

                      return;
                    }
                    yield 0;
                  }
                }(), builder: (context, snapshot) {
                  return Text(
                    '${snapshot.hasData ? snapshot.data : '0'} ${widget.data['symbol']}',
                    style: TextStyle(fontSize: 20),
                  );
                }),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            var instance = await SharedPreferences.getInstance();
                            String? currentUserEmail = instance.getString(emailLocals);
                            int generatedCode = OTP.generateOTPcode();
                            String message = "You just requested to perform a transaction. Verify yourself to continue";
                            if(currentUserEmail != null){  
                              // calling send email function
                              await OTP.sendOTPMail(generatedCode, currentUserEmail, context, message);                  
                              // Dialog for input of otpCode
                              showDialog(context: context, barrierDismissible: false, builder: (context) => AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Verification Code"),
                                    SizedBox(height: 30),
                                    Container(
                                      height: 40,
                                      child: TextFormField(                                      
                                        controller: sendVerifyController,
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
                                      if(int.parse(sendVerifyController.text.trim()) == generatedCode){                                                
                                        Navigator.pop(context);                                                     
                                        // proceed to perform send transaction                                        
                                        var seedPhrase = (await SharedPreferences.getInstance()).getString('mmemonic');
                                      Navigator.push(  
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => SendToken(
                                            data: widget.data,
                                            seedPhrase: seedPhrase,
                                          ),
                                        ));
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
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.upload,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Send',
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            var SPref = await SharedPreferences.getInstance();
                            var seedPhrase = SPref.getString('mmemomic');
                            print("Seed Phrase ::::::::: $seedPhrase");// testing
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => ReceiveToken(
                                  data: widget.data,
                                  // seedPhrase: seedPhrase,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.download,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Receive',
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        ),
                        // Column(
                        //   children: [
                        //     Container(
                        //       decoration: BoxDecoration(
                        //           color: Colors.blue, shape: BoxShape.circle),
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Icon(
                        //           Icons.swap_horiz,
                        //           size: 20,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 10,
                        //     ),
                        //     Text(
                        //       'Swap',
                        //       style: TextStyle(fontSize: 15),
                        //     )
                        //   ],
                        // ),
                      ]),
                ),
                StreamBuilder(stream: () async* {
                  await Future.delayed(Duration(seconds: 1));
                  var seedPhrase = (await SharedPreferences.getInstance())
                      .getString('mmemomic');
                  var response = json.decode((await get(
                          Uri.parse('$mmenomicToPrivateKeyUrl$seedPhrase')))
                      .body);

                  if (widget.data['default'] != null) {
                    switch (widget.data['default']) {
                      case 'ETH':
                        yield '$etherScanUrl${response['eth_wallet_address']}#transactions';
                        break;
                      case 'BNB':
                        yield '$bnbScanUrl${response['eth_wallet_address']}#transactions';
                        break;
                      case 'BTC':
                        var seedPhrase = (await SharedPreferences.getInstance())
                            .getString('mmemomic');
                        var seed = bip39.mnemonicToSeed(seedPhrase!);

                        var hdWallet = HDWallet.fromSeed(seed);
                            // HDWallet(seed: (mnemonicToSeed(seedPhrase!) as String));
                        yield '$bitCoinScanUrl${hdWallet.address}#transactions';
                        break;
                    }
                    return;
                  } else if (widget.data['contractAddress'] != null) {
                    yield "${cryptoNetworksExplorerDomain[widget.data['network']]}/token/${widget.data['contractAddress']}?a=${response['eth_wallet_address']}#transactions";
                  }
                }(), builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: double.infinity,
                      height: 500,
                      child: WebView(
                          javascriptMode: JavascriptMode.unrestricted,
                          gestureRecognizers: gestureRecognizers,
                          initialUrl: snapshot.data as String),
                    );
                  } else {
                    return Container();
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
