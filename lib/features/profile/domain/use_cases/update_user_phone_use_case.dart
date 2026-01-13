import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/profile/domain/entities/user_entry.dart';
import 'package:multi_catalog_system/features/profile/domain/repositories/user_repository.dart';

class UpdateUserPhoneUseCase {
  final UserRepository repository;

  UpdateUserPhoneUseCase({required this.repository});
  Future<Either<Failure, UserEntry>> call({required UserEntry entry}) async {
    return repository.updatePhone(entry: entry);
  }
}
