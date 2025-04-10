import 'package:app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// 전체적인 expense database를 다루겠다는 의미임 - Notifier로 전역적으로 설계
class ExpenseDatabase extends ChangeNotifier {
  // 클래스 레벨에서만 사용할수있음 Static -> 전역적으로 설계됨 -> 싱글톤
  static late Isar isar;
  // final 재할당이 불가능한 변수임 내용은 변경가능

  // 데이터를 미리 캐싱해서 사용할수있도록함
  final List<Expense> _allExpenses = [];
  // Set up
  // initialize db

  // Future<void> initaillzie()로 확실하게 setup시작함
  // 앱 실행전 초기화해서 필수적으로 필요한 리소스 설정
  // API초기화
  // Async로 연결할떄는 할상 Future
  static Future<void> initialize() async {
    // Local에 저장할수있게 getApplicationDocumentsDirectoy.
    final dir = await getApplicationDocumentsDirectory();
    // Create the Schema
    // Schema-> Tablename + Schema
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  // Getters
  List<Expense> get allExpense => _allExpenses;
  // Operations

  // Create -- add a new expense
  // Future -> async를 의미함
  Future<void> createNewExpense(Expense newExpense) async {
    // add to db
    // isar안에 데이터를작성  //isar테이블안에 expense
    await isar.writeTxn(() => isar.expenses.put(newExpense));
    // re-read from db
    await readExpenses();
  }

  // Read - expense from db
  Future<void> readExpenses() async {
    // fetch all existing expenses from db
    // isar안에있는 모든 expenses데이터 파일을 의미함
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();

    // give to local expense list
    // 캐싱되는데이터
    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);

    // update UI
    notifyListeners();
  }

  // Update - edit an expense in db
  Future<void> updxateExpense(int id, Expense updatedExpense) async {
    // make sure new expense has same id as existing one -- check the validation
    updatedExpense.id = id;
    // update in db
    await isar.writeTxn(() => isar.expenses.put(updatedExpense));
    // re-render from db
    await readExpenses();
  }

  // Delete - delete an expense
  Future<void> deleteExpense(int id) async {
    // delete from db
    await isar.writeTxn(() => isar.expenses.delete((id)));
    // re-read from db
    await readExpenses();
  }

  /*
  
  H E L P E R - For Graph

  */

  // calculate total expense for each month
  // Non-Blocking System Design
  // int = month
  // double = expense
  Future<Map<int, double>> calculateMonthlyTotals() async {
    // ensure the expense are read from the db [Always grab a data from database]
    // DB 접근할때는 항상 await 통하여 접근해주기
    await readExpenses();
    // create a map to keep track of total expense per month
    // 매달 : 지출금액
    Map<int, double> monthlyTotals = {
      // 0 : 250 Jan
      // 1 : 100 Feb
    };

    // iterate over all expense - expense반복에서 끌어내기
    for (var expense in _allExpenses) {
      // extratch the month from date of the expense
      // 개별접근.date.month -> month 반환
      int month = expense.date.month;
      // if the month is not yet in the map, initialize to 0
      // 현재 month를 의미함
      if (!monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = 0;
      }
      // add the expense amount to the total for the month
      // totla values를 의미함
      monthlyTotals[month] = monthlyTotals[month]! + expense.amount;
    }
    return monthlyTotals;
  }
  
  // get start month
  int getStartMonth() {
    if (_allExpenses.isEmpty) {
      return DateTime.now()
          .month; // default to current month is no expense are recorded
    }
    // sort expenses by date to find the earliest
    _allExpenses.sort((a, b) => a.date.compareTo(b.date));

    return _allExpenses.first.date.month;
  }

  // get start year
  int getStartYear() {
    if (_allExpenses.isEmpty) {
      return DateTime.now()
          .year; // default to current month is no expense are recorded
    }
    // sort expenses by date to find the earliest
    _allExpenses.sort((a, b) => a.date.compareTo(b.date));
    // first는 List에서 쓸수있는 프러퍼티를 의미함
    return _allExpenses.first.date.year;
  }
}


// Note: Month : Total
// 만 생각하기