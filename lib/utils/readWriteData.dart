import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ReadWriteData{

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/countries.txt');
  }
  Future<File> writeXML(String xmlString) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(xmlString, encoding: utf8);
  }
  Future<File?> readXML() async {
    try {
      // final file = await _localFile;
      // print(file.path);

      // Read the file
      return await _localFile as File;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  Future<String> getFilePath() async{
    final file = await _localFile;
    return file.path;
  }
}