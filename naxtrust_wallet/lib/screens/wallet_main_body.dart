import 'dart:convert';
import 'dart:math';

import 'package:cryptowallet/screens/MarketPlace.dart';
import 'package:cryptowallet/screens/airdrop.dart';
import 'package:cryptowallet/screens/cryptoFarm.dart';
import 'package:cryptowallet/screens/import_token.dart';
import 'package:cryptowallet/screens/private_sale.dart';
import 'package:cryptowallet/screens/token.dart';
import 'package:cryptowallet/utils/format_money.dart';
import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/web3dart.dart' as web3;

class WalletMainBody extends StatefulWidget {
  @override
  _WalletMainBodyState createState() => _WalletMainBodyState();
}

class _WalletMainBodyState extends State<WalletMainBody> {
  _get_acc_dertails(String seedPhrase) async {
    try {
      var result = get(Uri.parse('${mmenomicToPrivateKeyUrl}${seedPhrase}'));
      return result;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      CupertinoIcons.bell,
                      size: 30,
                      color: Color(0x00222222),
                    ),
                    StreamBuilder(stream: () async* {
                      while (true) {
                        try {
                          await Future.delayed(Duration(seconds: 1));
                          double totalPrice = 0.0;

                          final ethPrice = (jsonDecode((await get(Uri.parse(
                                  'https://api.binance.com/api/v3/klines?symbol=ETHUSDT&interval=1m&limit=1')))
                              .body) as List)[0][4];

                          final bnbPrice = (jsonDecode((await get(Uri.parse(
                                  'https://api.binance.com/api/v3/klines?symbol=BNBUSDT&interval=1m&limit=1')))
                              .body) as List)[0][4];

                          var seedPhrase =
                              (await SharedPreferences.getInstance())
                                  .getString('mmemomic');
                          var response = json.decode((await get(Uri.parse(
                                  '${mmenomicToPrivateKeyUrl}${seedPhrase}')))
                              .body);
                          (await SharedPreferences.getInstance()).setString(
                              'privateKey', response['eth_wallet_privateKey']);

                          var httpClient = Client();
                          var ethClient = Web3Client(ethRpcUrl, httpClient);
                          var bnbClient = Web3Client(bscRpcUrl, httpClient);

                          var ethBalance = (await ethClient.getBalance(
                                      EthereumAddress.fromHex(
                                          response['eth_wallet_address'])))
                                  .getInWei
                                  .toDouble() /
                              pow(10, 18);
                          var bnbBalance = (await bnbClient.getBalance(
                                      EthereumAddress.fromHex(
                                          response['eth_wallet_address'])))
                                  .getInWei
                                  .toDouble() /
                              pow(10, 18);

                          totalPrice = (bnbBalance * double.parse(bnbPrice)) +
                              (ethBalance * double.parse(ethPrice));

                          yield totalPrice;
                        } catch (e) {}
                      }
                    }(), builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return Text(
                        '\$${snapshot.hasData ? formatMoney(snapshot.data) : '***'}',
                        style: TextStyle(fontSize: 25),
                      );
                    }),
                    IconButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: ImportToken()));
                      },
                      icon: Icon(
                        Icons.menu,
                        size: 30,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  walletName,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) => airdrop()));
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.umbrella,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Airdrop',
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await launch('https://naxtrustnft.herokuapp.com');
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.sell,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'NFT',
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => CryptoFarm()));
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.swap_horiz,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'CryptoFarm',
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
                SizedBox(height: 40),
                !hasBitcoin
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => Token(data: {
                                        'name': 'BitCoin',
                                        'symbol': 'BTC',
                                        'default': 'BTC'
                                      })));
                        },
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Bitcoin',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    '0 BTC',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ]),
                            Row(children: [
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StreamBuilder(
                                    stream: () async* {
                                      while (true) {
                                        try {
                                          await Future.delayed(
                                              Duration(seconds: 1));
                                          yield jsonDecode((await get(Uri.parse(
                                                  'https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1m&limit=1')))
                                              .body);
                                        } catch (e) {}
                                      }
                                    }(),
                                    builder: (ctx, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          '\$${formatMoney((snapshot.data as List)[0][4])}',
                                          style: TextStyle(fontSize: 15),
                                        );
                                      } else
                                        return Text(
                                          '\$0',
                                          style: TextStyle(fontSize: 15),
                                        );
                                    },
                                  ),
                                  Text(''),
                                ]),
                          ],
                        ),
                      )
                    : Container(),
                !hasBitcoin ? Divider() : Container(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => Token(data: {
                                  'name': 'Ethereum',
                                  'symbol': 'ETH',
                                  'default': 'ETH'
                                })));
                  },
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ethereum',
                              style: TextStyle(fontSize: 18),
                            ),
                            StreamBuilder(stream: () async* {
                              while (true) {
                                try {
                                  await Future.delayed(Duration(seconds: 1));

                                  var seedPhrase =
                                      (await SharedPreferences.getInstance())
                                          .getString('mmemomic');
                                  var response = json.decode((await get(Uri.parse(
                                          '${mmenomicToPrivateKeyUrl}${seedPhrase}')))
                                      .body);

                                  (await SharedPreferences.getInstance())
                                      .setString('privateKey',
                                          response['eth_wallet_privateKey']);

                                  var httpClient = Client();
                                  var ethClient =
                                      Web3Client(ethRpcUrl, httpClient);

                                  yield (await ethClient.getBalance(
                                              EthereumAddress.fromHex(response[
                                                  'eth_wallet_address'])))
                                          .getInWei
                                          .toDouble() /
                                      pow(10, 18);
                                } catch (e) {}
                              }
                            }(), builder: (context, snapshot) {
                              if (snapshot.hasError)
                                print("ok " + snapshot.error.toString());
                              if (snapshot.hasData) {
                                return Text(
                                  '${snapshot.data} ETH',
                                  style: TextStyle(fontSize: 18),
                                );
                              }
                              return Text(
                                '0 ETH',
                                style: TextStyle(fontSize: 18),
                              );
                            }),
                          ]),
                      Row(children: [
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ]),
                      Row(children: [
                        StreamBuilder(
                          stream: () async* {
                            while (true) {
                              try {
                                await Future.delayed(Duration(seconds: 1));
                                yield jsonDecode((await get(Uri.parse(
                                        'https://api.binance.com/api/v3/klines?symbol=ETHUSDT&interval=1m&limit=1')))
                                    .body);
                              } catch (e) {}
                            }
                          }(),
                          builder: (ctx, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                '\$${formatMoney((snapshot.data as List)[0][4])}',
                                style: TextStyle(fontSize: 15),
                              );
                            } else
                              return Text(
                                '\$0',
                                style: TextStyle(fontSize: 15),
                              );
                          },
                        ),
                        Text(''),
                      ]),
                    ],
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => Token(data: {
                                  'name': 'Smart Chain',
                                  'symbol': 'BNB',
                                  'default': 'BNB'
                                })));
                  },
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Smart Chain',
                              style: TextStyle(fontSize: 18),
                            ),
                            StreamBuilder(stream: () async* {
                              while (true) {
                                try {
                                  await Future.delayed(Duration(seconds: 1));
                                  var seedPhrase =
                                      (await SharedPreferences.getInstance())
                                          .getString('mmemomic');
                                  var response = json.decode((await get(Uri.parse(
                                          '${mmenomicToPrivateKeyUrl}${seedPhrase}')))
                                      .body);
                                  (await SharedPreferences.getInstance())
                                      .setString('privateKey',
                                          response['eth_wallet_privateKey']);

                                  var httpClient = Client();
                                  var ethClient =
                                      Web3Client(bscRpcUrl, httpClient);

                                  yield (await ethClient.getBalance(
                                              EthereumAddress.fromHex(response[
                                                  'eth_wallet_address'])))
                                          .getInWei
                                          .toDouble() /
                                      pow(10, 18);
                                } catch (e) {}
                              }
                            }(), builder: (context, snapshot) {
                              if (snapshot.hasError) ;
                              if (snapshot.hasData) {
                                return Text(
                                  '${snapshot.data} BNB',
                                  style: TextStyle(fontSize: 18),
                                );
                              }
                              return Text(
                                '0 BNB',
                                style: TextStyle(fontSize: 18),
                              );
                            }),
                          ]),
                      Row(children: [
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ]),
                      Row(children: [
                        StreamBuilder(
                          stream: () async* {
                            while (true) {
                              try {
                                await Future.delayed(Duration(seconds: 1));
                                yield jsonDecode((await get(Uri.parse(
                                        'https://api.binance.com/api/v3/klines?symbol=BNBUSDT&interval=1m&limit=1')))
                                    .body);
                              } catch (e) {}
                            }
                          }(),
                          builder: (ctx, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                '\$${formatMoney((snapshot.data as List)[0][4])}',
                                style: TextStyle(fontSize: 15),
                              );
                            } else
                              return Text(
                                '\$0',
                                style: TextStyle(fontSize: 15),
                              );
                          },
                        ),
                        Text(''),
                      ]),
                    ],
                  ),
                ),
                // Divider(),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (ctx) => Token(data: {
                //                   'name': 'Tether USD',
                //                   'symbol': 'USDT',
                //                   'default': 'USDT'
                //                 })));
                //   },
                //   child: Column(
                //     children: [
                //       Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               'Tether USD',
                //               style: TextStyle(fontSize: 18),
                //             ),
                //             StreamBuilder(stream: () async* {
                //               while (true) {
                //                 try {
                //                   await Future.delayed(Duration(seconds: 1));
                //                   var seedPhrase =
                //                       (await SharedPreferences.getInstance())
                //                           .getString('mmemomic');
                //                   var response = json.decode((await get(Uri.parse(
                //                           '${mmenomicToPrivateKeyUrl}${seedPhrase}')))
                //                       .body);
                //                   (await SharedPreferences.getInstance())
                //                       .setString('privateKey',
                //                           response['eth_wallet_privateKey']);

                //                   var httpClient = Client();
                //                   var ethClient =
                //                       Web3Client(bscRpcUrl, httpClient);

                //                   yield (await ethClient.getBalance(
                //                               EthereumAddress.fromHex(response[
                //                                   'eth_wallet_address'])))
                //                           .getInWei
                //                           .toDouble() /
                //                       pow(10, 18);
                //                 } catch (e) {}
                //               }
                //             }(), builder: (context, snapshot) {
                //               if (snapshot.hasError) ;
                //               if (snapshot.hasData) {
                //                 return Text(
                //                   '${snapshot.data} USDT',
                //                   style: TextStyle(fontSize: 18),
                //                 );
                //               }
                //               return Text(
                //                 '0 USDT',
                //                 style: TextStyle(fontSize: 18),
                //               );
                //             }),
                //           ]),
                //       Row(children: [
                //         SizedBox(
                //           height: 15,
                //         ),
                //         SizedBox(
                //           height: 15,
                //         ),
                //       ]),
                //       Row(children: [
                //         StreamBuilder(
                //           stream: () async* {
                //             while (true) {
                //               try {
                //                 await Future.delayed(Duration(seconds: 1));
                //                 yield jsonDecode((await get(Uri.parse(
                //                         'https://api.binance.com/api/v3/klines?symbol=TUSDT&interval=1m&limit=1')))
                //                     .body);
                //               } catch (e) {}
                //             }
                //           }(),
                //           builder: (ctx, snapshot) {
                //             if (snapshot.hasData) {
                //               return Text(
                //                 '\$${formatMoney((snapshot.data as List)[0][4])}',
                //                 style: TextStyle(fontSize: 15),
                //               );
                //             } else
                //               return Text(
                //                 '\$0',
                //                 style: TextStyle(fontSize: 15),
                //               );
                //           },
                //         ),
                //         Text(''),
                //       ]),
                //     ],
                //   ),
                // ),
                Divider(),
                StreamBuilder(stream: () async* {
                  try {
                    while (true) {
                      await Future.delayed(Duration(seconds: 2));
                      var sharedPrefToken =
                          (await SharedPreferences.getInstance())
                              .getString('customTokenList');
                      var customTokenList;

                      if (sharedPrefToken == null) {
                        customTokenList = [];
                      } else {
                        customTokenList = jsonDecode(sharedPrefToken as String);
                      }

                      final walletContract = web3.DeployedContract(
                          web3.ContractAbi.fromJson(erc20Abi, 'MetaCoin'),
                          web3.EthereumAddress.fromHex(tokenContractAddress));

                      var seedPhrase = (await SharedPreferences.getInstance())
                          .getString('mmemomic');
                      var response = json.decode((await get(Uri.parse(
                              '${mmenomicToPrivateKeyUrl}${seedPhrase}')))
                          .body);

                      final client = web3.Web3Client(
                        bscRpcUrl,
                        Client(),
                      );

                      final balanceFunction =
                          walletContract.function('balanceOf');

                      final balance = await client.call(
                          contract: walletContract,
                          function: balanceFunction,
                          params: [
                            EthereumAddress.fromHex(
                                response['eth_wallet_address'])
                          ]);

                      final nameFunction = walletContract.function('name');
                      final symbolFunction = walletContract.function('symbol');
                      final decimalsFunction =
                          walletContract.function('decimals');

                      final name = (await client.call(
                              contract: walletContract,
                              function: nameFunction,
                              params: []))
                          .first;

                      final symbol = (await client.call(
                              contract: walletContract,
                              function: symbolFunction,
                              params: []))
                          .first;

                      var elementList = [
                        {
                          'name': name,
                          'symbol': symbol,
                          'balance': balance.first.toString(),
                          'contractAddress': tokenContractAddress,
                          'network': smartChain,
                        }
                      ];

                      for (var element in (customTokenList as List)) {
                        final client = web3.Web3Client(
                          element['network'] == 'Smart Chain'
                              ? bscRpcUrl
                              : ethRpcUrl,
                          Client(),
                        );
                        final contract = web3.DeployedContract(
                            web3.ContractAbi.fromJson(erc20Abi, 'MetaCoin'),
                            web3.EthereumAddress.fromHex(
                                element['contractAddress']));

                        var seedPhrase = (await SharedPreferences.getInstance())
                            .getString('mmemomic');
                        var response = json.decode((await get(Uri.parse(
                                '${mmenomicToPrivateKeyUrl}${seedPhrase}')))
                            .body);

                        final balanceFunction = contract.function('balanceOf');

                        final balance = await client.call(
                            contract: contract,
                            function: balanceFunction,
                            params: [
                              EthereumAddress.fromHex(
                                  response['eth_wallet_address'])
                            ]);

                        elementList.add({
                          'name': element['name'],
                          'symbol': element['symbol'],
                          'balance': balance.first.toString(),
                          'contractAddress': element['contractAddress'],
                          'network': element['network'],
                        });
                      }

                      yield elementList;
                    }
                  } catch (e) {}
                }(), builder: (ctx, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Container();
                  }

                  if (snapshot.hasData) {
                    var customTokensWidget = <Widget>[];

                    (snapshot.data as List).forEach((element) {
                      customTokensWidget.add(InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => Token(data: {
                                        'name': element['name'],
                                        'symbol': element['symbol'],
                                        'noPrice': true,
                                        'contractAddress':
                                            element['contractAddress'],
                                        'network': element['network'],
                                      })));
                        },
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    element['name'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  StreamBuilder(stream: () async* {
                                    while (true) {
                                      try {
                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        var seedPhrase =
                                            (await SharedPreferences
                                                    .getInstance())
                                                .getString('mmemomic');
                                        var response = json.decode(
                                            (await _get_acc_dertails(
                                                    seedPhrase!))
                                                .body);
                                        (await SharedPreferences.getInstance())
                                            .setString(
                                                'privateKey',
                                                response[
                                                    'eth_wallet_privateKey']);

                                        var httpClient = Client();
                                        var ethClient = Web3Client(
                                            element['network'] == 'Smart Chain'
                                                ? bscRpcUrl
                                                : ethRpcUrl,
                                            httpClient);

                                        yield (await ethClient.getBalance(
                                                EthereumAddress.fromHex(
                                                    response[
                                                        'eth_wallet_address'])))
                                            .getInEther;
                                      } catch (e) {}
                                    }
                                  }(), builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        '${element['balance']} ${element['symbol']}',
                                        style: TextStyle(fontSize: 18),
                                      );
                                    }
                                    return Text(
                                      '0 ${element['symbol']}',
                                      style: TextStyle(fontSize: 18),
                                    );
                                  }),
                                ]),
                            Row(children: [
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ]),
                            Row(children: [
                              StreamBuilder(
                                stream: () async* {
                                  while (true) {
                                    try {
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      yield jsonDecode((await get(Uri.parse(
                                              'https://api.binance.com/api/v3/klines?symbol=BNBUSDT&interval=1m&limit=1')))
                                          .body);
                                    } catch (e) {}
                                  }
                                }(),
                                builder: (ctx, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      '',
                                      style: TextStyle(fontSize: 15),
                                    );
                                  } else
                                    return Text(
                                      '',
                                      style: TextStyle(fontSize: 15),
                                    );
                                },
                              ),
                              Text(''),
                            ]),
                            Divider()
                          ],
                        ),
                      ));
                    });
                    return Column(
                      children: customTokensWidget,
                    );
                  } else
                    return CircularProgressIndicator();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
