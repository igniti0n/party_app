import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/data/models/party.dart';
import 'package:party/features/domain/repositories/no_params.dart';
import 'package:party/features/domain/repositories/party_repository.dart';

class RemovePartyPeopleComming {
  final PartyRepository _partyRepository;

  const RemovePartyPeopleComming(this._partyRepository);

  Future<Either<Failure, NoParams>> call(String partyId) {
    return _partyRepository.RemovePartyPeopleComing(partyId);
  }
}
