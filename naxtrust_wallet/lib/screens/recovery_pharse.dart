import 'package:cryptowallet/screens/confirm_seed_phrase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecoveryPhrase extends StatefulWidget {
  String data;
  var verify;
  var add;
  RecoveryPhrase({required this.data, this.verify, this.add});

  @override
  _RecoveryPhraseState createState() => _RecoveryPhraseState();
}

class _RecoveryPhraseState extends State<RecoveryPhrase> {
  @override
  Widget build(BuildContext context) {
    List mmemonic = widget.data.split(' ');
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
                    'Write down or copy these words in the right order and save them somewhere safe',
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
                    height: 100,
                  ),
                  InkWell(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: widget.data));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied')));
                    },
                    child: Text('COPY'),
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
                  widget.verify != null
                      ? Container()
                      : Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => confirm_seed_phrase(
                                          mmenomic: widget.data.split(' '))));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                'CONTINUE',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                ]))),
      ),
    );
  }
}
