import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'permission_service.dart';

Future<void> pickExcelFile() async {
  // On Android, request permission first
  if (Platform.isAndroid) {
    final hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      print('Storage permission not granted');
      return;
    }
  }

  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xls', 'xlsx'],
  );

  if (result != null && result.files.isNotEmpty) {
    final file = result.files.first;
    print('Picked file path: ${file.path}');
    // Process the Excel file here
  } else {
    print('No file selected.');
  }
}
