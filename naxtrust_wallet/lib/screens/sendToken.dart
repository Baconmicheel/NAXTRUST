import 'dart:convert';

import 'package:cryptowallet/screens/receiveToken.dart';
import 'package:cryptowallet/screens/sendToken.dart';
import 'package:cryptowallet/screens/transferToken.dart';
import 'package:cryptowallet/utils/format_money.dart';
import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:web3dart/web3dart.dart';

class SendToken extends StatefulWidget {
  var data;
  var seedPhrase;
  SendToken({this.data, this.seedPhrase});

  @override
  _SendTokenState createState() => _SendTokenState();
}

class _SendTokenState extends State<SendToken> {
  var recipientAddressController = TextEditingController();
  var amount = TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Form(
                  key: formState,
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
                        'Send ${widget.data['symbol']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      InkWell(
                        onTap: () async {
                          if (double.tryParse(amount.text.trim()) == null) {
                            return;
                          }

                          if (recipientAddressController.text.trim().isEmpty || recipientAddressController.text.trim() == "") {
                            return;
                          }                         

                          if (amount.text.trim() == "" || recipientAddressController.text.trim() == ""){
                            return;
                          }                            

                          var data = {
                            ...(widget.data as Map),
                            'amount': amount.text.trim(),
                            'recipient': recipientAddressController.text.trim()
                          };

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => TransferToken(
                                        data: data,
                                      )));
                        },
                        child: Text(
                          'CONTINUE',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  validator: (value) {
                    if (value?.trim() == '')
                      return 'Recipient address is required';
                    else
                      return null;
                  },
                  controller: recipientAddressController,
                  decoration: InputDecoration(
                    hintText: 'Recipient Address',
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value?.trim() == '')
                      return 'Amount is required';
                    else
                      return null;
                  },
                  controller: amount,
                  decoration: InputDecoration(
                    hintText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
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
