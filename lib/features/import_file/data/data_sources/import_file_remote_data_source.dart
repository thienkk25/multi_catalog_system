import 'package:dio/dio.dart';
import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/data/models/picked_document_file/picked_document_file.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';

abstract class ImportFileRemoteDataSource {
  Future<void> importFile({
    required List<PickedDocumentFile> files,
    required String table,
  });
}

class ImportFileRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ImportFileRemoteDataSource {
  final Dio dio;

  ImportFileRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> importFile({
    required List<PickedDocumentFile> files,
    required String table,
  }) async {
    try {
      await dio.post('/csv/', data: {'files': files, 'table': table});
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
