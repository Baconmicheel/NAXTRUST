import 'package:cryptowallet/config/styles.dart';
import 'package:flutter/material.dart';

class MarketPlace extends StatefulWidget {
  @override
  _MarketPlaceState createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
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
                      'NFTs',
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
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Image.asset(
                              'assets/market_place/bored_ape_2.png',
                              width: double.infinity,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Top Bid',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('100 ETH')
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text('Buy'),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Image.asset(
                              'assets/market_place/bored_ape_1.png',
                              width: double.infinity,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Top Bid',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('1000 ETH')
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text('Buy'),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
