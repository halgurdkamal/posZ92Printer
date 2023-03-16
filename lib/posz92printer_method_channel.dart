import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:posz92printer/posz92printer.dart';

import 'posz92printer_platform_interface.dart';

MethodChannel? _channel;

/// An implementation of [Posz92printerPlatform] that uses method channels.
class MethodChannelPosz92printer extends Posz92printerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('posz92printer');

  @override
  Future<bool?> printText({
    required String text,
    AlignmentPrint alignment = AlignmentPrint.left,
    bool isBold = false,
    int fontSize = 30,
  }) async {
    return await methodChannel.invokeMethod<bool>('printText', {
      'text': text,
      "Alignment": alignment.index,
      "isBold": isBold,
      "fontSize": fontSize,
    });
  }
   @override
  Future<bool?> printBarCode128({
    required String text, int width = 100, int height = 100}) async {
    return await methodChannel.invokeMethod<bool>('printBarCode128', {
      'text': text,
      "width": width,
      "height": height,
    });
  }

  // print 2 column text
  @override
  Future<bool?> print2ColumnText({
    required String textLeft,
    required String textRight,
    int spaceLeft = 0,
    int spaceRight = 0,
    bool isBold = false,
    int fontSize = 30,
  }) async {
    return await methodChannel.invokeMethod<bool>('print2Column', {
      'leftText': textLeft,
      "rightText": textRight,
      "leftTextSize": spaceLeft,
      "rightTextSize": spaceRight,
      "isBold": isBold,
      "fontSize": fontSize,
    });
  }

  // print 3 column text
  @override
  Future<bool?> print3ColumnText({
    required String textLeft,
    required String textCenter,
    required String textRight,
    int spaceLeft = 0,
    int spaceCenter = 0,
    int spaceRight = 0,
    bool isBold = false,
    int fontSize = 30,
  }) async {
    return await methodChannel.invokeMethod<bool>('print3Column', {
      'leftText': textLeft,
      "centerText": textCenter,
      "rightText": textRight,
      "leftTextSize": spaceLeft,
      "centerTextSize": spaceCenter,
      "rightTextSize": spaceRight,
      "isBold": isBold,
      "fontSize": fontSize,
    });
  }

  @override
  Future<bool?> printSpace({required int space}) async {
    return await methodChannel.invokeMethod<bool>('printSpace', {
      'space': space,
    });
  }

  @override
  Future<bool?> printBitMap() async {
    return await methodChannel.invokeMethod<bool>('printBitMap', {
      'text': 'Hello World',
      "Alignment": 0,
      "isBold": true,
      "fontSize": 30,
    });
  }

  @override
  Future<bool?> printImage({required Uint8List pathImage}) async {
    return await methodChannel.invokeMethod<bool>('printImage', {
      'pathImage': pathImage,
    });
  }

//qr code
  @override
  Future<bool?> printQRCode(
      {required String text, int width = 100, int height = 100}) async {
    return await methodChannel.invokeMethod<bool>('printQrCode', {
      'text': text,
      "width": width,
      "height": height,
    });
  }

// line
  @override
  Future<bool?> printLine(
      {bool isBold = false,
      AlignmentPrint alignment = AlignmentPrint.left,
      int fontSize = 30,
      int lineSize = 100,
      String lineStyle = " - "}) async {
    return await methodChannel.invokeMethod<bool>('printLine', {
      'isBold': isBold,
      "Alignment": alignment.index,
      "fontSize": fontSize,
      "lineSize": lineSize,
      "lineStyle": lineStyle,
    });
  }

  // image bitmap
  @override
  Future<bool?> printImageBitmap({required Uint8List pathImage}) async {
    return await methodChannel.invokeMethod<bool>('printImageBitmap', {
      'pathImage': pathImage,
    });
  }
}
