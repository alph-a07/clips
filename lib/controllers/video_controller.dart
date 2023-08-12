import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/video.dart';
import '../values.dart';

// VideoController class manages video-related functionality
class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();

    // Bind the stream of video data from Firestore to _videoList
    _videoList.bindStream(firestore.collection('videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];

      // Iterate through each document in the query result
      for (var element in query.docs) {
        // Create a Video object from the document snapshot and add to the list
        retVal.add(
          Video.fromSnap(element),
        );
      }
      return retVal;
    }));
  }

  // Toggle the like status of a video with the given id
  likeVideo(String id) async {
    // Retrieve the document snapshot for the video
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;

    // Check if the user's ID is already in the 'likes' array
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      // If user already liked, remove the user's ID from 'likes'
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      // If user hasn't liked yet, add the user's ID to 'likes'
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
