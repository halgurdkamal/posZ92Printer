import 'package:flutter/services.dart';

import 'posz92printer_platform_interface.dart';

enum AlignmentPrint { center, left, right }

class PrinterPosSystem {
  Future<bool?> printText(
      {required String text,
      AlignmentPrint alignment = AlignmentPrint.left,
      bool isBold = false,
      int fontSize = 30}) {
    return Posz92printerPlatform.instance.printText(
      text: text,
      alignment: alignment,
      isBold: isBold,
      fontSize: fontSize,
    );
  }

  Future<bool?> print2Column(
      {required String textLeft,
      required String textRight,
      int spaceLeft = 60,
      int spaceRight = 40,
      bool isBold = false,
      int fontSize = 16}) {
    return Posz92printerPlatform.instance.print2ColumnText(
      textLeft: textLeft,
      textRight: textRight,
      spaceLeft: spaceLeft,
      spaceRight: spaceRight,
      isBold: isBold,
      fontSize: fontSize,
    );
  }

  // 3 column
  Future<bool?> print3Column(
      {required String textLeft,
      required String textCenter,
      required String textRight,
      int spaceLeft = 60,
      int spaceCenter = 40,
      int spaceRight = 40,
      bool isBold = false,
      int fontSize = 16}) {
    return Posz92printerPlatform.instance.print3ColumnText(
      textLeft: textLeft,
      textCenter: textCenter,
      textRight: textRight,
      spaceLeft: spaceLeft,
      spaceCenter: spaceCenter,
      spaceRight: spaceRight,
      isBold: isBold,
      fontSize: fontSize,
    );
  }

  Future<bool?> printSpace({required int space}) {
    return Posz92printerPlatform.instance.printSpace(space: space);
  }

  Future<bool?> printImage({required Uint8List pathImage}) {
    return Posz92printerPlatform.instance.printImage(pathImage: pathImage);
  }

  Future<bool?> printQRCode(
      {required String text, int width = 100, int height = 100}) {
    return Posz92printerPlatform.instance.printQRCode(
      text: text,
      width: width,
      height: height,
    );
  }

  // line  print
  Future<bool?> printLine(
      {bool isBold = true,
      AlignmentPrint alignment = AlignmentPrint.left,
      int fontSize = 30,
      int lineSize = 19,
      String lineStyle = " - "}) {
    return Posz92printerPlatform.instance.printLine(
      isBold: isBold,
      alignment: alignment,
      fontSize: fontSize,
      lineSize: lineSize,
      lineStyle: lineStyle,
    );
  }

  // image bitmap
  Future<bool?> printBitMap({
    required Uint8List pathImage,
  }) {
    return Posz92printerPlatform.instance
        .printImageBitmap(pathImage: pathImage);
  }
}
