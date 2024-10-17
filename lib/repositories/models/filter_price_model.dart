class FilterPriceModel {
  String filterName;
  bool isSelected;
  String value;

  // Constructor
  FilterPriceModel({
    required this.filterName,
    this.isSelected = false,
    required this.value,
  });

  // Static method to generate a list
  static List<FilterPriceModel> generateFilterList() {
    return [
      FilterPriceModel(filterName: "less than 20", isSelected: false, value: "0,20"),
      FilterPriceModel(filterName: "Rs 21 to Rs 120", isSelected: false, value: "21,120"),
      FilterPriceModel(filterName: "Rs 121 to Rs 220", isSelected: false, value: "121,220"),
      FilterPriceModel(filterName: "Rs 221 to Rs 320", isSelected: false, value: "221,320"),
      FilterPriceModel(filterName: "Rs 321 to Rs 420", isSelected: false, value: "321,420"),
      FilterPriceModel(filterName: "Rs 421 to Rs 520", isSelected: false, value: "421,520"),
      FilterPriceModel(filterName: "Rs 521 to Rs 620", isSelected: false, value: "521,620"),
      FilterPriceModel(filterName: "Rs 621 to Rs 720", isSelected: false, value: "621,720"),
      FilterPriceModel(filterName: "Rs 721 to Rs 820", isSelected: false, value: "721,820"),
      FilterPriceModel(filterName: "grater than 820", isSelected: false, value: "820,20000"),
    ];
  }
}
