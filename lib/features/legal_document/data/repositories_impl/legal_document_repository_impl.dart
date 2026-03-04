import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_catalog_system/core/domain/entities/page/page_entry.dart';
import 'package:multi_catalog_system/core/domain/entities/page/pagination_entry.dart';
import 'package:multi_catalog_system/core/error/exception_mapper.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';
import 'package:multi_catalog_system/core/error/failures.dart';
import 'package:multi_catalog_system/features/legal_document/data/data_sources/legal_document_remote_data_source.dart';
import 'package:multi_catalog_system/features/legal_document/data/models/legal_document_model.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
import 'package:multi_catalog_system/features/legal_document/domain/domain.dart';

class LegalDocumentRepositoryImpl implements LegalDocumentRepository {
  final LegalDocumentRemoteDataSource remoteDataSource;

  LegalDocumentRepositoryImpl({required this.remoteDataSource});

  LegalDocumentEntry _toEntity(LegalDocumentModel model) => LegalDocumentEntry(
    id: model.id,
    code: model.code,
    title: model.title,
    description: model.description,
    type: model.type,
    status: model.status,
    issuedByName: model.issuedByName,
    issueDate: model.issueDate,
    effectiveDate: model.effectiveDate,
    expiryDate: model.expiryDate,
    fileName: model.fileName,
    fileUrl: model.fileUrl,
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
  );

  Map<String, dynamic> _createPayload(LegalDocumentEntry entry) => {
    'code': entry.code,
    'title': entry.title,
    if (entry.description != null) 'description': entry.description,
    'type': entry.type,
    'issue_date': entry.issueDate,
    'effective_date': entry.effectiveDate,
    if (entry.expiryDate != null) 'expiry_date': entry.expiryDate,
  };

  Map<String, dynamic> _updatePayload(LegalDocumentEntry entry) => {
    if (entry.code != null) 'code': entry.code,
    if (entry.title != null) 'title': entry.title,
    if (entry.description != null) 'description': entry.description,
    if (entry.type != null) 'type': entry.type,
    if (entry.issueDate != null) 'issue_date': entry.issueDate,
    if (entry.effectiveDate != null) 'effective_date': entry.effectiveDate,
    if (entry.expiryDate != null) 'expiry_date': entry.expiryDate,
  };

  @override
  Future<Either<Failure, LegalDocumentEntry>> create({
    required LegalDocumentEntry entry,
    PickedDocumentFile? file,
  }) async {
    try {
      final formData = FormData.fromMap(_createPayload(entry));

      if (file != null) {
        final multipartFile = kIsWeb
            ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
            : await MultipartFile.fromFile(
                file.file!.path,
                filename: file.name,
              );

        formData.files.add(MapEntry('file', multipartFile));
      }

      final model = await remoteDataSource.create(data: formData);
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LegalDocumentEntry>> getById({
    required String id,
  }) async {
    try {
      final model = await remoteDataSource.getById(id: id);
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PageEntry<LegalDocumentEntry>>> getAll({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
    Map<String, dynamic>? filter,
  }) async {
    try {
      final models = await remoteDataSource.getAll(
        search: search,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sort: sort,
        filter: filter,
      );
      return Right(
        PageEntry<LegalDocumentEntry>(
          entries: models.data.map((m) => _toEntity(m)).toList(),
          pagination: PaginationEntry(
            page: models.pagination.page,
            limit: models.pagination.limit,
            total: models.pagination.total,
            totalPages: models.pagination.totalPages,
            hasMore: models.pagination.hasMore,
          ),
        ),
      );
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PageEntry<LegalDocumentEntry>>> getAllHasFile({
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sort,
  }) async {
    try {
      final models = await remoteDataSource.getAllHasFile(
        search: search,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sort: sort,
      );
      return Right(
        PageEntry<LegalDocumentEntry>(
          entries: models.data.map((m) => _toEntity(m)).toList(),
          pagination: PaginationEntry(
            page: models.pagination.page,
            limit: models.pagination.limit,
            total: models.pagination.total,
            totalPages: models.pagination.totalPages,
            hasMore: models.pagination.hasMore,
          ),
        ),
      );
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LegalDocumentEntry>> update({
    required LegalDocumentEntry entry,
    PickedDocumentFile? file,
  }) async {
    try {
      final formData = FormData.fromMap(_updatePayload(entry));

      if (file != null) {
        final multipartFile = kIsWeb
            ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
            : await MultipartFile.fromFile(
                file.file!.path,
                filename: file.name,
              );

        formData.files.add(MapEntry('file', multipartFile));
      }

      final model = await remoteDataSource.update(
        id: entry.id!,
        data: formData,
      );
      return Right(_toEntity(model));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete({required String id}) async {
    try {
      await remoteDataSource.delete(id: id);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
