import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStoragePermission() async {
  if (Platform.isAndroid) {
    // Android 13+ uses different permissions
    if (await Permission.photos.request().isGranted ||
        await Permission.videos.request().isGranted ||
        await Permission.audio.request().isGranted ||
        await Permission.mediaLibrary.request().isGranted) {
      return true;
    }

    // Fallback to general storage (for Android 12 and below)
    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  // Web, iOS or other platforms
  return true;
}
