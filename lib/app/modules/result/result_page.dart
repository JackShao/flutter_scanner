import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
                child: Row(
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
                      onTap: () {},
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _copyToClipboard(String msg) {
    FlutterClipboard.copy(msg).then((_) {
      const snackBar = SnackBar(
        content: Text('拷贝成功'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
