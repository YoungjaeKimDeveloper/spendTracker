import 'package:intl/intl.dart';

/*These are some helpful functions used across the app */

// convert string to a doulbe
// 문자를 Double로 바꿔주는 역할을 의미함
double convertStringToDouble(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

// format double amount into dollars & cents
String formatAmount(double amount){
  final format = NumberFormat.currency(locale: "en_US",symbol: "\$",decimalDigits: 2);
  return format.format(amount);
}