import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final picker = ImagePicker();

  Future<File> pickUserImage(ImageSource source) async {
    try {
      final pickedImage = await picker.getImage(
          source: source, imageQuality: 75, maxWidth: 200);
      return pickedImage == null ? null : new File(pickedImage.path);
    } catch (error) {
      throw error;
    }
  }

  //TODO: EXPERIMENT WITH PICTURE SIZE AND QUALITY !!!!
  Future<File> pickPartyImage(ImageSource source) async {
    try {
      final pickedImage = await picker.getImage(
        source: source,
        imageQuality: 100,
      );
      return pickedImage == null ? null : new File(pickedImage.path);
    } catch (error) {
      throw error;
    }
  }
}
