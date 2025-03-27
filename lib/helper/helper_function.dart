/*

  These are some helpful functions used across the app

 */

// convert string to a doulbe
double convertStringToDouble(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}
