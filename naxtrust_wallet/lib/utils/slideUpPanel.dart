import 'package:flutter/material.dart';
import './removeScrollGlow.dart';

slideUpPanel(context, screen) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: ScrollConfiguration(
            behavior: RemoveScrollGlow(),
            child: SingleChildScrollView(
              child: screen,
            ),
          ),
        );
      });
}
