import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptowallet/screens/constants/locals.dart';



  List<ImportedPhraseModel> importedSeedPhrasesList = [];
  List<CreatedPhraseModel> createdSeedPhrasesList = [];

  Future<void> fetchCreatedSeedPhrases(String userEmail) async {
    try{
      QuerySnapshot<Map<String, dynamic>> createdPhraseData = await userCreatedWalletRef.doc(userEmail).collection('Created_Wallets').get();

      final createdList = createdPhraseData.docs.map((e) => CreatedPhraseModel.fromSnapshot(e)).toList();
      // final createdList = createdPhraseData.docs.map((e) => e).toList();

      createdSeedPhrasesList.clear();    

      createdSeedPhrasesList.addAll(createdList);
      
    }catch (e){
      print("Fetch ERROR: $e");
    }
  }

  Future<void> fetchImportedSeedPhrases(String userEmail) async {
    try{
      QuerySnapshot<Map<String, dynamic>> importPhraseData = await userWalletRef.doc(userEmail).collection('Imported_Wallets').get();


      final importedList = importPhraseData.docs.map((e) => ImportedPhraseModel.fromSnapshot(e)).toList();

      importedSeedPhrasesList.clear();

      importedSeedPhrasesList.addAll(importedList);
      
    }catch (e){
      print("Fetch ERROR: $e");
    }
  }





class CreatedPhraseModel{
  String name;
  List seedPhrase;
  

  CreatedPhraseModel({ required this.seedPhrase, required this.name});

  CreatedPhraseModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot):
    name = snapshot['name'],
    seedPhrase =  snapshot['seed_phrase'];

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['seed_phrase'] = this.seedPhrase;     
    return data;
  }

    
}


class ImportedPhraseModel{
  String name;
  List seedPhrase;
  

  ImportedPhraseModel({ required this.seedPhrase, required this.name});

  ImportedPhraseModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot):
    name = 'Imported SeedPhrase',
    seedPhrase = snapshot['seed_phrase'];


}