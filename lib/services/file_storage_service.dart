import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/excelFile2.xlsx');
  }

  Future<String> readFileAsString() async {
    String contents = "";
    final file = await _localFile;
    if (file.existsSync()) { //Must check or error is thrown
      debugPrint("File exists");
      contents = await file.readAsString();
    }
    return contents;
  }

  Future<void> openFileNative() async {
    String contents = "";
    final file = await _localFile;
    OpenFile.open(file.path);
  }

  Future<Null> writeFile(String text) async {
    final file = await _localFile;

    IOSink sink = file.openWrite(mode: FileMode.append);
    sink.add(utf8.encode('$text')); //Use newline as the delimiter
    await sink.flush();
    await sink.close();
  }

  Future<void> deleteFile() async {
    final file = await _localFile;
    if (file.existsSync()) { //Must check or error is thrown
      await file.delete();
    }
  }
}