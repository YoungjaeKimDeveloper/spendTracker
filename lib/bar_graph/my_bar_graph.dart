import 'package:app/bar_graph/individual_bar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyBarGraph extends StatefulWidget {
  // Member Varibales
  final List<double> monthlySummary; // [25,500,120..]
  final int startMonth; // 0 JAN , 1 FEB , 2 MAR ..

  // Constructor
  const MyBarGraph({
    super.key,
    required this.monthlySummary,
    required this.startMonth,
  });

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  // This list will hold the data for each bar
  List<IndividualBar> barData = [];
  // initialize bar data - user our montly summary to create a list of bars
  void initializeBarData() {
    barData = List.generate(
      widget.monthlySummary.length,
      (index) => IndividualBar(x: index, y: widget.monthlySummary[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(minY: 0, maxY: 100));
  }
}
