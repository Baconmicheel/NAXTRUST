import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/config/colors.dart';
import '/config/styles.dart';
import './enter_airdrop_details.dart';

class airdrop extends StatefulWidget {
  @override
  _airdropState createState() => _airdropState();
}

class _airdropState extends State<airdrop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Column(children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Airdrop',
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
              Text('Tasks'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Please make sure you completed all the tasks before clicking on the next button to claim airdrop.',
                style: s12_18_agRegular_grey,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Follow Twitter account',
                    style: suBtitle2,
                  ),
                  IconButton(
                      onPressed: () async {
                        await launch(followTwitterAccount);
                      },
                      icon: Icon(Icons.arrow_forward_ios))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Text(
                    'Retweet Pinned Post & Tag 3 Friends',
                    style: suBtitle2,
                  )),
                  IconButton(
                      onPressed: () async {
                        await launch(retweetPost);
                      },
                      icon: Icon(Icons.arrow_forward_ios))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Join Discord Server',
                    style: suBtitle2,
                  ),
                  IconButton(
                      onPressed: () async {
                        await launch(joinDiscord);
                      },
                      icon: Icon(Icons.arrow_forward_ios))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Join telegram group and channel',
                      style: suBtitle2,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await launch(joinTelegram);
                    },
                    icon: Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Row(children: [
          Image.asset('assets/18_3.png'),
        ]),
        SizedBox(
          height: 50,
        ),
        Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => enter_airdrop_details()));
                  },
                  child: Text('Next', style: l_large_normal_primary5),
                  style: ElevatedButton.styleFrom(
                    primary: black,
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                ))),
      ])),
    ));
  }
}
