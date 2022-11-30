import 'package:cloud_firestore/cloud_firestore.dart';

const String emailLocals = "user-email-local";
const String isSeedPhraseSaved = "is-seed-phrase-saved";
const String userBitCoinAddress = "user-bitcoin-address";
const String userEthereumAddress = "user-ethereum-address";

final fireStore = FirebaseFirestore.instance;

final userWalletRef = fireStore.collection('user_imported_wallets');
final userCreatedWalletRef = fireStore.collection('user_created_wallets');

const String fromEmailAccount = 'info@naxtrust.com';
const String fromEmailAccountPswd = '';
const String fromEmailPassCode = 'uzxxnhjxzrpcxlgz';


