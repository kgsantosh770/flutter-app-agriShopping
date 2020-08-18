import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  final String documentId;
  DatabaseService({this.uid, this.documentId});

  // User future and stream functions

  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future setUserData(String name,
      {String email, String countryCode, String phoneNumber}) async {
    try {
      await userCollection.document(uid).setData({
        'name': name,
        'email': email != null ? email : '',
        'cart': {'total': 0, 'total_with_discount': 0, 'order': []},
        'phone': phoneNumber != null
            ? {
                'country_code': countryCode,
                'phone_number': phoneNumber,
              }
            : '',
        'default_address': {
          'state': '',
          'country': '',
          'area': '',
          'city': '',
          'house_number': '',
          'landmark': '',
          'mobile_number': '',
          'name': '',
          'pincode': '',
        },
      });
      return 'success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateUserData(data) async {
    try {
      return await userCollection.document(uid).updateData(data);
    } catch (e) {
      print(e.toString());
      return 'Error saving changes.';
    }
  }

  Future updateStaticOrderData(data) async {
    try {
      return await userCollection.document('static_datas').updateData(data);
    } catch (e) {
      print(e.toString());
      return "Error saving changes.";
    }
  }

  Future addProduct(
      {String to, String path, String itemDocId, double quantity}) async {
    try {
      var total, totalWithDiscount;
      DocumentReference itemDocRef = Firestore.instance.document(path);
      Map<String, dynamic> toData;
      DocumentReference userData = userCollection.document(uid);
      await userData.get().then((value) {
        toData = value.data[to];
      });
      if (to == 'cart') {
        await itemDocRef.get().then((value) {
          total = (toData['total'] + (quantity * value.data['mrp']));
          totalWithDiscount = double.parse((toData['total_with_discount'] +
                  (quantity *
                      (value.data['mrp'] -
                          (value.data['mrp'] *
                              (value.data['discount_percent'] / 100)))))
              .toStringAsFixed(2));
        });
      }
      if (to == 'favorites') {
        toData[itemDocId] = itemDocRef;
      } else {
        List order = toData['order'];
        order.add(itemDocId);
        toData[itemDocId] = {
          'quantity': quantity,
          'document_reference': itemDocRef,
        };
        toData['total'] = total;
        toData['total_with_discount'] = totalWithDiscount;
        toData['order'] = order;
      }
      Map<String, dynamic> updatedData = {
        to: toData,
      };
      await updateUserData(updatedData);
      return 'success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future removeProduct({String from, String path, String itemDocId}) async {
    try {
      var itemPrice, itemDiscount, itemQuantity;
      List order;
      Map<String, dynamic> fromData;
      DocumentReference userData = userCollection.document(uid);
      await userData.get().then((value) {
        fromData = value.data[from];
      });
      if (from == 'cart') {
        DocumentReference itemDocRef = Firestore.instance.document(path);
        await itemDocRef.get().then((value) {
          itemPrice = value.data['mrp'];
          itemDiscount = value.data['discount_percent'];
        });
        itemQuantity = fromData[itemDocId]['quantity'];
        order = fromData['order'];
        order.remove(itemDocId);
        fromData['total'] = fromData['total'] - (itemQuantity * itemPrice);
        fromData['total_with_discount'] = double.parse(
            (fromData['total_with_discount'] -
                    (itemQuantity *
                        (itemPrice - (itemPrice * (itemDiscount / 100)))))
                .toStringAsFixed(2));
        fromData['order'] = order;
      }
      fromData.remove(itemDocId);
      Map<String, dynamic> updatedData = {
        from: fromData,
      };
      await updateUserData(updatedData);
      return 'success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future changeCartQuantity(
      String item, var price, double discountPrice, double quantity) async {
    try {
      Map<String, dynamic> cartData;
      DocumentReference userData = userCollection.document(uid);
      await userData.get().then((value) {
        cartData = value.data['cart'];
      });
      if (cartData[item]['quantity'] > quantity) {
        cartData['total'] = cartData['total'] - price;
        cartData['total_with_discount'] =
            cartData['total_with_discount'] - discountPrice;
      } else {
        cartData['total'] = cartData['total'] + price;
        cartData['total_with_discount'] =
            cartData['total_with_discount'] + discountPrice;
      }
      cartData[item]['quantity'] = quantity;
      await updateUserData({'cart': cartData});
      return 'quantity change success';
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
