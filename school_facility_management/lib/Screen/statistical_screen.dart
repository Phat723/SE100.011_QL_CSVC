import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_facility_management/UserModel/borrow_slip_model.dart';
import 'package:school_facility_management/UserModel/report_model.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors1 = [
    Colors.cyan,
    Colors.blue,
  ];
  List<Color> gradientColors2 = [
    Colors.red,
    Colors.redAccent,
  ];
  List<int> borrowData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> reportData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    getNumberOfBorrowsInAllMonths().then((value) => borrowData = value);
    getNumberOfReportInAllMonths().then((value) => reportData = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Biểu đồ tuần suất mượn trả (Số lượng mượn/tháng)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              AspectRatio(
                aspectRatio: 1.2,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 18,
                    left: 12,
                    top: 24,
                    bottom: 12,
                  ),
                  child: LineChart(
                    mainData(),
                  ),
                ),
              ),
              Text(
                "Biểu đồ số lượng báo hỏng (Số lượng báo hỏng/tháng)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              AspectRatio(
                aspectRatio: 1.2,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 18,
                    left: 12,
                    top: 24,
                    bottom: 12,
                  ),
                  child: LineChart(
                    maintainLineChart(),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('1', style: style);
        break;
      case 1:
        text = const Text('2', style: style);
        break;
      case 2:
        text = const Text('3', style: style);
        break;
      case 3:
        text = const Text('4', style: style);
        break;
      case 4:
        text = const Text('5', style: style);
        break;
      case 5:
        text = const Text('6', style: style);
        break;
      case 6:
        text = const Text('7', style: style);
        break;
      case 7:
        text = const Text('8', style: style);
        break;
      case 8:
        text = const Text('9', style: style);
        break;
      case 9:
        text = const Text('10', style: style);
        break;
      case 10:
        text = const Text('11', style: style);
        break;
      case 11:
        text = const Text('12', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets2(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      case 4:
        text = '4';
        break;
      case 5:
        text = '5';
        break;
      case 6:
        text = '6';
        break;
      case 7:
        text = '7';
        break;
      case 8:
        text = '8';
        break;
      case 9:
        text = '9';
        break;
      case 10:
        text = '10';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget leftTitleWidgets1(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      case 4:
        text = '4';
        break;
      case 5:
        text = '5';
        break;
      case 6:
        text = '6';
        break;
      case 7:
        text = '7';
        break;
      case 8:
        text = '8';
        break;
      case 9:
        text = '9';
        break;
      case 10:
        text = '10';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.greenAccent,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.greenAccent,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets2,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, borrowData[0].toDouble()),
            FlSpot(1, borrowData[1].toDouble()),
            FlSpot(2, borrowData[2].toDouble()),
            FlSpot(3, borrowData[3].toDouble()),
            FlSpot(4, borrowData[4].toDouble()),
            FlSpot(5, borrowData[5].toDouble()),
            FlSpot(6, borrowData[6].toDouble()),
            FlSpot(7, borrowData[7].toDouble()),
            FlSpot(8, borrowData[8].toDouble()),
            FlSpot(9, borrowData[9].toDouble()),
            FlSpot(10,borrowData[10].toDouble()),
            FlSpot(11,borrowData[11].toDouble()),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors1,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors1
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData maintainLineChart() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.greenAccent,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.greenAccent,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets1,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, reportData[0].toDouble()),
            FlSpot(1, reportData[1].toDouble()),
            FlSpot(2, reportData[2].toDouble()),
            FlSpot(3, reportData[3].toDouble()),
            FlSpot(4, reportData[4].toDouble()),
            FlSpot(5, reportData[5].toDouble()),
            FlSpot(6, reportData[6].toDouble()),
            FlSpot(7, reportData[7].toDouble()),
            FlSpot(8, reportData[8].toDouble()),
            FlSpot(9, reportData[9].toDouble()),
            FlSpot(10, reportData[10].toDouble()),
            FlSpot(11, reportData[11].toDouble()),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors2,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors2
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Future<List<int>> getNumberOfBorrowsInAllMonths() async {
    List<int> result = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('BorrowSlip').get();
    for (int i = 1; i <= 12; i++) {
      int count = 0;
      for (DocumentSnapshot document in querySnapshot.docs) {
        BorrowSlip myBr = BorrowSlip.fromSnapshot(document);
        DateFormat format = DateFormat('dd/MM/yyyy');
        DateTime borrowTime = format.parse(myBr.borrowDate);
        if (borrowTime.month == i && borrowTime.year == DateTime.now().year) {
          count++;
        }
      }
      setState(() {
        result.add(count);
      });
      count = 0;
    }
    return result;
  }
  Future<List<int>> getNumberOfReportInAllMonths() async {
    List<int> result = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Report').get();
    for (int i = 1; i <= 12; i++) {
      int count = 0;
      for (DocumentSnapshot document in querySnapshot.docs) {
        Report myRp = Report.fromSnapshot(document);
        DateFormat format = DateFormat('dd/MM/yyyy');
        DateTime createDate = myRp.creationDate;
        if (createDate.month == i && createDate.year == DateTime.now().year) {
          count++;
        }
      }
      setState(() {
        result.add(count);
      });
      count = 0;
    }
    return result;
  }
}
