import 'dart:convert';

import 'package:expense/expense.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectDate;
  Category _selectCatogeory = Category.leisure;

  void initState(){
    super.initState();
    _loadExpenseData();
  }

  void _loadExpenseData()async{
    final pref = await SharedPreferences.getInstance();
    final expenseDataString = pref.getString('expenseData');
    if(expenseDataString!=null)
      {
        final expenseData = json.decode(expenseDataString);
        setState(() {
          _titleController.text = expenseData['Title'];
          _amountController.text = expenseData['Amount'].toString();
          _selectDate = DateTime.parse(expenseData['Date']);
          _selectCatogeory = Category.values.firstWhere((element) => element.toString() == expenseData['Category']);
        });
      }


  }


  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 2, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);
    setState(() {
      _selectDate = pickedDate;
    });
  }

  void _submitExpenseData() async{
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectDate == null) {
      showDialog(context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid input'),
            content: const Text('Please make a sure a valid tittle, amount, date, and category was entered.'),
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: const Text('Okay')),
            ],
          ),
      );
      return;
    }



    //for sharedpreference use
    final pref = await SharedPreferences.getInstance();
    final expenseData = {
      'Title' : _titleController.text,
      'Amount' : enteredAmount,
      'Date' : _selectDate!.toIso8601String(),
      'Category' : _selectCatogeory.toString(),
    };
    await pref.setString('expenseData', json.encode(expenseData));





    widget.onAddExpense(Expense
      (title: _titleController.text,
        amount: enteredAmount,
        date: _selectDate!,
        category: _selectCatogeory),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Tittle'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\u{20B9}',
                    label: Text('Amount'),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(_selectDate == null
                        ? 'No date select'
                        : formatter.format(_selectDate!)),
                    IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              DropdownButton(
                  value: _selectCatogeory,
                  items: Category.values
                      .map((Category) => DropdownMenuItem(
                          value: Category,
                          child: Text(
                            Category.name.toUpperCase(),
                          )))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectCatogeory = value;
                    });
                  }),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: _submitExpenseData,
                  child: const Text('Save Expense'))
            ],
          )
        ],
      ),
    );
  }
}

