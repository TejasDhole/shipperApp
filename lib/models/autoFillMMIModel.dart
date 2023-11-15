class AutoFillMMIModel {
  String placeName;
  String? addresscomponent1;
  String placeCityName;
  String placeStateName;
  String placeId;

  AutoFillMMIModel(
      {required this.placeName,
      this.addresscomponent1,
      required this.placeCityName,
      required this.placeStateName,
      required this.placeId});
}
