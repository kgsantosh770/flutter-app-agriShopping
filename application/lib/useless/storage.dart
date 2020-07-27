import 'package:agri_shopping/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<List> getImages(
      QuerySnapshot imageNames, String collectionName) async {
    StorageReference imageReference =
        FirebaseStorage.instance.ref().child(collectionName);

    List imageUrls = List();
    try {
      for (var i = 0; i < imageNames.documents.length; i++) {
        var document = imageNames.documents[i];
        var imageName = document.documentID.toLowerCase();
        imageUrls
            .add(await imageReference.child('$imageName.jpg').getDownloadURL());
      }
    } catch (e) {
      print(imageUrls);
      print(e.toString());
      imageUrls.clear();
      imageUrls.add(fruits);
    }
    return imageUrls;
  }
}
