import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatefulWidget {
  final Barcode data;

  const ResultPage({Key? key, required this.data}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    var msg = widget.data.code ?? "No Result";

    return Scaffold(
      appBar: AppBar(
        title: const Text('扫描结果'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Text(
                msg,
                style: const TextStyle(fontSize: 25.0),
              ),
            ),
            Positioned(
              left: 20.0,
              right: 20.0,
              bottom: 40.0,
              child: Container(
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.blueGrey[100],
                ),
                child: _buildActionBar(msg),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar(String msg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () => _copyToClipboard(msg),
          child: const Icon(
            Icons.copy,
            color: Colors.blue,
            size: 30.0,
          ),
        ),
        GestureDetector(
          onTap: () => _urlLauncher(msg),
          child: const Icon(
            Icons.explore,
            color: Colors.blue,
            size: 30.0,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: const Icon(
            Icons.send,
            color: Colors.blue,
            size: 30.0,
          ),
        ),
      ],
    );
  }

  _showSnackBar(String msg) {
    var snackBar = SnackBar(
      content: Text(msg),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// 复制到剪切板中。
  ///
  /// [msg]不能为空串，可以为空格。
  _copyToClipboard(String msg) {
    if (msg.isEmpty) return;

    FlutterClipboard.copy(msg).then((_) => _showSnackBar('拷贝成功'));
  }

  /// 调用系统直接处理[Uri]。
  _urlLauncher(String msg) async {
    try {
      // 解析url，有可能抛出[FormatException]异常。
      var url = Uri.parse(msg);
      await launchUrl(url);
    } on FormatException {
      _showSnackBar('无法识别');
      return;
    }
  }
}
