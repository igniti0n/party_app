import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/data/models/party.dart';
import 'package:party/features/domain/repositories/no_params.dart';
import 'package:party/features/domain/repositories/user_repository.dart';

class AddUserFriendRequest {
  final UserRepository _userRepository;

  const AddUserFriendRequest(this._userRepository);

  Future<Either<Failure, NoParams>> call(
      String userToBeSent, List<String> userToBeSentFriendReq) {
    return _userRepository.updateAddOtherUserFriendRequest(
        userToBeSent, userToBeSentFriendReq);
  }
}
