import 'dart:convert';
import 'dart:io';

import 'package:optional/optional_internal.dart';
import 'package:path_provider/path_provider.dart';

String directory;

Future<String> _getDirectory() async =>
    directory ??= (await getApplicationDocumentsDirectory()).path;

Future<File> _getFileHandle(String fileName) async {
  final directory = await _getDirectory();
  return File('$directory/$fileName');
}

Future<Optional<dynamic>> loadJson(String fileName) async {
  try {
    final file = await _getFileHandle(fileName);
    if (await file.exists()) {
      final fileContent = await file.readAsString();
      final json = jsonDecode(fileContent) ?? {};
      return Optional.of(json);
    }
  } catch (e) {
    print(e);
  }
  return Optional.empty();
}

Future<void> storeJson(String fileName, dynamic json) async {
  try {
    final file = await _getFileHandle(fileName);
    final fileContent = jsonEncode(json);
    await file.writeAsString(fileContent);
  } catch (e) {
    print(e);
  }
}
