import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/domain/repositories/no_params.dart';

import '../../data/models/user.dart';

abstract class UserRepository {
  const UserRepository();

  Stream<Either<Failure, User>> gettUserStream(String uid);
  Future<Either<Failure, User>> getUserData(String udi);

  Future<Either<Failure, NoParams>> updateAddUserAttendedParties(
      String partyId);
  Future<Either<Failure, NoParams>> updateRemoveUserAttendedParties(
      String partyId);
  Future<Either<Failure, NoParams>> updateAddUserFriends(String firendId);
  Future<Either<Failure, NoParams>> updateRemoveUserFriends(String friendId);
  Future<Either<Failure, NoParams>> updateAddUserFriendRequest(
      String userToBeSent, List<String> userToBeSentFriendReq);
  Future<Either<Failure, NoParams>> updateRemoveUserFriendRequest(
     String userToBeSent, List<String> userToBeSentFriendReq);
  Future<Either<Failure, NoParams>> updateAddUserCreatedParties(String partyId);
  Future<Either<Failure, NoParams>> updateRemoveUserCreatedParties(
      String partyId);
}
