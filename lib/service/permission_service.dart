import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

Future<bool> requestStoragePermission() async {
  if (Platform.isAndroid) {
    // For Android 13 and above
    if (await Permission.photos.isGranted &&
        await Permission.videos.isGranted &&
        await Permission.audio.isGranted) {
      return true;
    }

    final photos = await Permission.photos.request();
    final videos = await Permission.videos.request();
    final audio = await Permission.audio.request();

    return photos.isGranted && videos.isGranted && audio.isGranted;
  }

  // For Android < 13 and other platforms
  final status = await Permission.storage.request();
  return status.isGranted;
}
