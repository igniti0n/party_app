import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/data/models/party.dart';
import 'package:party/features/domain/repositories/party_repository.dart';

class GetAllPartiesAttendedByUser {
  final PartyRepository _partyRepository;

  const GetAllPartiesAttendedByUser(this._partyRepository);

  Stream<Either<Failure, List<Party>>> call(List<String> partyIds) {
    return _partyRepository.getPartyDataForAttendedByUser(partyIds);
  }
}
