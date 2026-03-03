import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:multi_catalog_system/core/config/networks/base_remote_data_source.dart';
import 'package:multi_catalog_system/core/error/exceptions.dart';

import 'package:multi_catalog_system/core/config/app/export_downloader_mobile.dart'
    if (dart.library.html) 'package:multi_catalog_system/core/config/app/export_downloader_web.dart';

abstract class ExportFileRemoteDataSource {
  Future<void> exportCatalogFile({String? format});

  Future<void> exportSingleFile({required int type, String? format});
}

class ExportFileRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ExportFileRemoteDataSource {
  final Dio dio;

  ExportFileRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> exportCatalogFile({String? format}) async {
    try {
      Map<String, dynamic>? queryParameters;

      if (format != null) {
        queryParameters = {'format': format};
      }
      final response = await dio.get(
        '/export/catalog',
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = Uint8List.fromList(response.data);

      // Lấy filename từ header nếu có
      final disposition = response.headers.value('content-disposition');

      String fileName = 'export.${format ?? 'xlsx'}';

      if (disposition != null) {
        final regex = RegExp(r'filename="?(.+)"?');
        final match = regex.firstMatch(disposition);
        if (match != null) {
          fileName = match.group(1)!;
        }
      }

      await downloadFile(bytes, fileName);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<void> exportSingleFile({required int type, String? format}) async {
    try {
      Map<String, dynamic> queryParameters = {'type': type};

      if (format != null) {
        queryParameters.addAll({'format': format});
      }
      final response = await dio.get(
        '/export/single',
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = Uint8List.fromList(response.data);

      // Lấy filename từ header nếu có
      final disposition = response.headers.value('content-disposition');

      String fileName = 'export.${format ?? 'xlsx'}';

      if (disposition != null) {
        final regex = RegExp(r'filename="?(.+)"?');
        final match = regex.firstMatch(disposition);
        if (match != null) {
          fileName = match.group(1)!;
        }
      }

      await downloadFile(bytes, fileName);
    } on DioException catch (e) {
      handleDioError(e);
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
