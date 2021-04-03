import 'package:party/data/models/party.dart';

abstract class PartyRepository {
  List<Party> parties;
  Party currentParty;

  Stream<List<Party>> getAllParties();
  Stream<List<Party>> getPartiesMoreThanFourPeopleStream();
  Stream<List<Party>> getPartyDataForCreatedByUser(String userId);
  Stream<List<Party>> getPartyDataForAttendedByUser(
      List<dynamic> partyIds);

  Future<void> storePartyInACollection(Party party);
  Future<void> updatePartyImageUrl(String partyId, String downloadUrl);
  Future<void> AddPartyLikes(String partyId);
  Future<void> RemovePartyLikes(String partyId);
  Future<void> AddPartyPeopleComing();
  Future<void> RemovePartyPeopleComing();
}
