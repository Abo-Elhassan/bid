class FilterDataRequest {
  final int filterTypeUno;
  final int languageUno;
  final int userUno;
  final int companyUno;
  final int condition;

  FilterDataRequest({
    required this.filterTypeUno,
    required this.languageUno,
    required this.userUno,
    required this.companyUno,
    required this.condition,
  });

  Map<String, dynamic> toJson() {
    return {
      "filterTypeUno": filterTypeUno,
      "languageUno": languageUno,
      "userUno": userUno,
      "companyUno": companyUno,
      "condition": condition
    };
  }
}
