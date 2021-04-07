import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/data/models/party.dart';
import 'package:party/features/domain/repositories/no_params.dart';
import 'package:party/features/domain/repositories/user_repository.dart';

class RemoveUserFriends {
  final UserRepository _userRepository;

  const RemoveUserFriends(this._userRepository);

  Future<Either<Failure, NoParams>> call(String friendId) {
    return _userRepository.updateRemoveUserFriends(friendId);
  }
}
