import 'package:cryptowallet/screens/enterInvestmentAmount.dart';
import 'package:flutter/material.dart';

class InvestBitcoin extends StatefulWidget {
  @override
  State<InvestBitcoin> createState() => _InvestBitcoinState();
}

class _InvestBitcoinState extends State<InvestBitcoin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text('BTC Basic'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Minimum Deposit: \$100'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Maximum Deposit: \$1000'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('20% per month'),
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
                                      builder: (ctx) => EnterInvestmentAmount(
                                          min: 100, max: 1000)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                'Invest Now',
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
                        Text('BTC Standard'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Minimum Deposit: \$1100'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Maximum Deposit: \$10000'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('40% per month'),
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
                                      builder: (ctx) => EnterInvestmentAmount(
                                          min: 1100, max: 10000)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                'Invest Now',
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
                        Text('BTC Mega'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Minimum Deposit: \$10000'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Maximum Deposit: Unlimited'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('60% per month'),
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
                                      builder: (ctx) => EnterInvestmentAmount(
                                          min: 10000, max: double.infinity)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                'Invest Now',
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
            ),
          ),
        ),
      ),
    );
  }
}
