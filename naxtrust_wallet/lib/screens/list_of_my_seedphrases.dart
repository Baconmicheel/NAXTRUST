import 'package:cryptowallet/screens/constants/data.dart';
import 'package:cryptowallet/screens/view_seedPhrases.dart';
import 'package:cryptowallet/screens/see_seed_phrase.dart';
import 'package:flutter/material.dart';

class ListOfMySeedPhrases extends StatelessWidget {
  const ListOfMySeedPhrases({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          itemCount: createdSeedPhrasesList.length,
          itemBuilder: ((context, index) {
            var cd = createdSeedPhrasesList[index];
            return GestureDetector(
              onTap: () {
                // see the seed phrase                                         
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => SeeSeedPhrase(phrase: cd)));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.green[200]),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cd.name,
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),                  
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}