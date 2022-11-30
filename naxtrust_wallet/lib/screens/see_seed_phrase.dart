import 'package:cryptowallet/screens/constants/data.dart';
import 'package:flutter/material.dart';

class SeeSeedPhrase extends StatelessWidget {
  final CreatedPhraseModel phrase;

  SeeSeedPhrase({super.key, required this.phrase});

  @override
  Widget build(BuildContext context) {
    List mmemonic = phrase.seedPhrase;
    var currentIndex = 0;
    var scaffoldKey = GlobalKey<ScaffoldState>();

    
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(children: [
                  Text(
                    'Your recovery phrase',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'This is your recovery phrase for your wallet: ${phrase.name}',
                    textAlign: TextAlign.center,
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
                            child: Text(mmemonic[currentIndex++]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(mmemonic[currentIndex++]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(mmemonic[currentIndex++]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(mmemonic[currentIndex++]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(mmemonic[currentIndex++]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(mmemonic[currentIndex++]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(mmemonic[currentIndex++]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(mmemonic[currentIndex++]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(mmemonic[currentIndex++]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(mmemonic[currentIndex++]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(mmemonic[currentIndex++]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(mmemonic[currentIndex++]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
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
                            'Do not share your secret phrase!',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'If someone has your secret phrase, they will have full control of your wallet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),  
                ]
              ),
            ),
          ),
      ),
    );
  }
}
