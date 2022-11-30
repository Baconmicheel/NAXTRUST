import 'package:cryptowallet/utils/rpcUrls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/colors.dart';
import '../../config/styles.dart';
import '../utils/slideUpPanel.dart';

class claim_airdrop extends StatefulWidget {
  var data;
  claim_airdrop({ this.data});

  @override
  _claim_airdropState createState() => _claim_airdropState();
}

class _claim_airdropState extends State<claim_airdrop> {
  bool isLoading = false;
  bool isClaiming = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  'Claim Airdrop',
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
            Text(
              '2,3686',
              style: h3,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                walletAbbr,
                style: m_normal,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Please note that this reward can be claimed once only ',
                style: s_agRegular_gray12,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isClaiming = true;
                    });
                    var twitterHandle = widget.data['twitter'];
                    var telegramHandle = widget.data['telegram'];
                    var discordHandle = widget.data['discord'];
                    //  var response = (await get(Uri.parse(''))).body;
                    var response = {
                      "transactionStatus": "success",
                      "hash": "0xBBB6A12945aC14C84185a17C6BD2eAe96e",
                      "walletAddress": "0x338389283abcd3839def"
                    };
                    slideUpPanel(context,
                        StatefulBuilder(builder: (ctx, setState) {
                      var bscAirdropUrl =
                          'https://cryptooly.app.link/send/${response['hash']}/value=21jq';

                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            response['transactionStatus'] == 'success'
                                ? SvgPicture.asset(
                                    'assets/svgs/icon_wrapper.svg')
                                : Image.asset(
                                    'assets/images/failedIcon.png',
                                    scale: 10,
                                  ),
                            Padding(
                              padding: EdgeInsets.all(30),
                              child: Text(
                                response['transactionStatus'] == 'success'
                                    ? 'Airdrop Claimed Successfully'
                                    : 'Airdrop Could not be Claimed',
                                style: title1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Click the link below to view transaction on Bscsacan',
                                style: s_agRegular_gray12,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: GestureDetector(
                                  child: isLoading
                                      ? CircularProgressIndicator(
                                          color: blue5,
                                        )
                                      : Text(
                                          bscAirdropUrl,
                                          style: s_agRegularLinkBlue5Underline,
                                          textAlign: TextAlign.center,
                                        ),
                                  onTap: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      await launch(bscAirdropUrl);
                                    } catch (e) {}
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      );
                    }));

                    setState(() {
                      isClaiming = false;
                    });
                  },
                  child: isClaiming
                      ? CircularProgressIndicator(
                          color: primary5,
                        )
                      : Text('Claim', style: l_large_normal_primary5),
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
    ));
  }
}
