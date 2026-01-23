import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';

abstract class ImportFileRemoteDataSource {
  Future<void> importSingleFile({
    required PickedDocumentFile file,
    required int type,
  });

  Future<void> importCatalogFile({required PickedDocumentFile file});
}

class ImportFileRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ImportFileRemoteDataSource {
  final Dio dio;

  ImportFileRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> importSingleFile({
    required PickedDocumentFile file,
    required int type,
  }) async {
    try {
      await dio.post('/import', data: {'file': file, 'type': type});
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> importCatalogFile({required PickedDocumentFile file}) async {
    try {
      await dio.post('/import', data: {'file': file});
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
