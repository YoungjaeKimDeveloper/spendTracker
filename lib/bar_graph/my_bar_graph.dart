import 'package:app/bar_graph/individual_bar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyBarGraph extends StatefulWidget {
  // Member Varibales
  final int startMonth; // 0 JAN , 1 FEB , 2 MAR ..
  // monthly Summary
  final List<double> monthlySummary; // [25,500,120..]

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
  // 데이터를 담을 Array - 논리 추론
  List<IndividualBar> barData = [];
  // initialize bar data - user our montly summary to create a list of bars
  void initializeBarData() {
    barData = List.generate(
      widget.monthlySummary.length, //monthy Summar만큼 길이생성
      (int index) => IndividualBar(x: index, y: widget.monthlySummary[index]),
    );
  }

  // Build에서 UI를 정의하게됨
  @override
  Widget build(BuildContext context) {
    // 그래프 그리기
    return BarChart(BarChartData(minY: 0, maxY: 100));
  }
}
