import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/data/models/party.dart';
import 'package:party/features/domain/repositories/no_params.dart';
import 'package:party/features/domain/repositories/party_repository.dart';

class AddPartyPeopleComming {
  final PartyRepository _partyRepository;

  const AddPartyPeopleComming(this._partyRepository);

  Future<Either<Failure, NoParams>> call(
      String partyId, List<String> peopleComing) {
    return _partyRepository.addPartyLikes(partyId, peopleComing);
  }
}
