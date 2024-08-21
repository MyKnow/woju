import 'package:image_picker/image_picker.dart';
import 'package:woju/service/debug_service.dart';

class ImagePickerService {
  Future<XFile?> pickImageForGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxWidth: 500, maxHeight: 500);
    if (pickedFile != null) {
      printd(
          "fileName: ${pickedFile.path}, size: ${await pickedFile.length()}");
      return XFile(pickedFile.path);
    }
    return null;
  }

  Future<XFile?> pickImageForCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera, maxWidth: 500, maxHeight: 500);
    if (pickedFile != null) {
      printd(
          "fileName: ${pickedFile.path}, size: ${await pickedFile.length()}");
      return XFile(pickedFile.path);
    }
    return null;
  }
}
