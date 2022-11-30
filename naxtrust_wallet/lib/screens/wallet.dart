import 'dart:convert';
import 'dart:math';

import 'package:cryptowallet/screens/MarketPlace.dart';
import 'package:cryptowallet/screens/import_token.dart';
import 'package:cryptowallet/screens/settings.dart';
import 'package:cryptowallet/screens/swap.dart';
import 'package:cryptowallet/screens/token.dart';
import 'package:cryptowallet/screens/wallet_main_body.dart';
import 'package:cryptowallet/utils/format_money.dart';
import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:cryptowallet/config/colors.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

bool isDarkMode = true;

class _WalletScreenState extends State<WalletScreen> {
  var currentIndex_ = 0;
  @override
  void initState() {
    super.initState();
  }

  var pages = [
    WalletMainBody(),
    Swap(),
    Settings(isDarkMode: isDarkMode),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blueAccent,
          currentIndex: currentIndex_,
          onTap: (index) async {
            setState(() {
              currentIndex_ = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_wallet,
                size: 40,
              ),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.swap_horiz,
                size: 40,
              ),
              label: 'Swap',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 40,
              ),
              label: 'Settings',
            ),
          ],
        ),
        body: pages[currentIndex_]);
  }
}
