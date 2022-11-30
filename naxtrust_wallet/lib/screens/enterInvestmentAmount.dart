import 'dart:convert';

import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EnterInvestmentAmount extends StatefulWidget {
  var min;
  var max;
  EnterInvestmentAmount({this.min, this.max});
  @override
  State<EnterInvestmentAmount> createState() => _EnterInvestmentAmountState();
}

class _EnterInvestmentAmountState extends State<EnterInvestmentAmount> {
  var amountController = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: amountController,
                  decoration: InputDecoration(
                    hintText: 'Amount (\$${widget.min} - \$${widget.max})',
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
                      if (double.parse(amountController.text.trim()) <
                              widget.min ||
                          double.parse(amountController.text.trim()) >
                              widget.max) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'The minimum is ${widget.min} and maximum is ${widget.max}')));
                      } else {
                        var instancePref =
                            await SharedPreferences.getInstance();
                        var userId = await instancePref.getString('userId');

                        Widget cryptoButton = TextButton(
                          child: Text("Crypto"),
                          onPressed: () async {
                            var instancePref =
                                await SharedPreferences.getInstance();
                            var response = jsonDecode((await post(
                                    Uri.parse(
                                        'https://api.commerce.coinbase.com/charges/'),
                                    headers: {
                                      'Content-Type': 'application/json',
                                      'X-CC-Api-Key': coinbaseApiKey,
                                      'X-CC-Version': '2018-03-22',
                                    },
                                    body: jsonEncode({
                                      'name': 'Deposit',
                                      'description':
                                          'Investing ${amountController.text.trim()}',
                                      'local_price': {
                                        'amount': amountController.text.trim(),
                                        'currency': 'USD'
                                      },
                                      "metadata": {
                                        'userId': userId,
                                        'phone': '',
                                        'methodOfPayment':
                                            'Investing ${amountController.text.trim()} for crypto farm',
                                        'sellingMethod': 'investing',
                                        'currencyExchange': 'usd',
                                        'currency': 'usd',
                                        'dollarRate': 1
                                      },
                                      'pricing_type': 'fixed_price'
                                    })))
                                .body)['data'];

                            Navigator.pop(context);

                            setState(() {
                              instancePref.remove('bet');
                            });

                            await launch(response['data']['hosted_url']);
                          },
                        );
                        Widget fiatButton = TextButton(
                          child: Text("Fiat"),
                          onPressed: () async {
                            var instancePref =
                                await SharedPreferences.getInstance();
                            var response = jsonDecode((await post(
                                    Uri.parse(
                                        'https://naxtrust.com/ntc/trading/saveToDb'),
                                    body: jsonEncode({
                                      'amount': amountController.text.trim(),
                                      'description':
                                          'Investing ${amountController.text.trim()} for crypto farm',
                                      'userId': userId,
                                      'phone': '',
                                      'methodOfPayment':
                                          'Investing ${amountController.text.trim()} for crypto farm',
                                      'sellingMethod': 'nottrade',
                                      'currencyExchange': 'usd',
                                      'currency': 'usd',
                                      'dollarRate': 1
                                    })))
                                .body);

                            if (response['success']) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Bet Successfull')));
                              setState(() {
                                instancePref.remove('bet');
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Bet Failed, ${response['error']}')));
                            }
                            Navigator.pop(context);
                          },
                        );

                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text("Choose Method"),
                          content: Text("Crypto or Fiat"),
                          actions: [
                            cryptoButton,
                            fiatButton,
                          ],
                        );

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        'Invest',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
