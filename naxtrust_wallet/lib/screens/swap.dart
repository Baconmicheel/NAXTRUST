import 'dart:convert';
import 'dart:math';

import 'package:cryptowallet/utils/format_money.dart';
import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:cryptowallet/screens/wallet.dart' as Wallet;
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

class Swap extends StatefulWidget {
  @override
  _SwapState createState() => _SwapState();
}

class _SwapState extends State<Swap> {
  var bnbController = TextEditingController();
  var finished = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Text(
                  'Swap',
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: bnbController,
                      decoration: InputDecoration(
                        hintText: 'BNB',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                      ),
                      onChanged: (value) async {
                        if (bnbController.text.trim() != "") {
                          setState(() {
                            finished = true;
                          });
                        } else {
                          setState(() {
                            finished = false;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Icon(Icons.arrow_downward, size: 30),
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(stream: () async* {
                      while (true) {
                        final client = web3.Web3Client(
                          'https://bsc-dataseed.binance.org/',
                          Client(),
                        );
                        final contract = web3.DeployedContract(
                            web3.ContractAbi.fromJson(erc20Abi, 'MetaCoin'),
                            web3.EthereumAddress.fromHex(tokenContractAddress));

                        final tokenPriceFunction =
                            contract.function('viewSale');

                        final tokenPrice = await client.call(
                            contract: contract,
                            function: tokenPriceFunction,
                            params: []);
                        yield pow(10, 18) /
                            double.parse(tokenPrice[3].toString());
                        await Future.delayed(Duration(minutes: 1));
                      }
                    }(), builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      if (snapshot.hasData) {
                        return Wrap(
                          children: [
                            Text(
                              bnbController.text.trim() != ""
                                  ? '${formatMoney((double.tryParse(bnbController.text.trim()) ?? 0) * snapshot.data!)}'
                                  : '0 ',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              ' ${walletAbbr}',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(" (" + tokenContractAddress + ")",
                                style: TextStyle(fontSize: 10)),
                          ],
                        );
                      } else
                        return Container();
                    }),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: Colors.blue,
                        ),
                        onPressed: finished
                            ? () async {
                                try {
                                  final client = web3.Web3Client(
                                    'https://bsc-dataseed.binance.org/',
                                    Client(),
                                  );
                                  var seedPhrase =
                                      (await SharedPreferences.getInstance())
                                          .getString('mmemomic');

                                  var response = json.decode((await get(Uri.parse(
                                          '$mmenomicToPrivateKeyUrl$seedPhrase')))
                                      .body);
                                  final credentials =
                                      await client.credentialsFromPrivateKey(
                                          response['eth_wallet_privateKey']);

                                  final contract = web3.DeployedContract(
                                      web3.ContractAbi.fromJson(
                                          erc20Abi, walletName),
                                      web3.EthereumAddress.fromHex(
                                          tokenContractAddress));

                                  final tokenSale = contract.function(
                                    'tokenSale',
                                  );
                                  final trans = await client.signTransaction(
                                      credentials,
                                      Transaction.callContract(
                                        contract: contract,
                                        function: tokenSale,
                                        parameters: [
                                          web3.EthereumAddress.fromHex(
                                              '0x0000000000000000000000000000000000000000'),
                                        ],
                                        value: web3.EtherAmount.inWei(
                                            BigInt.from((double.tryParse(
                                                        bnbController.text
                                                            .trim()) ??
                                                    0) *
                                                pow(10, 18))),
                                      ),
                                      chainId: 56);

                                  var transactionHash =
                                      (await client.sendRawTransaction(trans));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Swap Successful')));
                                } catch (e) {
                                  print(e);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Swap Failed')));
                                }
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'SWAP',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
