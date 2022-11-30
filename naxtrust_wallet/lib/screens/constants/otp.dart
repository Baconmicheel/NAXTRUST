 import 'dart:convert';
import 'dart:math';

import 'package:cryptowallet/screens/constants/locals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;


class OTP {

  static generateOTPcode(){
     var rng = new Random();
     var rand = rng.nextInt(90000) + 10000;
     int code = rand.toInt();
     return code;
  }

  static Future<void> sendOTPMail(int otpCode, String userEmail, context, String message) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {'Content-Type' : 'application/json', 'origin' : 'http://localhost'},
      body: json.encode({
        'service_id': 'service_3rsrg2g',
        'template_id': 'template_9u8hq2w',
        'user_id': 'sbdpjZtKh7nCrG-54',
        'template_params': {
            'user_subject' : 'Verification Code',
            'user_message' : '$otpCode',
            'reply_to' : fromEmailAccount,
            'user_email' : userEmail,
            'message_head' : message
        }
      })
    );    

    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'A verification code has been sent to $userEmail. Provide the code so that you can see your seedphrase.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }else{
      print("Status Code ERROR: ${response.statusCode}");
    }     

   
  }
  

}