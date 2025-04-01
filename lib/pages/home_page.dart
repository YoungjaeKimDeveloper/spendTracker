import 'package:app/bar_graph/my_bar_graph.dart';
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
  // name controller
  TextEditingController nameController = TextEditingController();
  // amount controller
  TextEditingController amountController = TextEditingController();

  // Stateful -> 위젯을 생성할때마다 새로운 state를 설정하겠다는 의미임
  // 화면이 그려질때 readExpenses를 불러오겠다는뜻
  // 보통 initState데이터 불러오기 / 한 번 작업해야하는작업할때 불러와짐

  // Future to load graph data - what the Fuck?
  // Fifth...[Guide]
  Future<Map<int, double>>? _monthlyTotalFuture;

  @override
  void initState() {
    // read db an initial startup
    // ...[Guide-7]
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    // load futures
    // ...[Guide-8]
    refreshGraphData();
    super.initState();
  }

  // ...[Guide-6] - what the fuck?
  void refreshGraphData() {
    _monthlyTotalFuture =
        Provider.of<ExpenseDatabase>(
          context,
          listen: false,
        ).calculateMonthlyTotals();
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

  //open Edit Box
  void openEditBox(Expense expense) {
    // pre-fill existing values into textfields
    String existingName = expense.name;
    String existingAmount = expense.amount.toString();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Expense"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // user input -> expense name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: existingName),
                ),
                // user input -> expense amount
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(hintText: existingAmount),
                ),
              ],
            ),
            actions: [
              // cancel Button
              _cancelButton(),
              // Save Button
              _editExpenseButton(expense),
            ],
          ),
    );
  }

  // open delete box
  void openDeleteBox(Expense expense) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete expense?"),
            content: Column(mainAxisSize: MainAxisSize.min),
            actions: [
              // cancel Button
              _cancelButton(),

              // delete Button
              _deleteExpenseButton(expense.id),
            ],
          ),
    );
  }

  // 실제 building이 들어가는곳
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) {
        // First ... [Guide]
        // get dates
        // 그래프를 그리기위해 첫번쨰 month를 들고옴
        int startMonth = value.getStartMonth();
        // 그래프를 그리기위해 첫번쨰 year를 들고옴
        int startYear = value.getStartYear();
        // 현재 month를 들고옴
        int currentMonth = DateTime.now().month;
        // 현재 year를 들고옴
        int currentYear = DateTime.now().year;

        // Third...[Guide] - 몇달있는기 가져오기
        // calculate the number of months since the first month
        // How many bars we will display
        int monthCount = calculateMonthCount(
          startYear,
          startMonth,
          currentYear,
          currentMonth,
        );
        // only display the expenses for the current month
        // return UI
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: openNewExpenseBox,
            child: Icon(Icons.add),
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20),
                // GRAPH UI
                SizedBox(
                  // set the Size
                  height: 250,
                  // Forth...[Guide] - What the fuck?
                  child: FutureBuilder(
                    future: _monthlyTotalFuture,
                    builder: (context, snapshot) {
                      // data is loaded
                      // Third...[Guide-7]
                      if (snapshot.connectionState == ConnectionState.done) {
                        final monthlyTotals = snapshot.data ?? {};
                        // Third...[Guide-8]
                        // create the list of monthly summary
                        List<double> monthlySummary = List.generate(
                          monthCount,
                          (index) => monthlyTotals[startMonth + index] ?? 0.0,
                        );
                        // 실제로 보이는 UI
                        return MyBarGraph(
                          monthlySummary: monthlySummary,
                          startMonth: startMonth,
                        );

                        // loading...
                      } else {
                        return const Center(child: Text("Loading..."));
                      }
                    },
                  ),
                ),

                // EXPENSE LIST UI
                Expanded(
                  child: ListView.builder(
                    itemCount: value.allExpense.length,
                    itemBuilder: (context, index) {
                      // get individual expense
                      Expense individualExpense = value.allExpense[index];
                      // return list tile UI
                      return MyListTile(
                        title: individualExpense.name,
                        trailing: formatAmount(individualExpense.amount),
                        onEditPress:
                            (context) => openEditBox(individualExpense),
                        onDeletePressed:
                            (context) => openDeleteBox(individualExpense),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

          // refresh graph
          refreshGraphData();
          // clear controllers
          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text("Save"),
    );
  }

  // SAVE BUTTON -> Edit existing expense
  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        // save as long as at least one textfied has been changed
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          // pop the box
          Navigator.pop(context);
          // create a new updated expense
          Expense updatedExpense = Expense(
            name:
                nameController.text.isNotEmpty
                    ? nameController.text
                    : expense.name,
            amount:
                amountController.text.isNotEmpty
                    ? convertStringToDouble(amountController.text)
                    : expense.amount,
            date: DateTime.now(),
          );
          // old expense id
          int existingId = expense.id;
          // save to db
          await context.read<ExpenseDatabase>().updxateExpense(
            existingId,
            updatedExpense,
          );
          refreshGraphData();
        }
      },
      child: const Text("Save"),
    );
  }

  Widget _deleteExpenseButton(int id) {
    return MaterialButton(
      onPressed: () async {
        // pop box
        Navigator.pop(context);
        // delete expense from db
        await context.read<ExpenseDatabase>().deleteExpense(id);
        refreshGraphData();
      },
      child: Text("Delete"),
    );
  }
}
