import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';

import '../../data/models/party.dart';

abstract class PartyRepository {
  List<Party> parties;
  Party currentParty;

  Stream<Either<Failure, List<Party>>> getAllParties();
  Stream<Either<Failure, List<Party>>> getPartiesMoreThanNumberOfPeopleStream(
      int numberOfPeople);
  Stream<Either<Failure, List<Party>>> getPartyDataForCreatedByUser(
      String userId);
  Stream<Either<Failure, List<Party>>> getPartyDataForAttendedByUser(
      List<dynamic> partyIds);

  Future<void> storePartyInACollection(Party party);
  Future<void> updatePartyImageUrl(String partyId, String downloadUrl);
  Future<void> AddPartyLikes(String partyId);
  Future<void> RemovePartyLikes(String partyId);
  Future<void> AddPartyPeopleComing();
  Future<void> RemovePartyPeopleComing();
}
