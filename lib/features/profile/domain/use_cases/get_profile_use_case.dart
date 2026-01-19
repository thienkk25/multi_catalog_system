import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/core/domain/entities/auth/user_entry.dart';
import 'package:multi_catalog_system/features/profile/domain/repositories/user_repository.dart';

class GetProfileUseCase {
  final UserRepository repository;
  GetProfileUseCase({required this.repository});
  Future<Either<Failure, UserEntry>> call() async {
    return repository.getProfile();
  }
}
