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
  Future<void> updateExpense(int id, Expense updatedExpense) async {
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

  // Helper
}
