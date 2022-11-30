import 'package:flutter/material.dart';

final primaryColor = Color(0xFF45C2DA);
// final background = Color(0xFF191B2A);
final background = Color(0xFF0F233D);
final cardColorLight = Colors.white;
final cardColorDark = Colors.black;
final fontColorLight = Colors.black;
final fontColorDark = Colors.white;
final fontSecondaryColorLight = Colors.black26;
final fontSecondaryColorDark = Colors.white24;
final iconColorLight = Colors.black;
final iconColorDark = Colors.white;
final fontColorDarkTitle = Color(0xFF32353E);
final grayBackground = Color(0xFF172E4D);
final whiteBacground = Color(0xFFF4F5F7);
//  final grayBackground = Color(0xFF16223A);
final blackBackground = Color(0xFF12151C);
final bottomBarDark = Color(0xFF202833);

final white = Colors.white;
final black = Colors.black;
final mask = Color.fromRGBO(0, 0, 0, 0.6);
final transparent = Color.fromRGBO(0, 0, 0, 0);
final gradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color.fromRGBO(245, 250, 128, 1),
    Color.fromRGBO(9, 10, 11, 1),
  ],
);

//Primary
final primary1 = Color.fromRGBO(250, 253, 225, 1);
final primary2 = Color.fromRGBO(253, 254, 204, 1);
final primary3 = Color.fromRGBO(251, 253, 179, 1);
final primary4 = Color.fromRGBO(248, 251, 159, 1);
final primary5 = Color.fromRGBO(245, 250, 128, 1);
final primary6 = Color.fromRGBO(209, 215, 93, 1);
final primary7 = Color.fromRGBO(174, 179, 64, 1);
final primary8 = Color.fromRGBO(139, 144, 40, 1);

//Secondary
final secondary1 = Color.fromRGBO(254, 254, 229, 1);
final secondary2 = Color.fromRGBO(246, 252, 250, 1);
final secondary3 = Color.fromRGBO(238, 246, 244, 1);
final secondary4 = Color.fromRGBO(228, 238, 237, 1);
final secondary5 = Color.fromRGBO(215, 228, 227, 1);
final secondary6 = Color.fromRGBO(157, 195, 196, 1);
final secondary7 = Color.fromRGBO(108, 158, 164, 1);
final secondary8 = Color.fromRGBO(68, 119, 132, 1);

//Gray
final grey0 = Color.fromRGBO(248, 248, 249, 1);
final grey1 = Color.fromRGBO(244, 244, 246, 1);
final grey2 = Color.fromRGBO(232, 233, 237, 1);
final grey3 = Color.fromRGBO(221, 223, 228, 1);
final grey4 = Color.fromRGBO(209, 212, 219, 1);
final grey5 = Color.fromRGBO(198, 200, 210, 1);
final grey6 = Color.fromRGBO(186, 190, 201, 1);
final grey7 = Color.fromRGBO(175, 180, 192, 1);
final grey8 = Color.fromRGBO(164, 169, 183, 1);
final grey9 = Color.fromRGBO(152, 158, 174, 1);
final grey10 = Color.fromRGBO(141, 147, 165, 1);
final grey11 = Color.fromRGBO(129, 137, 156, 1);
final grey12 = Color.fromRGBO(118, 126, 147, 1);
final grey13 = Color.fromRGBO(108, 116, 137, 1);
final grey14 = Color.fromRGBO(99, 106, 126, 1);
final grey15 = Color.fromRGBO(90, 96, 114, 1);
final grey16 = Color.fromRGBO(81, 87, 103, 1);
final grey17 = Color.fromRGBO(71, 76, 90, 1);
final grey18 = Color.fromRGBO(63, 67, 80, 1);
final grey19 = Color.fromRGBO(54, 58, 69, 1);
final grey20 = Color.fromRGBO(45, 48, 57, 1);
final grey21 = Color.fromRGBO(36, 39, 46, 1);
final grey22 = Color.fromRGBO(27, 29, 34, 1);
final grey23 = Color.fromRGBO(18, 19, 23, 1);
final grey24 = Color.fromRGBO(9, 10, 11, 1);

//Blue
final blue1 = Color.fromRGBO(199, 249, 244, 1);
final blue2 = Color.fromRGBO(146, 243, 240, 1);
final blue3 = Color.fromRGBO(88, 213, 219, 1);
final blue4 = Color.fromRGBO(47, 167, 184, 1);
final blue5 = Color.fromRGBO(1, 110, 137, 1);
final blue6 = Color.fromRGBO(0, 85, 117, 1);
final blue7 = Color.fromRGBO(0, 64, 98, 1);
final blue8 = Color.fromRGBO(0, 46, 79, 1);

//Yellow
final yellow1 = Color.fromRGBO(254, 240, 203, 1);
final yellow2 = Color.fromRGBO(253, 222, 153, 1);
final yellow3 = Color.fromRGBO(251, 197, 101, 1);
final yellow4 = Color.fromRGBO(247, 172, 63, 1);
final yellow5 = Color.fromRGBO(242, 134, 2, 1);
final yellow6 = Color.fromRGBO(208, 105, 1, 1);
final yellow7 = Color.fromRGBO(174, 80, 1, 1);
final yellow8 = Color.fromRGBO(140, 58, 0, 1);

//green
final green1 = Color.fromRGBO(205, 249, 208, 1);
final green2 = Color.fromRGBO(157, 243, 171, 1);
final green3 = Color.fromRGBO(103, 220, 134, 1);
final green4 = Color.fromRGBO(62, 186, 107, 1);
final green5 = Color.fromRGBO(16, 140, 74, 1);
final green6 = Color.fromRGBO(11, 120, 73, 1);
final green7 = Color.fromRGBO(8, 100, 69, 1);
final green8 = Color.fromRGBO(5, 81, 63, 1);

//Red
final red1 = Color.fromRGBO(255, 229, 218, 1);
final red2 = Color.fromRGBO(255, 196, 182, 1);
final red3 = Color.fromRGBO(255, 157, 145, 1);
final red4 = Color.fromRGBO(255, 121, 118, 1);
final red5 = Color.fromRGBO(255, 73, 86, 1);
final red6 = Color.fromRGBO(219, 53, 80, 1);
final red7 = Color.fromRGBO(183, 36, 73, 1);
final red8 = Color.fromRGBO(147, 23, 65, 1);

// Edit 1
final app_bg = Color(0xffE5E5E5);
