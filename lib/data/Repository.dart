import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

class Repository {
  static Future<bool> downloadZipFile(
    String url,
    String filePath,
    Function(int, int) downloadProgress,
  ) async {
    try {
      Response response = await Dio().get(
        url,
        onReceiveProgress: downloadProgress,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      log('${response.headers}');

      File file = File(filePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();

      return true;
    } catch (e) {
      log('$e');
      return false;
    }
  }
}
