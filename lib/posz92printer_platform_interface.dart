import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:posz92printer/posz92printer.dart';

import 'posz92printer_method_channel.dart';

abstract class Posz92printerPlatform extends PlatformInterface {
  /// Constructs a Posz92printerPlatform.
  Posz92printerPlatform() : super(token: _token);

  static final Object _token = Object();

  static Posz92printerPlatform _instance = MethodChannelPosz92printer();

  /// The default instance of [Posz92printerPlatform] to use.
  ///
  /// Defaults to [MethodChannelPosz92printer].
  static Posz92printerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Posz92printerPlatform] when
  /// they register themselves.
  static set instance(Posz92printerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> printText({
    required String text,
    AlignmentPrint alignment = AlignmentPrint.left,
    bool isBold = false,
    int fontSize = 30,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> print2ColumnText({
    required String textLeft,
    required String textRight,
    int spaceLeft = 60,
    int spaceRight = 40,
    bool isBold = false,
    int fontSize = 16,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> print3ColumnText({
    required String textLeft,
    required String textCenter,
    required String textRight,
    int spaceLeft = 60,
    int spaceCenter = 40,
    int spaceRight = 40,
    bool isBold = false,
    int fontSize = 16,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> printSpace({required int space}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  // qr code text with size and height
  Future<bool?> printQRCode({
    required String text,
    int width = 100,
    int height = 100,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> printBitMap() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> printRow() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> printImage({required Uint8List pathImage}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  // line
  Future<bool?> printLine(
      {bool isBold = false,
      AlignmentPrint alignment = AlignmentPrint.left,
      int fontSize = 30,
      int lineSize = 100,
      String lineStyle = " - "}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  // image bitmap
  Future<bool?> printImageBitmap({required Uint8List pathImage}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
