import 'dart:io';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class ChatThemeFileHelper {
  // Private constructor
  ChatThemeFileHelper._privateConstructor();

  // The single instance (lazily initialized)
  static final ChatThemeFileHelper instance =
      ChatThemeFileHelper._privateConstructor();

  //
  //
  final _dirName = "/chat_theme";
  final _fileName = "/chat_background.png";
  final _log = "Chat theme background file log: ";

  ///
  ///
  /// function that will take any kind of image file
  /// convert into PNG and save in app internal storage
  Future<File?> saveThemeFile(File inputFile) async {
    try {
      // Read the input file as bytes
      final bytes = await inputFile.readAsBytes();

      // Decode image regardless of format (JPG, WEBP, etc.)
      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) {
        return null;
      }

      // Encode to PNG
      final pngBytes = img.encodePng(originalImage);

      // save in app private folder
      final directory = await getApplicationDocumentsDirectory();
      final themeDir = Directory(directory.path + _dirName);
      if (!(await themeDir.exists())) {
        await themeDir.create(recursive: true);
      }

      final file =
          await File('${themeDir.path}$_fileName').writeAsBytes(pngBytes);

      log("Image saved at: ${file.path}");
      return file;
    } catch (e) {
      log('saving file error: $e');
    }
    return null;
  }

  ///
  ///
  /// funtion that read and return the chat theme background file
  Future<File?> loadThemeFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}$_dirName$_fileName');

      if (await file.exists()) {
        return file;
      } else {
        return null;
      }
    } catch (e) {
      log('loading file error: $e');
    }
    return null;
  }

  ///
  ///
  /// function that will delete the chat theme background file
  Future<bool> deleteFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}$_dirName$_fileName');

      if (await file.exists()) {
        await file.delete();
        log('File deleted: ${file.path}');
        return true;
      } else {
        log('File not found: ${file.path}');
        return false;
      }
    } catch (e) {
      log('deleting file error: $e');
    }
    return false;
  }

  ///
  ///
  /// function to make a debug print in console
  void log(dynamic message) {
    debugPrint('$_log $message');
  }
}
