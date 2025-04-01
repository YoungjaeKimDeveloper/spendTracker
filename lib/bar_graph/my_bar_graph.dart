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
    // initialize upon build
    initializeBarData();
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 100,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barGroups:
            barData
                .map(
                  (data) => BarChartGroupData(
                    x: data.x,
                    barRods: [
                      BarChartRodData(
                        toY: data.y,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey.shade800,
                      ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }

  // B O T T O M - T I T L E S
  // What the fuck?
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const textStyle = TextStyle(color: Colors.grey, fontSize: 14);
  String text;
  switch (value.toInt()) {
    case 0:
      text = "J";
      break;
    case 1:
      text = "F";
      break;
    case 2:
      text = "M";
      break;
    case 3:
      text = "A";
      break;
    case 4:
      text = "M";
      break;
    case 5:
      text = "J";
      break;
    case 6:
      text = "J";
      break;
    case 7:
      text = "A";
      break;
    case 8:
      text = "S";
      break;
    case 9:
      text = "O";
      break;
    case 10:
      text = "N";
      break;
    case 11:
      text = "D";
      break;
    default:
      text = "";
      break;
  }
  return Text(text, style: textStyle);
}
