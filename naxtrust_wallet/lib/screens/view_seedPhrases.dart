import 'package:cryptowallet/screens/wallet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewSeedPhrase extends StatefulWidget {
  List data;
  ViewSeedPhrase({required this.data});
  @override
  State<ViewSeedPhrase> createState() => _ViewSeedPhraseState();
}

class _ViewSeedPhraseState extends State<ViewSeedPhrase> {
  @override
  Widget build(BuildContext context) {
    var seedList = (widget.data as List);
    var widgetList = <Widget>[];

    for (String element in seedList) {
      widgetList.addAll([
        SizedBox(
          height: 10,
        ),
        Divider(),
        InkWell(
          onTap: () async {
            (await SharedPreferences.getInstance())
                .setString('mmemomic', element);
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => WalletScreen()));
          },
          child: Text(
            element,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18),
          ),
        )
      ]);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(children: widgetList),
          ),
        ),
      ),
    );
  }
}
