import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../values.dart';

// Controller for managing user profile information
class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;

  final Rx<String> _uid = "".obs;

  // Update the user ID and fetch user data
  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  // Fetch user data from Firestore
  getUserData() async {
    List<String> thumbnails = [];

    // Fetch videos uploaded by the user
    var myVideos = await firestore.collection('videos').where('uid', isEqualTo: _uid.value).get();

    // Extract thumbnail URLs from video documents
    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    // Fetch user document from Firestore
    DocumentSnapshot userDoc = await firestore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;

    // Extract user profile information
    String name = userData['name'];
    String profilePhoto = userData['profilePhoto'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    // Calculate total likes on user's videos
    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }

    // Fetch followers and following data from subcollections
    var followerDoc = await firestore.collection('users').doc(_uid.value).collection('followers').get();
    var followingDoc = await firestore.collection('users').doc(_uid.value).collection('following').get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    // Check if the current user is following the profile user
    firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    // Update the user data map and trigger a UI update
    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnails': thumbnails,
    };
    update();
  }

  // Toggle follow/unfollow status for a user
  followUser() async {
    var doc =
        await firestore.collection('users').doc(_uid.value).collection('followers').doc(authController.user.uid).get();

    // If not following, add follower and update followers count
    if (!doc.exists) {
      await firestore.collection('users').doc(_uid.value).collection('followers').doc(authController.user.uid).set({});
      await firestore.collection('users').doc(authController.user.uid).collection('following').doc(_uid.value).set({});
      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    }
    // If already following, remove follower and update followers count
    else {
      await firestore.collection('users').doc(_uid.value).collection('followers').doc(authController.user.uid).delete();
      await firestore.collection('users').doc(authController.user.uid).collection('following').doc(_uid.value).delete();
      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    // Toggle the isFollowing status and trigger a UI update
    _user.value.update('isFollowing', (value) => !value);
    update();
  }
}
