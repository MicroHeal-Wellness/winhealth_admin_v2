import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HelperFunctions {
  //file picker
  static Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }

  //show toast
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
    );
  }



}
