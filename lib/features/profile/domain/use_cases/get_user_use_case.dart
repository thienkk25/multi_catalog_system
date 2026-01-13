import 'package:dartz/dartz.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/profile/domain/entities/user_entry.dart';
import 'package:multi_catalog_system/features/profile/domain/repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository repository;
  GetUserUseCase({required this.repository});
  Future<Either<Failure, UserEntry>> call() async {
    return repository.getUser();
  }
}
