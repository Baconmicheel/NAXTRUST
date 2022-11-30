import 'dart:math';

import 'package:cryptowallet/screens/wallet.dart' as Wallet;
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:cryptowallet/screens/receiveToken.dart';
import 'package:cryptowallet/screens/sendToken.dart';
import 'package:cryptowallet/utils/format_money.dart';
import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:web3dart/web3dart.dart';

class TransferToken extends StatefulWidget {
  var data;
  TransferToken({this.data});

  @override
  _TransferTokenState createState() => _TransferTokenState();
}

class _TransferTokenState extends State<TransferToken> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: StreamBuilder(stream: () async* {
              while (true) {
                await Future.delayed(Duration(seconds: 1));
                if (widget.data['contractAddress'] != null) {
                  var seedPhrase = (await SharedPreferences.getInstance())
                      .getString('mmemomic');
                  var response = json.decode((await get(
                          Uri.parse('$mmenomicToPrivateKeyUrl$seedPhrase')))
                      .body);
                  final client = web3.Web3Client(
                    widget.data['network'] == ethereum ? ethRpcUrl : bscRpcUrl,
                    Client(),
                  );

                  final credentials = await client.credentialsFromPrivateKey(
                      response['eth_wallet_privateKey']);

                  final contract = web3.DeployedContract(
                      web3.ContractAbi.fromJson(erc20Abi, widget.data['name']),
                      web3.EthereumAddress.fromHex(
                          widget.data['contractAddress']));

                  final transfer = contract.function('transfer');
                  final gasPrice = await client.getGasPrice();
                  final gasUnit = await client.estimateGas(
                    gasPrice: gasPrice,
                    sender: web3.EthereumAddress.fromHex(
                        response['eth_wallet_address']),
                    to: web3.EthereumAddress.fromHex(
                        widget.data['contractAddress']),
                    data: transfer.encodeCall([
                      web3.EthereumAddress.fromHex(widget.data['recipient']),
                      BigInt.from(double.parse(widget.data['amount']))
                    ]),
                  );

                  final transactionFee =
                      gasPrice.getValueInUnit(web3.EtherUnit.wei) *
                          gasUnit.toDouble();
                  var userBalance = (await client.getBalance(
                              EthereumAddress.fromHex(
                                  response['eth_wallet_address'])))
                          .getInWei
                          .toDouble() /
                      pow(10, 18);
                  yield {
                    'transactionFee': (transactionFee / pow(10, 18)),
                    'userBalance': userBalance
                  };
                  return;
                } else if (widget.data['default'] != null &&
                        widget.data['default'] == 'BNB' ||
                    widget.data['default'] == 'ETH') {
                  var seedPhrase = (await SharedPreferences.getInstance())
                      .getString('mmemomic');
                  var response = json.decode((await get(
                          Uri.parse('$mmenomicToPrivateKeyUrl$seedPhrase')))
                      .body);
                  final client = web3.Web3Client(
                    widget.data['default'] == 'ETH' ? ethRpcUrl : bscRpcUrl,
                    Client(),
                  );
                  final credentials = await client.credentialsFromPrivateKey(
                      response['eth_wallet_privateKey']);

                  final gasPrice = await client.getGasPrice();
                  final gasUnit = await client.estimateGas(
                      gasPrice: gasPrice,
                      sender: web3.EthereumAddress.fromHex(
                          response['eth_wallet_address']),
                      to: web3.EthereumAddress.fromHex(
                          widget.data['recipient']),
                      value: web3.EtherAmount.inWei(
                          BigInt.from(double.parse(widget.data['amount']))));

                  final transactionFee =
                      gasPrice.getValueInUnit(web3.EtherUnit.wei) *
                          gasUnit.toDouble();

                  var userBalance = (await client.getBalance(
                              EthereumAddress.fromHex(
                                  response['eth_wallet_address'])))
                          .getInWei
                          .toDouble() /
                      pow(10, 18);

                  yield {
                    'transactionFee': (transactionFee / pow(10, 18)),
                    'userBalance': userBalance
                  };
                  return;
                }
                yield {'transactionFee': 0, 'userBalance': 0};
              }
            }(), builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                print('bad');
              }
              if (snapshot.hasData) print(snapshot.data);
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text(
                        'Transfer',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '-${widget.data['amount']} ${widget.data['symbol']}',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Asset',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${widget.data['name']} (${widget.data['symbol']})',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'From',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      StreamBuilder(stream: () async* {
                        while (true) {
                          await Future.delayed(Duration(seconds: 1));
                          var seedPhrase =
                              (await SharedPreferences.getInstance())
                                  .getString('mmemomic');
                          yield json.decode((await get(Uri.parse(
                                  '$mmenomicToPrivateKeyUrl$seedPhrase')))
                              .body);
                        }
                      }(), builder: (context, snapshot) {
                        return Flexible(
                          child: Text(
                            snapshot.hasData
                                ? (snapshot.data as Map)['eth_wallet_address']
                                : '0x...',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      })
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'To',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${widget.data['recipient']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Network Fee',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      widget.data['default'] != null
                          ? Flexible(
                              child: Text(
                                '${snapshot.hasData ? (snapshot.data as Map)['transactionFee'] : '0'}  ${widget.data['default'] == 'ETH' ? 'ETH' : 'BNB'}',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : Container(),
                      widget.data['network'] != null
                          ? Flexible(
                              child: Text(
                                '${snapshot.hasData ? (snapshot.data as Map)['transactionFee'] : '0'}  ${widget.data['network'] == ethereum ? 'ETH' : 'BNB'}',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : Container()
                    ],
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
                      onPressed: !snapshot.hasData ||
                              (snapshot.data as Map)['userBalance'] == null ||
                              (snapshot.data as Map)['userBalance'] <= 0
                          ? null
                          : () async {
                              print((snapshot.data as Map)['userBalance']);
                              if (widget.data['contractAddress'] != null) {
                                final client = web3.Web3Client(
                                  widget.data['network'] == ethereum
                                      ? ethRpcUrl
                                      : bscRpcUrl,
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
                                        erc20Abi, widget.data['name']),
                                    web3.EthereumAddress.fromHex(
                                        widget.data['contractAddress']));

                                final transfer = contract.function('transfer');
                                final trans = await client.signTransaction(
                                    credentials,
                                    Transaction.callContract(
                                      contract: contract,
                                      function: transfer,
                                      parameters: [
                                        web3.EthereumAddress.fromHex(
                                            widget.data['recipient']),
                                        BigInt.from(
                                            double.parse(widget.data['amount']))
                                      ],
                                    ),
                                    chainId: widget.data['network'] == ethereum
                                        ? ethChainId
                                        : bscChainId);

                                print(trans);

                                var transactionHash =
                                    (await client.sendRawTransaction(trans));
                                print(transactionHash);
                              } else if (widget.data['default'] != null &&
                                      widget.data['default'] == 'BNB' ||
                                  widget.data['default'] == 'ETH') {
                                final client = web3.Web3Client(
                                  widget.data['default'] == 'BNB'
                                      ? bscRpcUrl
                                      : ethRpcUrl,
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

                                final gasPrice = await client.getGasPrice();
                                final trans = await client.signTransaction(
                                    credentials,
                                    web3.Transaction(
                                      from: web3.EthereumAddress.fromHex(
                                          response['eth_wallet_address']),
                                      to: web3.EthereumAddress.fromHex(
                                          widget.data['recipient']),
                                      value: web3.EtherAmount.inWei(BigInt.from(
                                          double.parse(widget.data['amount']) *
                                              pow(10, 18))),
                                      gasPrice: gasPrice,
                                    ),
                                    chainId: widget.data['default'] == 'BNB'
                                        ? bscChainId
                                        : ethChainId);

                                var transactionHash =
                                    (await client.sendRawTransaction(trans));
                                print(transactionHash);
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => Wallet.WalletScreen()));
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          !snapshot.hasData ||
                                  (snapshot.data as Map)['userBalance'] ==
                                      null ||
                                  (snapshot.data as Map)['userBalance'] <= 0
                              ? 'Insufficient Funds'
                              : 'Send',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
