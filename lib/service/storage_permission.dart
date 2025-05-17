import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStoragePermission() async {
  if (Platform.isAndroid) {
    if (await Permission.photos.request().isGranted ||
        await Permission.videos.request().isGranted ||
        await Permission.audio.request().isGranted ||
        await Permission.mediaLibrary.request().isGranted) {
      return true;
    }

    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  return true;
}
