import 'package:party/data/models/user.dart';

abstract class UserRepository {
  User currentUser;

  Stream<User> gettUserStream(String uid);

  Future<User> getUserData(String udi);
  Future<void> updateAddUserAttendedParties(String partyId);
  Future<void> updateRemoveUserAttendedParties(String partyId);
  Future<void> updateAddUserFriends(String firendId);
  Future<void> updateRemoveUserFriends(String friendId);
  Future<void> updateAddUserFriendRequest(String userToBeSent);
  Future<void> updateRemoveUserFriendRequest(String userToBeSent);
  Future<void> updateAddUserCreatedParties(String partyId);
  Future<void> updateRemoveUserCreatedParties(String partyId);
}
