import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/domain/repositories/no_params.dart';

import '../../data/models/user.dart';

abstract class UserRepository {
  const UserRepository();

  Stream<Either<Failure, User>> getUserStream(String uid);
  Future<Either<Failure, User>> getUserData(String udi);

  Future<Either<Failure, NoParams>> updateAddUserAttendedParties(
      String partyId);
  Future<Either<Failure, NoParams>> updateRemoveUserAttendedParties(
      String partyId);
  Future<Either<Failure, NoParams>> updateAddUserFriends(
    String firendId,
    List<String> friends,
  );
  Future<Either<Failure, NoParams>> updateRemoveUserFriends(
    String friendId,
    List<String> friends,
  );
  Future<Either<Failure, NoParams>> updateAddOtherUserFriendRequest(
      String userToBeSent, List<String> userToBeSentFriendReq);
  Future<Either<Failure, NoParams>> updateRemoveOtherUserFriendRequest(
      String userToBeSent);
  Future<Either<Failure, NoParams>> updateAddUserCreatedParties(String partyId);
  Future<Either<Failure, NoParams>> updateRemoveUserCreatedParties(
      String partyId);
}
