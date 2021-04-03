import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';

import '../../data/models/user.dart';

abstract class UserRepository {
  User currentUser;

  Stream<Either<Failure, User>> gettUserStream(String uid);
  Future<Either<Failure, User>> getUserData(String udi);

  Future<void> updateAddUserAttendedParties(String partyId);
  Future<void> updateRemoveUserAttendedParties(String partyId);
  Future<void> updateAddUserFriends(String firendId);
  Future<void> updateRemoveUserFriends(String friendId);
  Future<void> updateAddUserFriendRequest(String userToBeSent);
  Future<void> updateRemoveUserFriendRequest(String userToBeSent);
  Future<void> updateAddUserCreatedParties(String partyId);
  Future<void> updateRemoveUserCreatedParties(String partyId);
}
