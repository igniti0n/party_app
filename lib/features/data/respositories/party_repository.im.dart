import 'package:party/features/data/datasources/FirebaseFirestoreService.dart';
import 'package:party/features/domain/repositories/no_params.dart';
import 'package:party/features/data/models/party.dart';
import 'package:party/core/failures/failure.dart';
import 'package:either_dart/src/either.dart';
import 'package:party/features/domain/repositories/party_repository.dart';

class PartyRepositoryIm extends PartyRepository {
  final FirebaseFirestoreService _firebaseFirestoreService;
  const PartyRepositoryIm(this._firebaseFirestoreService);

  @override
  Future<Either<Failure, NoParams>> AddPartyLikes(String partyId) {
    // TODO: implement AddPartyLikes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NoParams>> AddPartyPeopleComing(String partyId) {
    // TODO: implement AddPartyPeopleComing
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NoParams>> RemovePartyLikes(String partyId) {
    // TODO: implement RemovePartyLikes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NoParams>> RemovePartyPeopleComing(String partyId) {
    // TODO: implement RemovePartyPeopleComing
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, List<Party>>> getAllParties() {
    // TODO: implement getAllParties
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, List<Party>>> getPartiesMoreThanNumberOfPeopleStream(
      int numberOfPeople) {
    // TODO: implement getPartiesMoreThanNumberOfPeopleStream
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, List<Party>>> getPartyDataForAttendedByUser(
      List partyIds) {
    // TODO: implement getPartyDataForAttendedByUser
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, List<Party>>> getPartyDataForCreatedByUser(
      String userId) {
    // TODO: implement getPartyDataForCreatedByUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NoParams>> storePartyInACollection(Party party) {
    // TODO: implement storePartyInACollection
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NoParams>> updatePartyImageUrl(
      String partyId, String downloadUrl) {
    // TODO: implement updatePartyImageUrl
    throw UnimplementedError();
  }
}
