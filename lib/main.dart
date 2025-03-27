import 'package:app/database/expense_database.dart';
import 'package:app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // Search
  WidgetsFlutterBinding.ensureInitialized();
  // initialize db
  await ExpenseDatabase.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ExpenseDatabase(),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()),
    ),
  );
}
