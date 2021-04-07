import 'package:either_dart/either.dart';
import 'package:party/core/failures/failure.dart';
import 'package:party/features/data/models/party.dart';
import 'package:party/features/data/models/user.dart';
import 'package:party/features/domain/repositories/user_repository.dart';

class GetUserStream {
  final UserRepository _userRepository;

  const GetUserStream(this._userRepository);

  Stream<Either<Failure, User>> call(String uid) {
    return _userRepository.getUserStream(uid);
  }
}
