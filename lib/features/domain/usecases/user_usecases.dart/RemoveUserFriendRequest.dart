import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/data/models/party.dart';
import 'package:party/features/domain/repositories/no_params.dart';
import 'package:party/features/domain/repositories/user_repository.dart';

class RemoveUserFriendRequest {
  final UserRepository _userRepository;

  const RemoveUserFriendRequest(this._userRepository);

  Future<Either<Failure, NoParams>> call(
      String userToBeSent, List<String> userToBeSentFriendReq) {
    return _userRepository.updateRemoveUserFriendRequest(
        userToBeSent, userToBeSentFriendReq);
  }
}
