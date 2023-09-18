import 'package:get/get.dart';

class PreviewUploadedImage extends GetxController {
  RxString previewImage = "".obs;
  RxInt index = 0.obs;
  void updatePreviewImage(String value) {
    previewImage.value = value;
  }

  void updateIndex(int value) {
    index.value = value;
  }
}
