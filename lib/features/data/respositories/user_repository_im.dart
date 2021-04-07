import 'package:party/core/failures/server_failure.dart';
import 'package:party/features/data/datasources/FirebaseFirestoreService.dart';
import 'package:party/features/domain/repositories/no_params.dart';
import 'package:party/features/data/models/user.dart';
import 'package:party/core/failures/failure.dart';
import 'package:either_dart/src/either.dart';
import 'package:party/features/domain/repositories/user_repository.dart';

class UserRepositoryImplementation extends UserRepository {
  final User _currentUser;
  final FirebaseFirestoreService _firebaseFirestoreService;

  const UserRepositoryImplementation(
      this._currentUser, this._firebaseFirestoreService);

  @override
  Future<Either<Failure, User>> getUserData(String uid) async {
    try {
      final User res = await _firebaseFirestoreService.getUserData(uid);
      return Right(res);
    } catch (err) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<Either<Failure, User>> getUserStream(String uid) {
    return _firebaseFirestoreService.getUserDataStream(_currentUser.uid);
  }

  @override
  Future<Either<Failure, NoParams>> updateAddUserAttendedParties(
      String partyId) async {
    try {
      _currentUser.attendedPartyIds.add(partyId);
      await _firebaseFirestoreService.updateUserAttendedParties(
        _currentUser.uid,
        _currentUser.attendedPartyIds,
      );
      return Right(NoParams());
    } catch (err) {
      _currentUser.attendedPartyIds.removeLast();
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> updateAddUserCreatedParties(
      String partyId) async {
    try {
      _currentUser.createdPartyIds.add(partyId);
      await _firebaseFirestoreService.updateUserCreatedParties(
        _currentUser.attendedPartyIds,
        _currentUser.uid,
      );
      return Right(NoParams());
    } catch (err) {
      _currentUser.createdPartyIds.removeLast();
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> updateAddOtherUserFriendRequest(
      String userToBeSent, List<String> friendReq) async {
    try {
      friendReq.add(_currentUser.uid);
      await _firebaseFirestoreService.updateUserFriendRequest(
        userToBeSent,
        friendReq,
      );
      return Right(NoParams());
    } catch (err) {
      friendReq.removeLast();
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> updateAddUserFriends(
    String firendId,
    List<String> friends,
  ) async {
    try {
      //UPDATE BOTH USERS FRIENDS !!!!
      if (!_currentUser.friends.contains(firendId)) {
        _currentUser.friends.add(firendId);
        await _firebaseFirestoreService.updateUserFriends(
            userTobeSent: _currentUser.uid, value: _currentUser.friends);
      }

      if (!friends.contains(_currentUser.uid)) {
        friends.add(_currentUser.uid);
        await _firebaseFirestoreService.updateUserFriends(
            userTobeSent: firendId, value: friends);
      }

      return Right(NoParams());
    } catch (err) {
      _currentUser.friends.removeWhere((element) => element == firendId);
      friends.removeWhere((element) => element == _currentUser.uid);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> updateRemoveUserFriends(
    String friendId,
    List<String> friends,
  ) async {
    try {
      //UPDATE BOTH USERS FRIENDS !!!!
      if (_currentUser.friends.contains(friendId)) {
        _currentUser.friends.remove(friendId);
        await _firebaseFirestoreService.updateUserFriends(
            userTobeSent: _currentUser.uid, value: _currentUser.friends);
      }

      if (friends.contains(_currentUser.uid)) {
        friends.remove(_currentUser.uid);
        await _firebaseFirestoreService.updateUserFriends(
            userTobeSent: friendId, value: friends);
      }

      return Right(NoParams());
    } catch (err) {
      _currentUser.friends.add(friendId);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> updateRemoveUserAttendedParties(
      String partyId) async {
    try {
      _currentUser.attendedPartyIds
          .removeWhere((element) => element.toString() == partyId);
      await _firebaseFirestoreService.updateUserAttendedParties(
          _currentUser.uid, _currentUser.attendedPartyIds);
      return Right(NoParams());
    } catch (err) {
      _currentUser.attendedPartyIds.add(partyId);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> updateRemoveUserCreatedParties(
      String partyId) async {
    try {
      _currentUser.createdPartyIds
          .removeWhere((element) => element.toString() == partyId);
      await _firebaseFirestoreService.updateUserCreatedParties(
        _currentUser.attendedPartyIds,
        _currentUser.uid,
      );
      return Right(NoParams());
    } catch (err) {
      _currentUser.createdPartyIds.add(partyId);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> updateRemoveOtherUserFriendRequest(
    String userToBeSent,
  ) async {
    try {
      _currentUser.friendRequests
          .removeWhere((element) => element == userToBeSent);
      await _firebaseFirestoreService.updateUserFriendRequest(
        userToBeSent,
        _currentUser.friendRequests,
      );
      return Right(NoParams());
    } catch (err) {
      _currentUser.friendRequests.add(userToBeSent);
      return Left(ServerFailure());
    }
  }
}
