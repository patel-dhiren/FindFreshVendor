import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fresh_find_vendor/model/order.dart';
import 'package:image_picker/image_picker.dart';

import '../model/app_user.dart';
import '../model/category.dart';
import '../model/item.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<String?> createUserWithEmailAndPassword(
      AppUser user, XFile? imageFile) async {
    try {
      // Create user account with email and password
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadImageToStorage(imageFile);
      }

      user.profileImage =
          imageUrl; // Make sure AppUser has a field for imageUrl

      user.id = credential.user!.uid;
      // Add user details to Realtime Database under 'users' node
      await _database.ref('vendors/${credential.user!.uid}').set(user.toJson());
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<String> uploadImageToStorage(XFile imageFile) async {
    Reference ref = _storage
        .ref()
        .child('profile_images')
        .child(_firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(File(imageFile.path));
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> updateVendorProfile(
      AppUser user, XFile? newImage, String? existingImageUrl) async {
    String uid = _firebaseAuth.currentUser!.uid; // Get the current user's UID

    String imageUrl = existingImageUrl ?? '';
    if (newImage != null) {
      File file = File(newImage.path);
      TaskSnapshot snapshot = await _storage
          .ref()
          .child('profile_images')
          .child(_firebaseAuth.currentUser!.uid)
          .putFile(file);
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    user.profileImage = imageUrl;

    // Create a reference to the user's profile in the database
    DatabaseReference ref = _database.ref('vendors/$uid');

    // Update the profile data
    await ref.update(user.toJson()).catchError((error) {
      // Handle any errors here
      print("Error updating vendor profile: $error");
      throw Exception("Failed to update profile.");
    });

    // Optionally, if updating email or password, use Firebase Auth methods here.
    // Note: Changing email or password with Firebase Auth requires different handling.
  }

  Future<bool?> addOrUpdateItem(
      {String? itemId,
      required String name,
      required String description,
      required double price,
      required int stock,
      required String unit,
      XFile? newImage,
      String? existingImageUrl,
      int? createdAt,
      required BuildContext context}) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Center(
            child: CircularProgressIndicator(
          color: Colors.red,
        )),
      );

      String imageUrl = existingImageUrl ?? '';
      if (newImage != null) {
        // If a new image is selected, upload it
        String filePath = 'items/${DateTime.now().millisecondsSinceEpoch}.png';
        File file = File(newImage.path);
        TaskSnapshot snapshot =
            await _storage.ref().child(filePath).putFile(file);
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      int timestamp = createdAt ?? DateTime.now().millisecondsSinceEpoch;

      var vendor = await fetchVendorById();

      Item item = Item(
          id: itemId,
          name: name,
          description: description,
          price: price,
          stock: stock,
          unit: unit,
          imageUrl: imageUrl,
          vendorId: vendor.id!,
          vendorName: vendor.vendorName,
          city: vendor.city,
          vendorBusinessName: vendor.businessName,
          createdAt: timestamp);

      if (itemId == null) {
        var id = _database.ref().child('items/${vendor.id}').push().key;
        item.id = id;
        await _database
            .ref()
            .child('items/${vendor.id}')
            .child(id!)
            .set(item.toJson());

        await _database.ref().child('all-items').child(id!).set(item.toJson());
      } else {
        // Update existing category
        await _database
            .ref()
            .child('items/${vendor.id}')
            .child(itemId)
            .update(item.toJson());

        await _database
            .ref()
            .child('all-items')
            .child(itemId)
            .set(item.toJson());
      }
      Navigator.pop(context);
      return true;
    } catch (e) {
      print(e);
      Navigator.pop(context);
      return false;
    }
  }

  Stream<List<Item>> get itemStream {
    var vendorId = _firebaseAuth.currentUser!.uid;

    return _database.ref().child('items/$vendorId').onValue.map((event) {
      List<Item> items = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> itemsMap =
            event.snapshot.value as Map<dynamic, dynamic>;
        itemsMap.forEach((key, value) {
          final item = Item.fromJson(value);
          items.add(item);
        });
      }
      return items;
    });
  }

  Future<bool> deleteItem(String itemId) async {
    try {
      var vendorId = _firebaseAuth.currentUser!.uid;

      await _database.ref().child('items/$vendorId').child(itemId).remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Category>> loadCategories() async {
    DataSnapshot snapshot = await _database.ref().child('categories').get();
    List<Category> categories = [];
    if (snapshot.exists) {
      Map<dynamic, dynamic> categoriesMap =
          snapshot.value as Map<dynamic, dynamic>;
      categoriesMap.forEach((key, value) {
        final category = Category.fromJson(value);
        categories.add(category);
      });
    }
    return categories;
  }

  Future<AppUser> fetchVendorById() async {
    try {
      var vendorId = _firebaseAuth.currentUser!.uid;

      DataSnapshot snapshot =
          await _database.ref().child('vendors/$vendorId').get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> vendorData =
            Map<dynamic, dynamic>.from(snapshot.value as Map);
        return AppUser.fromJson(vendorData);
      } else {
        throw Exception('Vendor data not found');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to fetch vendor data');
    }
  }

  Stream<List<Order>> get orderStream {
    var userId = _firebaseAuth.currentUser!.uid;

    return _database
        .ref()
        .child('vendorOrders')
        .child(userId)
        .onValue
        .map((event) {
      dynamic ordersMap = event.snapshot.value ?? {};
      List<Order> orders = [];
      ordersMap.forEach((key, value) {
        orders.add(Order.fromJson(Map<String, dynamic>.from(value)));
      });
      return orders;
    });
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
