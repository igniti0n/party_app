import 'package:either_dart/either.dart';
import 'package:party/features/domain/repositories/party_repository.dart';

import '../../../../core/failures/failure.dart';
import '../../../data/models/party.dart';

class GetAllPartiesUsecase {
  final PartyRepository _partyRepository;

  const GetAllPartiesUsecase(this._partyRepository);

  Stream<Either<Failure, List<Party>>> call() {
    return null;
  }
}
