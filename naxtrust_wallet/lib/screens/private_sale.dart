import 'dart:convert';

import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/colors.dart';
import '../config/styles.dart';
import '../utils/slideUpPanel.dart';

class private_sale extends StatefulWidget {
  @override
  _private_saleState createState() => _private_saleState();
}

class _private_saleState extends State<private_sale> {
  bool isLoading = false;
  var bnbAmountController = TextEditingController()..text = '1';
  var bnbPrice =
      'https://api.binance.com/api/v3/klines?symbol=BNBUSDT&interval=1m&limit=1';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: GestureDetector(
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 15,
                      ),
                      onTap: () {
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                    ),
                  ),
                  Text(
                    'Private Sale',
                    style: suBtitle2,
                    textAlign: TextAlign.center,
                  ),
                  Visibility(
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                    ),
                    visible: false,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text('0', style: s_normal),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text('70', style: s_normal),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        LinearPercentIndicator(
                          lineHeight: 20.0,
                          percent: 0.66,
                          linearStrokeCap: LinearStrokeCap.butt,
                          progressColor: black,
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text('Minimium Buy: ',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  Text(
                    '1 BNB',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text('Maximium Buy: ',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  Text(
                    '3 BNB',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
                  Text('The address to buy private sale: ',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  Text(
                    private_saleAddr,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
                  Text('Your ${walletAbbr}: ',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  Text(
                    '${convertionRate * (double.tryParse(bnbAmountController.text) ?? 0)}',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
                  Text('Note: ',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  Text(
                    'You can claim your private sale tokens after presale',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // var response = (await get(Uri.tryparse(''))).body;
                      var response = {
                        "transactionStatus": "success",
                        "hash": "0xBBB6A12945aC14C84185a17C6BD2eAe96e",
                        "walletAddress": "0x338389283abcd3839def"
                      };
                      slideUpPanel(context,
                          StatefulBuilder(builder: (ctx, setState) {
                        var private_saleBscScan =
                            'https://cryptooly.app.link/send/${response['hash']}/value=21jq';
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              response['transactionStatus'] == 'success'
                                  ? SvgPicture.asset(
                                      'assets/svgs/icon_wrapper.svg')
                                  : Image.asset(
                                      'assets/images/failedIcon.png',
                                      scale: 10,
                                    ),
                              Padding(
                                padding: EdgeInsets.all(30),
                                child: Text(
                                  response['transactionStatus'] == 'success'
                                      ? 'Presale Token Purchased Successfully'
                                      : 'Presale Token Purchase Failed',
                                  style: title1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Click the link below to view transaction on Bscsacan',
                                  style: s_agRegular_gray12,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: GestureDetector(
                                    child: isLoading
                                        ? CircularProgressIndicator(
                                            color: blue5,
                                          )
                                        : Text(
                                            private_saleBscScan,
                                            style:
                                                s_agRegularLinkBlue5Underline,
                                            textAlign: TextAlign.center,
                                          ),
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        await launch(private_saleBscScan);
                                      } catch (e) {}
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }),
                              ),
                            ],
                          ),
                        );
                      }));
                    },
                    child: Text('Claim', style: l_large_normal_primary5),
                    style: ElevatedButton.styleFrom(
                      primary: black,
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    ));
  }
}
