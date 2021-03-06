import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/data/models/party.dart';
import 'package:party/features/domain/repositories/party_repository.dart';

class GetAllPartiesCreatedByUser {
  final PartyRepository _partyRepository;

  const GetAllPartiesCreatedByUser(this._partyRepository);

  Stream<Either<Failure, List<Party>>> call(String userId) {
    return _partyRepository.getPartyDataForCreatedByUser(userId);
  }
}
