import 'package:clips/views/screens/add_video_screen.dart';
import 'package:clips/views/screens/profile_screen.dart';
import 'package:clips/views/screens/search_screen.dart';
import 'package:clips/views/screens/video_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';

// COLORS
const backgroundColor = Colors.black;
const buttonColor = Color.fromARGB(255, 253, 134, 0);
const borderColor = Colors.grey;

// STRINGS
const appTitle = 'Clips';

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;

List pages = [
  VideoScreen(),
  SearchScreen(),
  AddVideoScreen(),
  ProfileScreen(uid: authController.user.uid),
];
