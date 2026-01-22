import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/features/profile/domain/repositories/user_repository.dart';

class GetMeUseCase {
  final UserRepository repository;

  GetMeUseCase({required this.repository});

  Future<Either<Failure, UserEntry>> call() {
    return repository.getMe();
  }
}
