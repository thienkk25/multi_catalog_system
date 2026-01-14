import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/profile/domain/entities/user_entry.dart';
import 'package:multi_catalog_system/features/profile/domain/repositories/user_repository.dart';

class UpdateProfileUseCase {
  final UserRepository repository;

  UpdateProfileUseCase({required this.repository});
  Future<Either<Failure, UserEntry>> call({required UserEntry entry}) async {
    return repository.updateProfile(entry: entry);
  }
}
