import 'dart:developer';

import 'package:party/core/failures/server_failure.dart';
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
  Future<Either<Failure, NoParams>> addPartyLikes(
      String partyId, List<String> partyLikes) async {
    return updatePartyLikes(partyId, partyLikes);
  }

  @override
  Future<Either<Failure, NoParams>> removePartyLikes(
      String partyId, List<String> partyLikes) async {
    return updatePartyLikes(partyId, partyLikes);
  }

  Future<Either<Failure, NoParams>> updatePartyLikes(
      String partyId, List<String> partyLikes) async {
    try {
      await _firebaseFirestoreService.updatePartyLikes(
        partyId,
        partyLikes,
      );
      return Right(NoParams());
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> addPartyPeopleComing(
      String partyId, List<String> peopleComing) async {
    return updatePartyPeopleComing(
      partyId,
      peopleComing,
    );
  }

  @override
  Future<Either<Failure, NoParams>> removePartyPeopleComing(
    String partyId,
    List<String> peopleComing,
  ) async {
    return updatePartyPeopleComing(
      partyId,
      peopleComing,
    );
  }

  Future<Either<Failure, NoParams>> updatePartyPeopleComing(
    String partyId,
    List<String> peopleComing,
  ) async {
    try {
      await _firebaseFirestoreService.updatePartyPeopleComing(
        partyId,
        peopleComing,
      );
      return Right(NoParams());
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> storePartyInACollection(Party party) async {
    try {
      await _firebaseFirestoreService
          .storePartyInACollection(Party.toMap(party));
      return Right(NoParams());
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> updatePartyImageUrl(
      String partyId, String downloadUrl) async {
    try {
      await _firebaseFirestoreService.updatePartyImageUrl(partyId, downloadUrl);
      return Right(NoParams());
    } catch (error) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<Either<Failure, List<Party>>> getAllParties() {
    return _firebaseFirestoreService
        .getPartyDataStream()
        .map<Either<Failure, List<Party>>>(
            (List<Map<String, dynamic>> parties) => mapPartyStream(parties));
  }

  @override
  Stream<Either<Failure, List<Party>>> getPartiesMoreThanNumberOfPeopleStream(
      int numberOfPeople) {
    return _firebaseFirestoreService
        .getPartyDataMoreThanNumberOfPeopleStream(numberOfPeople)
        .map<Either<Failure, List<Party>>>(
            (List<Map<String, dynamic>> parties) => mapPartyStream(parties));
  }

  @override
  Stream<Either<Failure, List<Party>>> getPartyDataForAttendedByUser(
      List partyIds) {
    return _firebaseFirestoreService
        .getPartyDataForAttendedByUser(partyIds)
        .map<Either<Failure, List<Party>>>(
            (List<Map<String, dynamic>> parties) => mapPartyStream(parties));
  }

  @override
  Stream<Either<Failure, List<Party>>> getPartyDataForCreatedByUser(
      String userId) {
    return _firebaseFirestoreService
        .getPartyDataForCreatedByUser(userId)
        .map<Either<Failure, List<Party>>>(
            (List<Map<String, dynamic>> parties) => mapPartyStream(parties));
  }
}

Either<Failure, List<Party>> mapPartyStream(
    List<Map<String, dynamic>> parties) {
  if (parties == null) return Left(ServerFailure());
  final List<Party> _partyList = parties
      .map((Map<String, dynamic> party) => Party.fromMap(party)) as List<Party>;

  log("All parties stream:   ");
  log(_partyList.toString());
  return Right(_partyList);
}
