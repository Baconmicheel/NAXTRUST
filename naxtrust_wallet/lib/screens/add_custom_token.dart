import 'dart:convert';

import 'package:cryptowallet/screens/add_custom_token.dart';
import 'package:cryptowallet/screens/wallet.dart';
import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart' as web3;

class AddCustomToken extends StatefulWidget {
  @override
  _AddCustomTokenState createState() => _AddCustomTokenState();
}

class _AddCustomTokenState extends State<AddCustomToken> {
  var networks = cryptoNetworks;
  var network;
  @override
  void initState() {
    super.initState();
    network = networks[0];
  }

  var contractAddressController = TextEditingController();
  var nameAddressController = TextEditingController();
  var symbolAddressController = TextEditingController();
  final GlobalKey<FormState> customTokenState = GlobalKey<FormState>();
  var decimalsAddressController = TextEditingController();
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
                Form(
                  key: customTokenState,
                  child: Row(
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
                        'Add Custom Token',
                        style: TextStyle(fontSize: 18),
                      ),
                      InkWell(
                        onTap: () async {
                          if (contractAddressController.text.trim() != "" &&
                              nameAddressController.text.trim() != "" &&
                              symbolAddressController.text.trim() != "" &&
                              decimalsAddressController.text.trim() != "") {
                            var customTokenList =
                                (await SharedPreferences.getInstance())
                                    .getString('customTokenList');
                            if (customTokenList == null) {
                              (await SharedPreferences.getInstance()).setString(
                                  'customTokenList',
                                  jsonEncode([
                                    {
                                      'contractAddress':
                                          contractAddressController.text.trim(),
                                      'name': nameAddressController.text.trim(),
                                      'symbol':
                                          symbolAddressController.text.trim(),
                                      'decimals':
                                          decimalsAddressController.text.trim(),
                                      'network': network
                                    }
                                  ]));
                            } else {
                              var customTokenDecoded =
                                  (jsonDecode(customTokenList) as List);
                              for (int i = 0;
                                  i < customTokenDecoded.length;
                                  i++) {
                                if (customTokenDecoded[i]['contractAddress'] ==
                                        contractAddressController.text.trim() &&
                                    customTokenDecoded[i]['network'] ==
                                        network) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Token Imported Already')));
                                  return;
                                }
                              }
                              (await SharedPreferences.getInstance()).setString(
                                  'customTokenList',
                                  jsonEncode((jsonDecode(customTokenList)
                                      as List)
                                    ..add({
                                      'contractAddress':
                                          contractAddressController.text.trim(),
                                      'name': nameAddressController.text.trim(),
                                      'symbol':
                                          symbolAddressController.text.trim(),
                                      'decimals':
                                          decimalsAddressController.text.trim(),
                                      'network': network
                                    })));
                            }

                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) => WalletScreen()));
                          }
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Network'),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: network,
                        items: networks.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            network = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  validator: (value) {
                    if (value?.trim() == "") return 'Required';
                    // return null;
                  },
                  controller: contractAddressController,
                  decoration: InputDecoration(
                    hintText: 'Contract Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                  ),
                  onChanged: (value) async {
                    final client = web3.Web3Client(
                      network == smartChain ? bscRpcUrl : ethRpcUrl,
                      Client(),
                    );
                    final contract = web3.DeployedContract(
                        web3.ContractAbi.fromJson(erc20Abi, 'MetaCoin'),
                        web3.EthereumAddress.fromHex(value.trim()));

                    final nameFunction = contract.function('name');
                    final symbolFunction = contract.function('symbol');
                    final decimalsFunction = contract.function('decimals');

                    final name = await client.call(
                        contract: contract, function: nameFunction, params: []);

                    nameAddressController.text = name.first;
                    final symbol = await client.call(
                        contract: contract,
                        function: symbolFunction,
                        params: []);
                    symbolAddressController.text = symbol.first;
                    final decimals = await client.call(
                        contract: contract,
                        function: decimalsFunction,
                        params: []);
                    decimalsAddressController.text = decimals.first.toString();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value?.trim() == "") return 'Required';
                    return null;
                  },
                  controller: nameAddressController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value?.trim() == "") return 'Required';
                    return null;
                  },
                  controller: symbolAddressController,
                  decoration: InputDecoration(
                    hintText: 'Symbol',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value?.trim() == "")
                      return 'Required';
                    else
                      return null;
                  },
                  controller: decimalsAddressController,
                  decoration: InputDecoration(
                    hintText: 'Decimals',
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.red[100]),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Anyone can create a token ',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            'Including a fake version of an existing token. Learn about scams and security risks',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                            )),
                      ],
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
