import 'package:dio_and_unzip/screen/download_icon.dart';
import 'package:dio_and_unzip/utils/file_down_unzip.dart';
import 'package:dio_and_unzip/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

// TODO ZipFileURL 넣어줘야함
// 토모 홈스쿨 데모용 : 'http://125.138.183.228/nuri/contents/B2B/2023_tomohome/imagineobject.zip'
const String ZipFileURL = '{Zip File URL}';
const String ImagePath = 'assets/images/zip_image.png';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FileDownUnzip fileDownUnzip = FileDownUnzip();
  bool isStartDown = false;
  bool isDownUnzipOk = false;
  double progressValue = 0;
  double downValue = 0;
  double unzipValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: GestureDetector(
        onTap: () async {
          if (isStartDown) return;
          isStartDown = true;

          downloadProgress(received, total) {
            setState(() {
              if (total >= 0) downValue = received / total;
              progressValue = (downValue + unzipValue) / 2;
            });
          }

          unzipProgress(received, total) {
            setState(() {
              if (total >= 0) unzipValue = received / total;
              progressValue = (downValue + unzipValue) / 2;
            });
          }

          final result = await fileDownUnzip.getFileAndUnzip(
            downloadProgress: downloadProgress,
            unzipProgress: unzipProgress,
            contentURL: ZipFileURL,
          );

          if (result != null) {
            showSnackBar('다운로드가 완료되었습니다.');
            setState(() {
              isDownUnzipOk = true;
            });
          } else {
            showSnackBar('다운로드가 실패하였습니다.');
          }

          isStartDown = false;
        },
        child: Center(child: body()),
      ),
    );
  }

  Widget body() {
    return Container(
      width: 200,
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          switchedImage(),
          if (!isDownUnzipOk) progress(),
          if (!isDownUnzipOk)
            Align(
              alignment: Alignment.bottomRight,
              child: DownloadIcon(
                edgeInsetsGeometry: EdgeInsets.all(15),
                color: Colors.white,
                size: 30,
              ),
            ),
        ],
      ),
    );
  }

  Widget progress() {
    final ts = TextStyle(color: Colors.white);
    return Stack(
      children: [
        LiquidLinearProgressIndicator(
          direction: Axis.vertical,
          value: 1 - progressValue,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(Colors.grey.withAlpha(128)),
          borderColor: Colors.white,
          borderWidth: 0,
          borderRadius: 40,
        ),
        if (isStartDown)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('잠시만 기다려 주세요', style: ts),
                Text('${(progressValue * 100).toInt()}%', style: ts),
              ],
            ),
          ),
      ],
    );
  }

  showSnackBar(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 700),
        backgroundColor: Colors.orangeAccent,
        content: Text(msg),
      ),
    );
  }

  Widget switchedImage() {
    return isDownUnzipOk
        ? Image.asset(
            ImagePath,
            fit: BoxFit.fill,
          )
        : ColorFiltered(
            colorFilter: AppColors.greyScale,
            child: Image.asset(ImagePath, fit: BoxFit.fill),
          );
  }
}
