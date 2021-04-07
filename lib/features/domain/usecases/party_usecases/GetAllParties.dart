import 'package:either_dart/either.dart';

import '../../../../core/failures/failure.dart';
import '../../../data/models/party.dart';
import '../../repositories/party_repository.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class GetAllPartiesUsecase {
  final PartyRepository _partyRepository;

  const GetAllPartiesUsecase(this._partyRepository);

  Stream<Either<Failure, List<Party>>> call() {
    return _partyRepository.getAllParties();
  }
}
