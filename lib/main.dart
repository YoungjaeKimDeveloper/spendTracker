import 'package:app/database/expense_database.dart';
import 'package:app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // Search
  // WidgetFlutterBinding 으로 데이터 설정  데이터베이스 초기화
  WidgetsFlutterBinding.ensureInitialized();
  // initialize db
  await ExpenseDatabase.initialize();

  runApp(
    // 전체적으로 ExpensesData 사용할수있게 설정해주기
    ChangeNotifierProvider(
      create: (context) => ExpenseDatabase(),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()),
    ),
  );
}


// Work flow
