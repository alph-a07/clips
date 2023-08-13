import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import '../values.dart';

// Controller for handling user search functionality
class SearchController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);

  // Getter for the list of searched users
  List<User> get searchedUsers => _searchedUsers.value;

  // Function to search for users based on typed input
  void searchUser(String typedUser) async {
    // Bind the user search stream to the Firestore collection
    _searchedUsers.bindStream(
      firestore.collection('users').where('name', isGreaterThanOrEqualTo: typedUser).snapshots().map(
        (QuerySnapshot query) {
          List<User> retVal = [];
          for (var elem in query.docs) {
            // Convert Firestore data into User objects
            retVal.add(User.fromSnap(elem));
          }
          return retVal;
        },
      ),
    );
  }
}
