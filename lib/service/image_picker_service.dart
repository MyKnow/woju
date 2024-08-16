import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  Future<XFile?> pickImageForGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return XFile(pickedFile.path);
    }
    return null;
  }

  Future<XFile?> pickImageForCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return XFile(pickedFile.path);
    }
    return null;
  }
}
