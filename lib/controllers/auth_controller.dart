import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart' as model;
import '../values.dart';
import '../views/screens/auth/login.dart';
import '../views/screens/home.dart';

class AuthController extends GetxController {
  // Singleton instance of AuthController
  static AuthController instance = Get.find();

  late Rx<User?> _user; // Reactive variable for user
  late Rx<File?> _pickedImage = Rx<File?>(null); // Reactive variable for picked image

  File? get profilePhoto => _pickedImage.value; // Getter for profile photo

  User get user => _user.value!; // Getter for user

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser); // Initialize user reactive variable
    _user.bindStream(firebaseAuth.authStateChanges()); // Bind user stream
    ever(_user, _setInitialScreen); // Execute _setInitialScreen when user changes
  }

  // Set initial screen based on user status
  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen()); // Navigate to LoginScreen
    } else {
      Get.offAll(() => const HomeScreen()); // Navigate to HomeScreen
    }
  }

  // Pick an image from the gallery
  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture', 'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  // Upload image to Firebase storage and return download URL
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage.ref().child('profilePics').child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // Register a new user
  void registerUser(String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && image != null) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(name: username, email: email, uid: cred.user!.uid, profilePhoto: downloadUrl);
        await firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
      } else {
        Get.snackbar('Error Creating Account', 'Please enter all the fields');
      }
    } catch (e) {
      Get.snackbar('Error Creating Account', e.toString());
    }
  }

  // Log in user
  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        Get.snackbar('Error Logging in', 'Please enter all the fields');
      }
    } catch (e) {
      Get.snackbar('Error Logging in', e.toString());
    }
  }

  // Sign out user
  void signOut() async {
    await firebaseAuth.signOut();
  }
}
