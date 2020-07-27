import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  final String documentId;
  DatabaseService({this.uid, this.documentId});

  // User future and stream functions

  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future setUserData(String name, String email) async {
    try {
      await userCollection.document(uid).setData({
        'name': name,
        'email': email,
        'phone': '',
        'location': '',
        'primary_address': '',
        'secondary_address': '',
        'temporary_address': '',
      });
      List<String> docNames = ['cart', 'favorites'];
      for (var i = 0; i < 2; i++) {
        DocumentReference docRef = userCollection
            .document(uid)
            .collection('user_items')
            .document(docNames[i]);
        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(docRef, {'total_items': 0});
        });
        print('round $i success');
      }
      return 'success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateUserData(Map<String, dynamic> data) async {
    try {
      return await userCollection.document(uid).updateData(data);
    } catch (e) {
      print(e.toString());
      return 'Error saving changes.';
    }
  }

  Future addToCart(String itemCategory, String itemDocId) async {
    try {
      DocumentReference itemDocRef =
          Firestore.instance.collection(itemCategory).document(itemDocId);
      CollectionReference cartCollection =
          userCollection.document(uid).collection('user_items');
      int currentCartItems;
      await cartCollection.getDocuments().then((value) async {
        currentCartItems = value.documents[0].data['total_items'];
      });
      currentCartItems = currentCartItems + 1;
      DocumentReference cartDocRef = userCollection
          .document(uid)
          .collection('user_items')
          .document('cart');
      await Firestore.instance.runTransaction((transaction) async {
        await transaction.update(cartDocRef, {
          '$itemDocId': itemDocRef,
          'total_items': currentCartItems,
        });
      });
      return 'success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future removeFromCart(String itemCategory, String itemDocId) async {
    try {
      CollectionReference cartCollection =
          userCollection.document(uid).collection('user_items');
      int currentCartItems;
      await cartCollection.getDocuments().then((value) async {
        currentCartItems = value.documents[0].data['total_items'];
      });
      currentCartItems = currentCartItems - 1;
      DocumentReference cartDocRef = userCollection
          .document(uid)
          .collection('user_items')
          .document('cart');
      await Firestore.instance.runTransaction((transaction) async {
        await transaction.update(cartDocRef, {
          '$itemDocId': FieldValue.delete(),
          'total_items': currentCartItems,
        });
      });
      return 'success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future addToFavorites(String itemCategory, String itemDocId) async {
    try {
      DocumentReference itemDocRef =
          Firestore.instance.collection(itemCategory).document(itemDocId);
      CollectionReference favoriteCollection =
          userCollection.document(uid).collection('user_items');
      int currentFavoriteItems;
      await favoriteCollection.getDocuments().then((value) async {
        currentFavoriteItems = value.documents[1].data['total_items'];
      });
      currentFavoriteItems = currentFavoriteItems + 1;
      DocumentReference favoriteDocRef = userCollection
          .document(uid)
          .collection('user_items')
          .document('favorite');
      await Firestore.instance.runTransaction((transaction) async {
        await transaction.update(favoriteDocRef, {
          '$itemDocId': itemDocRef,
          'total_items': currentFavoriteItems,
        });
      });
      return 'success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future removeFromFavorite(String itemCategory, String itemDocId) async {
    try {
      CollectionReference favoriteCollection =
          userCollection.document(uid).collection('user_items');
      int currentFavoriteItems;
      await favoriteCollection.getDocuments().then((value) async {
        currentFavoriteItems = value.documents[1].data['total_items'];
      });
      currentFavoriteItems = currentFavoriteItems - 1;
      DocumentReference favoriteDocRef = userCollection
          .document(uid)
          .collection('user_items')
          .document('favorite');
      await Firestore.instance.runTransaction((transaction) async {
        await transaction.update(favoriteDocRef, {
          '$itemDocId': FieldValue.delete(),
          'total_items': currentFavoriteItems,
        });
      });
      return 'success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Stream<DocumentSnapshot>> getStream(String collectionName) async {
    CollectionReference collectionReference =
        Firestore.instance.collection(collectionName);
    return collectionReference.document(uid).snapshots();
  }

  Stream<DocumentSnapshot> get userData {
    return userCollection.document(uid).snapshots();
  }

  Stream<DocumentSnapshot> get staticData {
    return userCollection.document('static_datas').snapshots();
  }

  Stream<DocumentSnapshot> get userCartData {
    return userCollection
        .document(uid)
        .collection('user_items')
        .document('cart')
        .snapshots();
  }

  Stream<DocumentSnapshot> get userFavoriteData {
    return userCollection
        .document(uid)
        .collection('user_items')
        .document('favorite')
        .snapshots();
  }

  // Futures and streams to extract data from firebase

  Future toDocumentSnapshot(DocumentReference docRef) async {
    DocumentSnapshot data;
    await docRef.get().then((value) {
      data = value;
    });
    return data;
  }

  Future getDocumentData(collectionName, documentName) async {
    Map collections;
    await Firestore.instance
        .collection(collectionName)
        .document(documentName)
        .get()
        .then((value) async {
      collections = value.data;
    });
    return collections;
  }

  Future getFirebaseData() async {
    Map collectionNames = Map();
    List<Stream<QuerySnapshot>> collectionSnapshots = List();
    Map<String, dynamic> firebaseData = Map();

    await getDocumentData('common_collection_data', 'collection_names')
        .then((value) async {
      collectionNames = value;
    });

    firebaseData['collections'] = collectionNames['collections'];
    firebaseData['tempCollections'] = collectionNames['temporary_collections'];
    firebaseData['suggestions'] = collectionNames['suggestions'];

    for (var i = 0; i < firebaseData['collections'].length; i++) {
      CollectionReference reference =
          Firestore.instance.collection(firebaseData['collections'][i]);
      collectionSnapshots.add(reference.snapshots());
    }
    firebaseData['collectionStreams'] = collectionSnapshots;
    return firebaseData;
  }
}

/* useless futures, functions, variables, and streams */

// import 'package:agri_shopping/useless/storage.dart';

// final CollectionReference fruitsCollection =
//     Firestore.instance.collection('fruits');
// final CollectionReference cerealsCollection =
//     Firestore.instance.collection('cereals');
// final CollectionReference spicesCollection =
//     Firestore.instance.collection('spices');

// Future insert() async {
//   QuerySnapshot querySnapshot;
//   List allImageUrls = List();
//   List names = ['spices', 'vegetables', 'cereals'];
//   for (var i = 0; i < 3; i++) {
//     String collectionName = names[i];
//     await getDocumentImages(collectionName)
//         .then((value) => allImageUrls = value);
//     await getDocumentIds(collectionName)
//         .then((value) => querySnapshot = value);
//     for (var i = 0; i < querySnapshot.documents.length; i++) {
//       DocumentReference documentReference = Firestore.instance
//           .collection(collectionName)
//           .document(querySnapshot.documents[i].documentID);
//       Firestore.instance.runTransaction((transaction) async {
//         await transaction
//             .update(documentReference, {'photo_url': allImageUrls[i]});
//       });
//     }
//   }
// }
// Future<List<Stream<QuerySnapshot>>> generateAllStreams(
//     List collectionNames) async {
//   List<Stream<QuerySnapshot>> allItemsSnapshot = List();
//   for (var i = 0; i < collectionNames.length; i++) {
//     CollectionReference reference =
//         Firestore.instance.collection(collectionNames[i]);
//     allItemsSnapshot.add(reference.snapshots());
//   }
//   return allItemsSnapshot;
// }
// Stream<List<QuerySnapshot>> get allItemStreams {

//   return []
// }
// Future insert(List collectionList) async {
//   // List collectionList = ['apple','banana','']
//   for (var i = 0; i < collectionList.length; i++) {
//     // CollectionReference reference = Firestore.instance.collection(collectionList[i]);
//     QuerySnapshot querySnapshot = await getDocumentIds(collectionList[i]);
//     for (var j = 0; j < 2; j++) {
//       DocumentReference documentReference = Firestore.instance
//           .collection('daily_necessities')
//           .document(querySnapshot.documents[j].documentID);
//       Firestore.instance.runTransaction((transaction) async {
//         await transaction.set(
//             documentReference, querySnapshot.documents[j].data);
//       });
//     }
//   }
// }

// Stream<QuerySnapshot> get fruits {
//   return fruitsCollection.snapshots();
// }

// Stream<QuerySnapshot> get spices {
//   return spicesCollection.snapshots();
// }

// Stream<QuerySnapshot> get cereals {
//   return cerealsCollection.snapshots();
// }

// getAllStreamData() {
//   Map<String, Stream> allItemsStream = Map();
//   allItemsStream['fruits'] = _db.fruits;
//   allItemsStream['spices'] = _db.spices;
//   allItemsStream['cereals'] = _db.cereals;
//   return allItemsStream;
// }

// Future updateUserData(Map<String, dynamic> data) async {
//   return await userCollection.document(uid).updateData(data);
// }

// Future getDocumentImages(String collectionName) async {
//   QuerySnapshot querySnapshot;
//   dynamic result;
//   await getDocumentIds(collectionName).then((value) => querySnapshot = value);
//   collectionName = collectionName.toLowerCase().trim();
//   result = await StorageService().getImages(querySnapshot, collectionName);
//   return result;
// }

// Future getAllDocumentImages(List collectionList) async {
//   Map<String, List> allImageUrls = Map();
//   for (var i = 0; i < collectionList.length; i++) {
//     allImageUrls[collectionList[i]] = List();
//   }
//   for (var i = 0; i < collectionList.length; i++) {
//     allImageUrls[collectionList[i]] =
//         await getDocumentImages(collectionList[i]);
//   }
//   return allImageUrls;
// }

// Map<String, List> allImageUrls = Map();

// await getAllDocumentImages(allData['collectionNames'])
//     .then((value) => allImageUrls = value);

// allData['imageUrls'] = allImageUrls;

// Future<QuerySnapshot> getQuerySnapshots(collectionName) async {
//   QuerySnapshot result;
//   CollectionReference collection =
//       Firestore.instance.collection(collectionName);
//   result = await collection.getDocuments();
//   return result;
// }
// Future getStreamList(collectionName) async {
//     List<Stream<DocumentSnapshot>> documentSnapshotList = List();

//     QuerySnapshot querySnapshot = await getQuerySnapshots(collectionName);
//     for (var documentIndex = 0;
//         documentIndex < querySnapshot.documents.length;
//         documentIndex++) {
//       DocumentReference docRef =
//           querySnapshot.documents[documentIndex].data['document_reference'];
//       documentSnapshotList.add(docRef.snapshots());
//     }

//     return documentSnapshotList;
//   }
