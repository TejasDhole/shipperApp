import 'package:get/get.dart';

class FacilityController extends GetxController{
  RxString address = ''.obs;
  RxString city = ''.obs;
  RxString state = ''.obs;
  RxString country = ''.obs;
  RxString pinCode = ''.obs;
  RxString partyName = ''.obs;
  RxString placeId = ''.obs;
  RxString facilityPopUpSearchText = ''.obs;

  updateAddress(String selectedAddress){
    address.value = selectedAddress;
  }
  updateCity(String selectedCity){
    city.value = selectedCity;
  }
  updateState(String selectedState){
    state.value = selectedState;
  }
  updatePinCode(String selectedPinCode){
    pinCode.value = selectedPinCode;
  }
  updateCountry(String selectedCountry){
    country.value = selectedCountry;
  }
  updatePartyName(String selectedPartyName){
    partyName.value = selectedPartyName;
  }
  updatePlaceId(String selectedPlaceId){
    placeId.value = selectedPlaceId;
  }
  updateFacilityPopUpSearchText(String searchedText){
    facilityPopUpSearchText.value = searchedText;
  }
}