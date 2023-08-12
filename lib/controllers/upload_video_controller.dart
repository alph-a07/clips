import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

import '../models/video.dart';
import '../values.dart';

class UploadVideoController extends GetxController {
  // Compresses the video located at 'videoPath'.
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  // Uploads the compressed video to Firebase Storage and returns its download URL.
  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // Retrieves the thumbnail for the video located at 'videoPath'.
  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  // Uploads the video thumbnail image to Firebase Storage and returns its download URL.
  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // Uploads a video along with its details to the Firestore database.
  void uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      // Get user information from Firestore.
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();

      // Get the total number of existing videos to create a new ID.
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;

      // Upload the compressed video and thumbnail to Firebase Storage.
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      // Create a Video object with the provided information.
      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnail,
      );

      // Store the video details in Firestore.
      await firestore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );

      // Navigate back to the previous screens.
      Get.back();
      Get.back();

      // Show a success message.
      Get.snackbar('Task finished', 'Video successfully uploaded.');
    } catch (e) {
      // Show an error message if video upload fails.
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }
}
