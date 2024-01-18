import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepository {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('User Information');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addUserInformation(String uid, String firstName, String lastName, String matricNumber, String email) async {
    await userCollection.doc(uid).set({
      'FirstName': firstName,
      'LastName': lastName,
      'matricNumber': matricNumber,
      'email': email,
    });
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      DocumentSnapshot userDoc = await userCollection.doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
    return null;
  }

  Future<void> updateUser(String uid, String FirstName, String LastName, String matricNumber, String email) async {
    try {
      await userCollection.doc(uid).update({
        'FirstName': FirstName,
        'LastName': LastName,
        'matricNumber': matricNumber,
        'email': email,
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUserInfoWithImage(String uid, String firstName, String lastName, String matricNumber, String email, String imageUrl) async {
    try {
      await userCollection.doc(uid).update({
        'FirstName': firstName,
        'LastName': lastName,
        'matricNumber': matricNumber,
        'email': email,
        'imageUrl': imageUrl,
      });
    } catch (error) {
      throw error;
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      final uid = _auth.currentUser?.uid;

      if (uid != null) {
        final storage = FirebaseStorage.instance;
        final ref = storage.ref().child('profile_images/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(imageFile);
        final imageUrl = await ref.getDownloadURL();

        // Return the download URL
        return imageUrl;
      } else {
        throw FirebaseAuthException(code: 'user-not-found', message: 'User not authenticated');
      }
    } catch (error) {
      throw error;
    }
  }



  Future<void> updatePassword(String currentPassword, String newPassword) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final credential = EmailAuthProvider.credential(email: currentUser.email!, password: currentPassword);
        await currentUser.reauthenticateWithCredential(credential);
        await currentUser.updatePassword(newPassword);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> _updatePassword(String password) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updatePassword(password);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> isMatricNumberTaken(String matricNumber) async {
    try {
      QuerySnapshot querySnapshot = await userCollection.where('matricNumber', isEqualTo: matricNumber).get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      throw error;
    }
  }
  Future<bool> isEmailRegistered(String email) async {
  try {
    QuerySnapshot querySnapshot = await userCollection.where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  } catch (error) {
    throw error;
  }
}


  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print('Error signing out: $error');
      throw error;
    }
  }
}

