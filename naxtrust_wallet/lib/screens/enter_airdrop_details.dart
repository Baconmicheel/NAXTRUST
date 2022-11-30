import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/styles.dart';
import './claim_airdrop.dart';

class enter_airdrop_details extends StatefulWidget {

  @override
  _enter_airdrop_detailsState createState() => _enter_airdrop_detailsState();
}

class _enter_airdrop_detailsState extends State<enter_airdrop_details> {
  var twitterController = TextEditingController();
  var telegramController = TextEditingController();
  var discordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
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
                    'Enter Details',
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
              TextField(
                controller: twitterController,
                onChanged: (value) {},
                decoration: InputDecoration(
                  labelText: 'Twitter handle (e.g @greedypop)',
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: telegramController,
                onChanged: (value) {},
                decoration: InputDecoration(
                  labelText: 'Telegram Username (e.g @greedypop)',
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: discordController,
                onChanged: (value) {},
                decoration: InputDecoration(
                  labelText: 'Discord Username (e.g @greedypop)',
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'By proceeding, you agree to these ',
                        style: m_agRegular_grey),
                    TextSpan(
                        text: 'Term and Conditions.',
                        style: TextStyle(
                          color: blue5,
                          decoration: TextDecoration.underline,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => claim_airdrop(data: {
                                    'twitter': twitterController.text.trim(),
                                    'telegram': telegramController.text.trim(),
                                    'discord': discordController.text.trim(),
                                  })));
                    },
                    child: Text('Next', style: l_large_normal_primary5),
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
    ));
  }
}
