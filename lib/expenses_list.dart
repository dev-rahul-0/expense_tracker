import 'dart:convert';

import 'package:expense/expense.dart';
import 'package:expense/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  void initState(){
    super.initState();
    _loadExpenseData();
  }

    Future <List<Expense>> _loadExpenseData()async{
    final pref = await SharedPreferences.getInstance();
    final expenseDataString = pref.getStringList('expenseData');
    if(expenseDataString==null)
    {
      return [];
    }
    return expenseDataString.map((e) {
      final Map<String,dynamic> expenseMap = json.decode('expenseData')
    })
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.expenses.length,
      itemBuilder: (context, index) => Dismissible(
          key: ValueKey(widget.expenses[index]),
          background: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.5),
            ),
          ),
          onDismissed: (direction) {
            widget.onRemoveExpense(widget.expenses[index]);
          },
          child: ExpenseItem(widget.expenses[index])),
    );
  }
}
