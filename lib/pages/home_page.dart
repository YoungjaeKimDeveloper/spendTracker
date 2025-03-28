import 'package:app/components/my_list_tile.dart';
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

  // Stateful -> 위젯을 생성할때마다 새로운 state를 설정하겠다는 의미임
  // 화면에 그려질때 데이터를 불러오겠단는것을 의미함
  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    super.initState();
  }

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
              _cancelButton(),
              // Save Button
              _createNewExpensesButton(),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder:
          (context, value, child) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: openNewExpenseBox,
              child: Icon(Icons.add),
            ),
            body: ListView.builder(
              itemCount: value.allExpense.length,
              itemBuilder: (context, index) {
                // get individual expense
                Expense individualExpense = value.allExpense[index];
                // return list tile UI
                return MyListTile(
                  title: individualExpense.name,
                  trailing: formatAmount(individualExpense.amount),
                  onEditPress: (context)=> openEditBox,
                  onDeletePressed: (context)=> openDeleteBox,

                );
              },
            ),
          ),
    );
  }

  // Cancel Button
  // ignore: unused_element
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
  // ignore: unused_element
  Widget _createNewExpensesButton() {
    return MaterialButton(
      onPressed: () async {
        // only save if there is something in the textfield to save
        if (nameController.text.isNotEmpty && nameController.text.isNotEmpty) {
          // pop box
          Navigator.pop(context);
          // Create new expense
          // 새로운 객체 생성
          Expense newExpense = Expense(
            name: nameController.text,
            amount: convertStringToDouble(amountController.text),
            date: DateTime.now(),
          );
          // save to data
          // 어떤 타입을 반환해야할지 알려줌 -> 제네릭(Generic)
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
