import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:posz92printer/posz92printer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _printObj = PrinterPosSystem();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: const Text(
                    'print text',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                onTap: () async {
                  // print("print text");
                  // await _printObj.printText(
                  //   text: "AsiaCell",
                  //   alignment: AlignmentPrint.center,
                  //   isBold: true,
                  //   fontSize: 45,
                  // );
                  // await _printObj.printLine();
                  await _printObj.print3Column(
                    textLeft: "Amount",
                    textCenter: "5000IQD",
                    textRight: "بڕی",
                    spaceLeft: 20,
                    spaceCenter: 45,
                    spaceRight: 10,
                    isBold: true,
                    fontSize: 20,
                  );
                  await _printObj.print2Column(
                    textLeft: "code",
                    textRight: "کۆد",
                    spaceLeft: 55,
                    spaceRight: 30,
                    isBold: true,
                    fontSize: 18,
                  );
                  // await _printObj.printSpace(space: 1);
                  // await _printObj.printText(
                  //   text: "12437476326346",
                  //   alignment: AlignmentPrint.center,
                  //   isBold: true,
                  //   fontSize: 38,
                  // );
                  // await _printObj.printSpace(space: 1);
                  // await _printObj.printText(
                  //   text:
                  //       "hi this is a test for print text. \n سڵاو ایا باڕسڵاو ایا باڕ ام سڵاو \n یەکەم دووەم سیەکەم دووەم سێیەم",
                  //   alignment: AlignmentPrint.center,
                  //   isBold: true,
                  //   fontSize: 24,
                  // );
                  // await _printObj.printLine();

                  await _printObj.print3Column(
                    textLeft: "serial",
                    textCenter: "2134-12-12122",
                    textRight: "زنجیرە",
                    spaceLeft: 10,
                    spaceCenter: 40,
                    spaceRight: 10,
                    isBold: false,
                    fontSize: 20,
                  );
                  await _printObj.print3Column(
                    textLeft: "date",
                    textCenter: "6757776745",
                    textRight: "ڕۆژ",
                    spaceLeft: 15,
                    spaceCenter: 55,
                    spaceRight: 15,
                    isBold: false,
                    fontSize: 20,
                  );
                  // await _printObj.print3Column(
                  //   textLeft: "office",
                  //   textCenter: "zamo phone",
                  //   textRight: "شوێن",
                  //   spaceLeft: 20,
                  //   spaceCenter: 60,
                  //   spaceRight: 20,
                  //   isBold: true,
                  //   fontSize: 20,
                  // );
                  // await _printObj.printLine();
                  // await _printObj.printText(
                  //   text: "powered by KURDPAY",
                  //   alignment: AlignmentPrint.center,
                  //   isBold: true,
                  //   fontSize: 26,
                  // );
                  // await _printObj.printQRCode(
                  //     text: "this is a test for print QR code",
                  //     width: 200,
                  //     height: 200);
                  // await _printObj.printSpace(space: 3);

                  // await _printObj.printText(
                  //   text: "this is a test for print text left",
                  //   alignment: AlignmentPrint.left,
                  //   isBold: true,
                  //   fontSize: 45,
                  // );
                  // laod image from assets as how get image for network ad Uint8List
                  // final bytes = await rootBundle.load('asset/A4.png');
                  // await _printObj.printImage(
                  //   pathImage: bytes.buffer.asUint8List(),
                  // );

                  // await _printObj.printImage(
                  //   pathImage: bytes,
                  // );

                  // await _printObj.printSpace(space: 2);

                  // get image from network and convert to Uint8List
                  final response = await http.get(Uri.parse(
                      "https://i.ibb.co/bzjwNBz/2023-03-06-14-12-38-1.jpg"));
                  final bytes = response.bodyBytes;
                  await _printObj.printBitMap(
                    pathImage: bytes,
                  );
                  await _printObj.printSpace(space: 2);
                },
              )
            ],
          )),
    );
  }
}
