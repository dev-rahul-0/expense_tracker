import 'package:expense/expense.dart';
import 'package:flutter/material.dart';
class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});
  final Expense expense;
  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(expense.title, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 4,),
          Row(
            children: [
              Text('\u{20B9}${expense.amount.toStringAsFixed(2)}'),
              const Spacer(),
              Row(
                children: [
                  Icon(CateogoryIcons[expense.category]),
                  const SizedBox(width: 8,),
                  Text(expense.formattedDate),
                ],
              )
            ],
          )
        ],
      ),
    ),);
  }
}
