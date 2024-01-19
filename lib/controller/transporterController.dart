import 'package:get/get.dart';

class TransporterController extends GetxController {
  RxString name = ''.obs;
  RxString phoneNo = ''.obs;
  RxString emailId = ''.obs;
  RxString gstNo = ''.obs;
  RxString vendorCode = ''.obs;
  RxString panNo = ''.obs;
  RxBool create = true.obs;
  RxString id = ''.obs;

  updateCreate(bool status) {
    create.value = status;
  }

  updateName(String selectedName) {
    name.value = selectedName;
  }

  updatePhoneNo(String selectedPhoneNo) {
    phoneNo.value = selectedPhoneNo;
  }

  updateId(String selectedId) {
    id.value = selectedId;
  }

  updateEmailId(String selectedEmailId) {
    emailId.value = selectedEmailId;
  }

  updateGstNo(String selectedGstNo) {
    gstNo.value = selectedGstNo;
  }

  updateVendorCode(String selectedVendorCode) {
    vendorCode.value = selectedVendorCode;
  }

  updatePanNo(String selectePanNo) {
    panNo.value = selectePanNo;
  }
}
