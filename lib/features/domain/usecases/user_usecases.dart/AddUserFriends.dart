import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/data/models/party.dart';
import 'package:party/features/domain/repositories/no_params.dart';
import 'package:party/features/domain/repositories/user_repository.dart';

class AddUserFriends {
  final UserRepository _userRepository;

  const AddUserFriends(this._userRepository);

  Future<Either<Failure, NoParams>> call(
    String friendId,
    List<String> friends,
  ) {
    return _userRepository.updateAddUserFriends(friendId, friends);
  }
}
