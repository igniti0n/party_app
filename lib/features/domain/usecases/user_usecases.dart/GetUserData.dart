import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/data/models/party.dart';
import 'package:party/features/data/models/user.dart';
import 'package:party/features/domain/repositories/no_params.dart';
import 'package:party/features/domain/repositories/user_repository.dart';

class GetUserData {
  final UserRepository _userRepository;
  const GetUserData(this._userRepository);

  Future<Either<Failure, User>> call(String uid) {
    return _userRepository.getUserData(uid);
  }
}
