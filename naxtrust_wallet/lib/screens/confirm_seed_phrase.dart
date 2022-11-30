// ignore_for_file: prefer__ructors, prefer_const_constructors

import 'dart:convert';

import 'package:cryptowallet/screens/constants/data.dart';
import 'package:cryptowallet/screens/constants/locals.dart';
import 'package:cryptowallet/screens/wallet.dart';
import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/colors.dart';
import '../config/styles.dart';

class confirm_seed_phrase extends StatefulWidget {
  List mmenomic;
  confirm_seed_phrase({
    required this.mmenomic,
  });
  @override
  _confirm_seed_phraseState createState() => _confirm_seed_phraseState();
}

class _confirm_seed_phraseState extends State<confirm_seed_phrase> {
  bool signInWithFaceId = true;
  bool checkBoxTicked = true;
  bool hidePassword = true;
  bool nextPage = false;
  bool showSeedPhrase = false;
  bool finished = false;
  bool firstStep = true;
  bool secondStep = false;
  bool thirdStep = false;
  bool fourthStep = false;
  List numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  int currentCorrectItem = 0;
  bool firstTime = true;
  List mmenomicArray = [];
  List mmenomicShuffled = [];
  bool isLoading = false;
  List boxIndexGotten = [];

  var walletNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      mmenomicArray = widget.mmenomic;
      mmenomicShuffled = [...mmenomicArray]..shuffle();
      firstTime = false;
      print(mmenomicArray);
    }
    List firstThree = [];
    if (firstStep) {
      firstThree = [numbers[0], numbers[1], numbers[2]];
    } else if (secondStep) {
      firstThree = [numbers[3], numbers[4], numbers[5]];
    } else if (thirdStep) {
      firstThree = [numbers[6], numbers[7], numbers[8]];
    } else if (fourthStep) {
      firstThree = [numbers[9], numbers[10], numbers[11]];
    }

    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Write Down Your Seed Phrase",
                    style: title1,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                              'Select each word in the order it was presented to you'),
                          Row(
                            children: [
                              Expanded(
                                child: Card(
                                  color:
                                      currentCorrectItem >= 1 ? green1 : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      currentCorrectItem >= 1
                                          ? mmenomicArray[firstThree[0] - 1]
                                          : firstThree[0].toString(),
                                      style: TextStyle(
                                          color: currentCorrectItem >= 1
                                              ? green5
                                              : null),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  color:
                                      currentCorrectItem == 2 ? green1 : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      currentCorrectItem == 2
                                          ? mmenomicArray[firstThree[1] - 1]
                                              .toString()
                                          : firstThree[1].toString(),
                                      style: TextStyle(
                                          color: currentCorrectItem == 2
                                              ? green5
                                              : null),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(firstThree[2].toString()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: boxIndexGotten.contains(0)
                                  ? null
                                  : () {
                                      if (mmenomicShuffled[0].toString() ==
                                          mmenomicArray[firstThree[
                                                      currentCorrectItem] -
                                                  1]
                                              .toString()) {
                                        setState(() {
                                          boxIndexGotten.add(0);
                                          if (currentCorrectItem == 2) {
                                            if (firstStep == true) {
                                              firstStep = false;
                                              secondStep = true;
                                            } else if (firstStep == false &&
                                                secondStep == true) {
                                              secondStep = false;
                                              thirdStep = true;
                                            } else if (secondStep == false &&
                                                thirdStep == true) {
                                              thirdStep = false;
                                              fourthStep = true;
                                            } else if (thirdStep == false &&
                                                fourthStep == true) {
                                              finished = true;
                                            }
                                            currentCorrectItem = 0;
                                          } else {
                                            currentCorrectItem++;
                                          }
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Incorrect seed pharse order'),
                                          ),
                                        );
                                      }
                                    },
                              child: Card(
                                color:
                                    boxIndexGotten.contains(0) ? grey1 : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    '${mmenomicShuffled[0].toString()}',
                                    style: TextStyle(
                                        color: boxIndexGotten.contains(0)
                                            ? grey3
                                            : null),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: boxIndexGotten.contains(1)
                                  ? null
                                  : () {
                                      if (mmenomicShuffled[1].toString() ==
                                          mmenomicArray[firstThree[
                                                      currentCorrectItem] -
                                                  1]
                                              .toString()) {
                                        setState(() {
                                          boxIndexGotten.add(1);
                                          if (currentCorrectItem == 2) {
                                            if (firstStep == true) {
                                              firstStep = false;
                                              secondStep = true;
                                            } else if (firstStep == false &&
                                                secondStep == true) {
                                              secondStep = false;
                                              thirdStep = true;
                                            } else if (secondStep == false &&
                                                thirdStep == true) {
                                              thirdStep = false;
                                              fourthStep = true;
                                            } else if (thirdStep == false &&
                                                fourthStep == true) {
                                              finished = true;
                                            }
                                            currentCorrectItem = 0;
                                          } else {
                                            currentCorrectItem++;
                                          }
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Incorrect seed pharse order'),
                                          ),
                                        );
                                      }
                                    },
                              child: Card(
                                color:
                                    boxIndexGotten.contains(1) ? grey1 : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                      '${mmenomicShuffled[1].toString()}',
                                      style: TextStyle(
                                          color: boxIndexGotten.contains(1)
                                              ? grey3
                                              : null)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: boxIndexGotten.contains(2)
                                  ? null
                                  : () {
                                      if (mmenomicShuffled[2].toString() ==
                                          mmenomicArray[firstThree[
                                                      currentCorrectItem] -
                                                  1]
                                              .toString()) {
                                        setState(() {
                                          boxIndexGotten.add(2);
                                          if (currentCorrectItem == 2) {
                                            if (firstStep == true) {
                                              firstStep = false;
                                              secondStep = true;
                                            } else if (firstStep == false &&
                                                secondStep == true) {
                                              secondStep = false;
                                              thirdStep = true;
                                            } else if (secondStep == false &&
                                                thirdStep == true) {
                                              thirdStep = false;
                                              fourthStep = true;
                                            } else if (thirdStep == false &&
                                                fourthStep == true) {
                                              finished = true;
                                            }
                                            currentCorrectItem = 0;
                                          } else {
                                            currentCorrectItem++;
                                          }
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Incorrect seed pharse order'),
                                          ),
                                        );
                                      }
                                    },
                              child: Card(
                                color:
                                    boxIndexGotten.contains(2) ? grey1 : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                      '${mmenomicShuffled[2].toString()}',
                                      style: TextStyle(
                                          color: boxIndexGotten.contains(2)
                                              ? grey3
                                              : null)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: boxIndexGotten.contains(3)
                                  ? null
                                  : () {
                                      if (mmenomicShuffled[3].toString() ==
                                          mmenomicArray[firstThree[
                                                      currentCorrectItem] -
                                                  1]
                                              .toString()) {
                                        setState(() {
                                          boxIndexGotten.add(3);
                                          if (currentCorrectItem == 2) {
                                            if (firstStep == true) {
                                              firstStep = false;
                                              secondStep = true;
                                            } else if (firstStep == false &&
                                                secondStep == true) {
                                              secondStep = false;
                                              thirdStep = true;
                                            } else if (secondStep == false &&
                                                thirdStep == true) {
                                              thirdStep = false;
                                              fourthStep = true;
                                            } else if (thirdStep == false &&
                                                fourthStep == true) {
                                              finished = true;
                                            }
                                            currentCorrectItem = 0;
                                          } else {
                                            currentCorrectItem++;
                                          }
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Incorrect seed pharse order'),
                                          ),
                                        );
                                      }
                                    },
                              child: Card(
                                color:
                                    boxIndexGotten.contains(3) ? grey1 : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    '${mmenomicShuffled[3].toString()}',
                                    style: TextStyle(
                                        color: boxIndexGotten.contains(3)
                                            ? grey3
                                            : null),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: boxIndexGotten.contains(4)
                                  ? null
                                  : () {
                                      if (mmenomicShuffled[4].toString() ==
                                          mmenomicArray[firstThree[
                                                      currentCorrectItem] -
                                                  1]
                                              .toString()) {
                                        setState(() {
                                          boxIndexGotten.add(4);
                                          if (currentCorrectItem == 2) {
                                            if (firstStep == true) {
                                              firstStep = false;
                                              secondStep = true;
                                            } else if (firstStep == false &&
                                                secondStep == true) {
                                              secondStep = false;
                                              thirdStep = true;
                                            } else if (secondStep == false &&
                                                thirdStep == true) {
                                              thirdStep = false;
                                              fourthStep = true;
                                            } else if (thirdStep == false &&
                                                fourthStep == true) {
                                              finished = true;
                                            }
                                            currentCorrectItem = 0;
                                          } else {
                                            currentCorrectItem++;
                                          }
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Incorrect seed pharse order'),
                                          ),
                                        );
                                      }
                                    },
                              child: Card(
                                color:
                                    boxIndexGotten.contains(4) ? grey1 : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    '${mmenomicShuffled[4].toString()}',
                                    style: TextStyle(
                                        color: boxIndexGotten.contains(4)
                                            ? grey3
                                            : null),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: boxIndexGotten.contains(5)
                                  ? null
                                  : () {
                                      if (mmenomicShuffled[5].toString() ==
                                          mmenomicArray[firstThree[
                                                      currentCorrectItem] -
                                                  1]
                                              .toString()) {
                                        setState(() {
                                          boxIndexGotten.add(5);
                                          if (currentCorrectItem == 2) {
                                            if (firstStep == true) {
                                              firstStep = false;
                                              secondStep = true;
                                            } else if (firstStep == false &&
                                                secondStep == true) {
                                              secondStep = false;
                                              thirdStep = true;
                                            } else if (secondStep == false &&
                                                thirdStep == true) {
                                              thirdStep = false;
                                              fourthStep = true;
                                            } else if (thirdStep == false &&
                                                fourthStep == true) {
                                              finished = true;
                                            }
                                            currentCorrectItem = 0;
                                          } else {
                                            currentCorrectItem++;
                                          }
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Incorrect seed pharse order'),
                                          ),
                                        );
                                      }
                                    },
                              child: Card(
                                color:
                                    boxIndexGotten.contains(5) ? grey1 : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    '${mmenomicShuffled[5].toString()}',
                                    style: TextStyle(
                                        color: boxIndexGotten.contains(5)
                                            ? grey3
                                            : null),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: boxIndexGotten.contains(6)
                                  ? null
                                  : () {
                                      if (mmenomicShuffled[6].toString() ==
                                          mmenomicArray[firstThree[
                                                      currentCorrectItem] -
                                                  1]
                                              .toString()) {
                                        setState(() {
                                          boxIndexGotten.add(6);
                                          if (currentCorrectItem == 2) {
                                            if (firstStep == true) {
                                              firstStep = false;
                                              secondStep = true;
                                            } else if (firstStep == false &&
                                                secondStep == true) {
                                              secondStep = false;
                                              thirdStep = true;
                                            } else if (secondStep == false &&
                                                thirdStep == true) {
                                              thirdStep = false;
                                              fourthStep = true;
                                            } else if (thirdStep == false &&
                                                fourthStep == true) {
                                              finished = true;
                                            }
                                            currentCorrectItem = 0;
                                          } else {
                                            currentCorrectItem++;
                                          }
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Incorrect seed pharse order'),
                                          ),
                                        );
                                      }
                                    },
                              child: Card(
                                color:
                                    boxIndexGotten.contains(6) ? grey1 : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                      '${mmenomicShuffled[6].toString()}',
                                      style: TextStyle(
                                          color: boxIndexGotten.contains(6)
                                              ? grey3
                                              : null)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: boxIndexGotten.contains(7)
                                  ? null
                                  : () {
                                      if (mmenomicShuffled[7].toString() ==
                                          mmenomicArray[firstThree[
                                                      currentCorrectItem] -
                                                  1]
                                              .toString()) {
                                        setState(() {
                                          boxIndexGotten.add(7);
                                          if (currentCorrectItem == 2) {
                                            if (firstStep == true) {
                                              firstStep = false;
                                              secondStep = true;
                                            } else if (firstStep == false &&
                                                secondStep == true) {
                                              secondStep = false;
                                              thirdStep = true;
                                            } else if (secondStep == false &&
                                                thirdStep == true) {
                                              thirdStep = false;
                                              fourthStep = true;
                                            } else if (thirdStep == false &&
                                                fourthStep == true) {
                                              finished = true;
                                            }
                                            currentCorrectItem = 0;
                                          } else {
                                            currentCorrectItem++;
                                          }
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Incorrect seed pharse order'),
                                          ),
                                        );
                                      }
                                    },
                              child: Card(
                                color:
                                    boxIndexGotten.contains(7) ? grey1 : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    '${mmenomicShuffled[7].toString()}',
                                    style: TextStyle(
                                        color: boxIndexGotten.contains(7)
                                            ? grey3
                                            : null),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: boxIndexGotten.contains(8)
                                  ? null
                                  : () {
                                      if (mmenomicShuffled[8].toString() ==
                                          mmenomicArray[firstThree[
                                                      currentCorrectItem] -
                                                  1]
                                              .toString()) {
                                        setState(() {
                                          boxIndexGotten.add(8);
                                          if (currentCorrectItem == 2) {
                                            if (firstStep == true) {
                                              firstStep = false;
                                              secondStep = true;
                                            } else if (firstStep == false &&
                                                secondStep == true) {
                                              secondStep = false;
                                              thirdStep = true;
                                            } else if (secondStep == false &&
                                                thirdStep == true) {
                                              thirdStep = false;
                                              fourthStep = true;
                                            } else if (thirdStep == false &&
                                                fourthStep == true) {
                                              finished = true;
                                            }
                                            currentCorrectItem = 0;
                                          } else {
                                            currentCorrectItem++;
                                          }
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Incorrect seed pharse order'),
                                          ),
                                        );
                                      }
                                    },
                              child: Card(
                                color:
                                    boxIndexGotten.contains(8) ? grey1 : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    '${mmenomicShuffled[8].toString()}',
                                    style: TextStyle(
                                        color: boxIndexGotten.contains(8)
                                            ? grey3
                                            : null),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: boxIndexGotten.contains(9)
                                  ? null
                                  : () {
                                      if (mmenomicShuffled[9].toString() ==
                                          mmenomicArray[firstThree[
                                                      currentCorrectItem] -
                                                  1]
                                              .toString()) {
                                        setState(() {
                                          boxIndexGotten.add(9);
                                          if (currentCorrectItem == 2) {
                                            if (firstStep == true) {
                                              firstStep = false;
                                              secondStep = true;
                                            } else if (firstStep == false &&
                                                secondStep == true) {
                                              secondStep = false;
                                              thirdStep = true;
                                            } else if (secondStep == false &&
                                                thirdStep == true) {
                                              thirdStep = false;
                                              fourthStep = true;
                                            } else if (thirdStep == false &&
                                                fourthStep == true) {
                                              finished = true;
                                            }
                                            currentCorrectItem = 0;
                                          } else {
                                            currentCorrectItem++;
                                          }
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Incorrect seed pharse order'),
                                          ),
                                        );
                                      }
                                    },
                              child: Card(
                                color:
                                    boxIndexGotten.contains(9) ? grey1 : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                      '${mmenomicShuffled[9].toString()}',
                                      style: TextStyle(
                                          color: boxIndexGotten.contains(9)
                                              ? grey3
                                              : null)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: boxIndexGotten.contains(10)
                                  ? null
                                  : () {
                                      if (mmenomicShuffled[10].toString() ==
                                          mmenomicArray[firstThree[
                                                      currentCorrectItem] -
                                                  1]
                                              .toString()) {
                                        setState(() {
                                          boxIndexGotten.add(10);
                                          if (currentCorrectItem == 2) {
                                            if (firstStep == true) {
                                              firstStep = false;
                                              secondStep = true;
                                            } else if (firstStep == false &&
                                                secondStep == true) {
                                              secondStep = false;
                                              thirdStep = true;
                                            } else if (secondStep == false &&
                                                thirdStep == true) {
                                              thirdStep = false;
                                              fourthStep = true;
                                            } else if (thirdStep == false &&
                                                fourthStep == true) {
                                              finished = true;
                                            }
                                            currentCorrectItem = 0;
                                          } else {
                                            currentCorrectItem++;
                                          }
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Incorrect seed pharse order'),
                                          ),
                                        );
                                      }
                                    },
                              child: Card(
                                color:
                                    boxIndexGotten.contains(10) ? grey1 : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    '${mmenomicShuffled[10].toString()}',
                                    style: TextStyle(
                                        color: boxIndexGotten.contains(10)
                                            ? grey3
                                            : null),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: boxIndexGotten.contains(11)
                                  ? null
                                  : () {
                                      if (mmenomicShuffled[11].toString() ==
                                          mmenomicArray[firstThree[
                                                      currentCorrectItem] -
                                                  1]
                                              .toString()) {
                                        setState(() {
                                          boxIndexGotten.add(11);
                                          if (currentCorrectItem == 2) {
                                            if (firstStep == true) {
                                              firstStep = false;
                                              secondStep = true;
                                            } else if (firstStep == false &&
                                                secondStep == true) {
                                              secondStep = false;
                                              thirdStep = true;
                                            } else if (secondStep == false &&
                                                thirdStep == true) {
                                              thirdStep = false;
                                              fourthStep = true;
                                            } else if (thirdStep == false &&
                                                fourthStep == true) {
                                              finished = true;
                                            }
                                            currentCorrectItem = 0;
                                          } else {
                                            currentCorrectItem++;
                                          }
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Incorrect seed pharse order'),
                                          ),
                                        );
                                      }
                                    },
                              child: Card(
                                color:
                                    boxIndexGotten.contains(11) ? grey1 : null,
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                        '${mmenomicShuffled[11].toString()}',
                                        style: TextStyle(
                                            color: boxIndexGotten.contains(11)
                                                ? grey3
                                                : null))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: finished
                          ? () async {
                              var seedPhrases = (await SharedPreferences.getInstance()).getString('seedPhrases');
                              // save mnemonic to firebase
                              showDialog(context: context, builder: (context) => AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Wallet Name"),
                                    SizedBox(height: 30),
                                    Container(
                                      height: 40,
                                      child: TextFormField(                                      
                                        controller: walletNameController,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            hintText: 'Wallet Name Here',                                            
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Cancle'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: Text('Save'),
                                    onPressed: () async {
                                      var sharedPInstance = await SharedPreferences.getInstance();
                                      var userEmail = sharedPInstance.getString(emailLocals);
                                      if(userEmail != null || userEmail != ''){
                                        if(walletNameController.text.trim() != ''){
                                          CreatedPhraseModel model = CreatedPhraseModel(seedPhrase: widget.mmenomic, name: walletNameController.text.trim());
                                          await userCreatedWalletRef.doc(userEmail).collection('Created_Wallets').doc(walletNameController.text.trim()).set(model.toJson());
                                          print("Seed Phrase created in DB"); //testing
                                          await sharedPInstance.setBool(isSeedPhraseSaved, true);                                          
                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => WalletScreen()), (r) => false);
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Wallet Name has not been supplied',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                      
                                    },
                                  ),
                                ],
                              ));
                              if (seedPhrases != null &&
                                  (jsonDecode(seedPhrases) as List).contains(
                                      (widget.mmenomic as List).join(' '))) {
                                return;
                              }

                              if (seedPhrases == null) {
                                (await SharedPreferences.getInstance())
                                    .setString(
                                        'seedPhrases',
                                        jsonEncode([
                                          (widget.mmenomic as List).join(' ')
                                        ]));
                              } else {
                                var decodedSeedPhrase =
                                    jsonDecode(seedPhrases) as List;

                                (await SharedPreferences.getInstance())
                                    .setString(
                                        'seedPhrases',
                                        jsonEncode(decodedSeedPhrase
                                          ..add((widget.mmenomic as List)
                                              .join(' '))));
                              }

                              (await SharedPreferences.getInstance()).setString(
                                  'mmemomic',
                                  (widget.mmenomic as List).join(' '));
                              
                               (await SharedPreferences.getInstance()).setString(
                                'seedPhrases',
                                jsonEncode([(widget.mmenomic as List).join(' ')]
                                ));

                            }
                          : null,
                      child: isLoading
                          ? CircularProgressIndicator(color: yellow3)
                          : Text('Continue',
                              style: finished
                                  ? m_agSemiboldYellow3
                                  : m_agRegular_grey),
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
      ),
    );
  }
}
