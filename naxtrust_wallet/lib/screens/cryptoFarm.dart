import 'package:cryptowallet/screens/enterInvestmentAmount.dart';
import 'package:cryptowallet/screens/investAitCoins.dart';
import 'package:cryptowallet/screens/investBitCoin.dart';
import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CryptoFarm extends StatefulWidget {
  @override
  State<CryptoFarm> createState() => _CryptoFarmState();
}

class _CryptoFarmState extends State<CryptoFarm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('BTC Cloud Mining'),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => InvestBitcoin()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'Start',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('AltCoins'),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => investAltCoins()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'Start',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('Mining Pool'),
                      SizedBox(
                        height: 10,
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
                            await launch(
                                'mailto:${email}?subject=Contact for Crypto Mining pool&body=I want to get the app/software for mining pool, likewise the hash rate, algorithm, ASIC mining and guideline for mining Bitcoin and aitcoins.');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'Contact Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
