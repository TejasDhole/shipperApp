import 'package:provider/provider.dart';
import 'package:shipper_app/providerClass/providerData.dart';

selectedLocationPostLoad(
    context, placeName, addressName, cityName, stateName, valueType, geoFenceId) {
  //Update selected location on provider data
  ProviderData providerData = Provider.of<ProviderData>(context, listen: false);
  if (valueType == "Loading Point") {
    providerData.updateLoadingPointFindLoad(
        place: addressName == null ? placeName : '$placeName, $addressName',
        city: cityName,
        state: stateName);
    if(geoFenceId!=null){
      List loadingGeoFences = providerData.loadingGeoFenceIds;
      loadingGeoFences[0] =  geoFenceId;
      providerData.updateLoadingGeoFenceId(loadingGeoFences);
    }

  } else if (valueType == "Unloading Point") {
    providerData.updateUnloadingPointFindLoad(
        place: addressName == null ? placeName : '$placeName, $addressName',
        city: cityName,
        state: stateName);
    if(geoFenceId !=null){
      List unloadingGeoFences = providerData.unloadingGeoFenceIds;
      unloadingGeoFences[0] =  geoFenceId;
      providerData.updateUnloadingGeoFenceId(unloadingGeoFences);
    }

  } else if (valueType == "Loading point" || valueType == "Loading point 1") {
    providerData.updateLoadingPointPostLoad(
        place: addressName == null ? placeName : '$placeName, $addressName',
        city: cityName,
        state: stateName);
    if(geoFenceId!=null){
      List loadingGeoFences = providerData.loadingGeoFenceIds;
      loadingGeoFences[0] =  geoFenceId;
      providerData.updateLoadingGeoFenceId(loadingGeoFences);
    }

  } else if (valueType == "Loading point 2") {
    providerData.updateLoadingPointPostLoad2(
        place: addressName == null ? placeName : '$placeName, $addressName',
        city: cityName,
        state: stateName);
    if(geoFenceId!=null){
      List loadingGeoFences = providerData.loadingGeoFenceIds;
      loadingGeoFences[1] =  geoFenceId;
      providerData.updateLoadingGeoFenceId(loadingGeoFences);
    }

  } else if (valueType == "Unloading point" ||
      valueType == "Unloading point 1") {
    providerData.updateUnloadingPointPostLoad(
        place: addressName == null ? placeName : '$placeName, $addressName',
        city: cityName,
        state: stateName);
    if(geoFenceId !=null){
      List unloadingGeoFences = providerData.unloadingGeoFenceIds;
      unloadingGeoFences[0] =  geoFenceId;
      providerData.updateUnloadingGeoFenceId(unloadingGeoFences);
    }

  } else if (valueType == "Unloading point 2") {
    providerData.updateUnloadingPointPostLoad2(
        place: addressName == null ? placeName : '$placeName, $addressName',
        city: cityName,
        state: stateName);
    if(geoFenceId !=null){
      List unloadingGeoFences = providerData.unloadingGeoFenceIds;
      unloadingGeoFences[1] =  geoFenceId;
      providerData.updateUnloadingGeoFenceId(unloadingGeoFences);
    }

  }

}
