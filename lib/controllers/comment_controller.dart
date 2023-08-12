import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/comment.dart';
import '../values.dart';

// Controller for managing comments related logic
class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]); // Reactive list of comments
  List<Comment> get comments => _comments.value; // Getter for comments list

  String _postId = ""; // Currently displayed post ID

  // Update the post ID and fetch associated comments
  void updatePostId(String id) {
    _postId = id;
    getComment();
  }

  // Fetch comments for the current post ID from Firestore
  void getComment() async {
    _comments.bindStream(
      // Create a stream from Firestore snapshots
      firestore.collection('videos').doc(_postId).collection('comments').snapshots().map(
        (QuerySnapshot query) {
          List<Comment> retValue = [];
          for (var element in query.docs) {
            retValue.add(Comment.fromSnap(element)); // Convert Firestore data to Comment objects
          }
          return retValue;
        },
      ),
    );
  }

  // Post a comment to the current post
  void postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        // Retrieve user information
        DocumentSnapshot userDoc = await firestore.collection('users').doc(authController.user.uid).get();

        // Retrieve all comments for the post
        var allDocs = await firestore.collection('videos').doc(_postId).collection('comments').get();
        int len = allDocs.docs.length; // Total comment count

        // Create a new Comment object
        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
          uid: authController.user.uid,
          id: 'Comment $len',
        );

        // Add the new comment to Firestore
        await firestore.collection('videos').doc(_postId).collection('comments').doc('Comment $len').set(
              comment.toJson(),
            );

        // Update the comment count for the post
        DocumentSnapshot doc = await firestore.collection('videos').doc(_postId).get();
        await firestore.collection('videos').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      // Display error message
      Get.snackbar(
        'Error While Commenting',
        e.toString(),
      );
    }
  }

  // Toggle like for a comment
  void likeComment(String id) async {
    var uid = authController.user.uid;

    // Fetch the comment's document from Firestore
    DocumentSnapshot doc = await firestore.collection('videos').doc(_postId).collection('comments').doc(id).get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      // Remove user's like
      await firestore.collection('videos').doc(_postId).collection('comments').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      // Add user's like
      await firestore.collection('videos').doc(_postId).collection('comments').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
