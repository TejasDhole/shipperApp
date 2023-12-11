import 'package:get/get.dart';

class MyLoadsFilterController extends GetxController{
  RxBool toggleFilter = false.obs;
  RxBool toggleDate = false.obs;
  RxBool filterState = false.obs;
  RxString startDate = ''.obs;
  RxString endDate = ''.obs;
  RxBool refreshBuilder = false.obs;

  updateRefreshBuilder(bool refresh){
    refreshBuilder.value = refresh;
  }

  updateToggleFilter(bool state){ //change the visibility of filter selection widget
    toggleFilter.value = state;
  }

  updateFilterState(){
    if(toggleDate.value){ //if any filter in selected then filter button color should also be in selected state
      filterState.value = true;
    }
    else{ // if no filter is selected then filter button should be in unselected state
      filterState.value = false;
    }
  }

  updateToggleDate(bool state){
    toggleDate.value = state;
    updateFilterState();
  }

  updateDate(String startDate, String endDate){
    this.startDate.value = startDate;
    this.endDate.value = endDate;
  }

  resetController(){
    toggleFilter.value = false;
    toggleDate.value = false;
    filterState.value = false;
    startDate.value = '';
    endDate.value = '';
    refreshBuilder.value = false;
  }

  clearAll(){
    refreshBuilder.value = true;
    toggleDate.value = false;
    filterState.value = false;
    startDate.value = '';
    endDate.value = '';
  }


}