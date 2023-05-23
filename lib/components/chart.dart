// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trabalho_a1/components/chart_bar.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart({
    required this.recentTransactions,
    Key? key,
  }) : super(key: key);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      final totalSum = recentTransactions.fold(0.0, (sum, transaction) {
        if (transaction.date.day == weekDay.day &&
            transaction.date.month == weekDay.month &&
            transaction.date.year == weekDay.year) {
          return sum + transaction.value;
        }
        return sum;
      });

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'value': totalSum,
      };
    });
  }

  double get weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + (tr['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: groupedTransactions.reversed.map((tr) {
            return ChartBar(
              label: tr['day'].toString(),
              value: double.parse(tr['value'].toString()),
              percentage: weekTotalValue == 0
                  ? 0
                  : (tr['value'] as double) / weekTotalValue,
            );
          }).toList(),
        ),
      ),
    );
  }
}
