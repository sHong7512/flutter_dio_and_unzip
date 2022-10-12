import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio_and_unzip/data/Repository.dart';
import 'package:dio_and_unzip/model/content_detail.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileDownUnzip {
  String? _getFileNameWithoutExtensionSync(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      return basenameWithoutExtension(file.path);
    } else {
      return null;
    }
  }

  Future<String?> _unzipUnderDirectory(
    String zipFilePath,
    Function(int, int) unzipProgress,
  ) async {
    var fileName = _getFileNameWithoutExtensionSync(zipFilePath);
    if (fileName == null) return null;

    var zipPath = zipFilePath.substring(0, zipFilePath.lastIndexOf('/'));
    var destPath = '$zipPath/$fileName';
    final zipFile = await File(zipFilePath).readAsBytes();

    log('$zipFilePath\n$zipPath\n$destPath');

    final archive = ZipDecoder().decodeBytes(zipFile);
    final totalCount = archive.length;
    int archiveCount = 0;

    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        var filePoint = File('$destPath/$filename');
        await filePoint.create(recursive: true);
        await filePoint.writeAsBytes(data);
      } else {
        var directoryPoint = Directory('$destPath/$filename');
        await directoryPoint.create(recursive: true);
      }
      archiveCount++;
      unzipProgress(archiveCount, totalCount);
    }
    return destPath;
  }

  Future<ContentDetail?> getFileAndUnzip({
    required Function(int, int) downloadProgress,
    required Function(int, int) unzipProgress,
    required String contentURL,
  }) async {
    try {
      // file Path
      var tempDir = await getApplicationDocumentsDirectory();
      int lastIndex = contentURL.lastIndexOf('/') + 1;
      var fileName = contentURL.substring(lastIndex, contentURL.length);
      String zipPath = "${tempDir.path}/$fileName";

      // content download
      final downloadOk = await Repository.downloadZipFile(
        contentURL,
        zipPath,
        downloadProgress,
      );
      log('DownLoad Complete!');
      final directoryPath = await _unzipUnderDirectory(zipPath, unzipProgress);
      log('UnZip Complete!');

      if (downloadOk && directoryPath != null) {
        return ContentDetail(
          detailName: fileName,
          zipPath: zipPath,
          directoryPath: directoryPath,
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
