import 'package:app/database/expense_database.dart';
import 'package:app/helper/helper_function.dart';
import 'package:app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  // open new expense box
  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("New Expense"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // user input -> expense name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: "Name"),
                ),
                // user input -> expense amount
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(hintText: "Amount"),
                ),
              ],
            ),
            actions: [
              // cancel Button

              // Save Button
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openNewExpenseBox,
        child: Icon(Icons.add),
      ),
    );
  }

  // Cancel Button
  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        // pop box
        Navigator.pop(context);
        // clear controllers
        nameController.clear();
        amountController.clear();
      },
      child: const Text("Cancel"),
    );
  }

  // SAVE BUTTON -> Create new expense
  Widget _createNewExpensesButton() {
    return MaterialButton(
      onPressed: () async {
        // only save if there is something in the textfield to save
        if (nameController.text.isNotEmpty && nameController.text.isNotEmpty) {
          // pop box
          Navigator.pop(context);
          // Create new expense
          Expense newExpense = Expense(
            name: nameController.text,
            amount: convertStringToDouble(amountController.text),
            date: DateTime.now(),
          );
          // save to data
          // What the fuck?
          await context.read<ExpenseDatabase>().createNewExpense(newExpense);
          // clear controllers
          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text("Save"),
    );
  }
}
