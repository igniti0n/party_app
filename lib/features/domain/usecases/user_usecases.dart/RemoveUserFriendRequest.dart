import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/data/models/party.dart';
import 'package:party/features/domain/repositories/party_repository.dart';

class RemoveUserFriendRequest {
  final PartyRepository _partyRepository;

  const RemoveUserFriendRequest(this._partyRepository);

  Stream<Either<Failure, List<Party>>> call() {
    return null;
  }
}
