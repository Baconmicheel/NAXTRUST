import 'package:cryptowallet/screens/add_custom_token.dart';
import 'package:flutter/material.dart';

class ImportToken extends StatefulWidget {
  @override
  _ImportTokenState createState() => _ImportTokenState();
}

class _ImportTokenState extends State<ImportToken> {
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Search Token', border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => AddCustomToken()));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Add Custom Token',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
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
