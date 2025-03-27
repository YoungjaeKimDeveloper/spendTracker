import 'package:isar/isar.dart';
// run cmd in terminal: dart run build_runner build

// isar -> ORM(Object->Relational Mapping)
// 일반적으로 데이터베이스는 SQL(관계형 데이터베이스) 을 사용하지만, ORM 사용하면 클래스(객체)를 이용

// this line is needed to generate isar file
// Question --> 테이블 기능들을 사용할수있게 dart로 넣어주어야함
part 'expense.g.dart';

// Question -- Collection 임을 표시해주는 Notaion을 의미함[실제 테이블 처럼 쓸수 있게됨]
// 이제 클래스가 -> 데이터 테이블이 된거임
@Collection()
class Expense {
  Id id = Isar.autoIncrement; // Expense가 테이블이 되었음으로 고유하게 인식될수있게 Id
  final String name;
  final double amount;
  final DateTime date;

  Expense({required this.name, required this.amount, required this.date});
}
