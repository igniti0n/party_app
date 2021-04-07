import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/domain/repositories/no_params.dart';

import '../../data/models/party.dart';

abstract class PartyRepository {
  // List<Party> parties;
  // Party currentParty;

  const PartyRepository();

  Stream<Either<Failure, List<Party>>> getAllParties();
  Stream<Either<Failure, List<Party>>> getPartiesMoreThanNumberOfPeopleStream(
      int numberOfPeople);
  Stream<Either<Failure, List<Party>>> getPartyDataForCreatedByUser(
      String userId);
  Stream<Either<Failure, List<Party>>> getPartyDataForAttendedByUser(
      List<dynamic> partyIds);

  Future<Either<Failure, NoParams>> storePartyInACollection(Party party);
  Future<Either<Failure, NoParams>> updatePartyImageUrl(
      String partyId, String downloadUrl);
  Future<Either<Failure, NoParams>> AddPartyLikes(String partyId);
  Future<Either<Failure, NoParams>> RemovePartyLikes(String partyId);
  Future<Either<Failure, NoParams>> AddPartyPeopleComing(String partyId);
  Future<Either<Failure, NoParams>> RemovePartyPeopleComing(String partyId);
}
