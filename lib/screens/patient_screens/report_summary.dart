import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/weekly_patient_report_model.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class ReportSummary extends StatefulWidget {
  final List<WeeklyPatientReportModel> reportList;
  const ReportSummary({super.key, required this.reportList});

  @override
  State<ReportSummary> createState() => _ReportSummaryState();
}

class _ReportSummaryState extends State<ReportSummary> {
  bool showbtn = false;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    scrollController.addListener(() {
      //scroll listener
      double showoffset =
          10.0; //Back to top botton will show on scroll offset 10.0

      if (scrollController.offset > showoffset) {
        showbtn = true;
        setState(() {
          //update state
        });
      } else {
        showbtn = false;
        setState(() {
          //update state
        });
      }
    });
    super.initState();
  }

  WeeklyPatientReportModel? dummyWeeklyPatientReportModel =
      WeeklyPatientReportModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100.withOpacity(0.4),
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: showbtn ? 1.0 : 0.0,
        child: FloatingActionButton(
          onPressed: () {
            scrollController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn);
          },
          backgroundColor: primaryColor,
          child: const Icon(
            Icons.arrow_upward,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Row(
              children: [
                BackButton(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Summary of weekly report",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dummyWeeklyPatientReportModel!
                        .toJsonList()
                        .entries
                        .map(
                          (ent) => getSingleGraph(
                            ent.key.contains("nos")
                                ? "${ent.key.split("_nos").first.split("_").map((el) => el[0].toUpperCase() + el.substring(1)).join(" ")} Frequency"
                                : "${ent.key.split("_").map((el) => el[0].toUpperCase() + el.substring(1)).join(" ")} Intensity",
                            "",
                            List<String>.generate(
                              widget.reportList.length,
                              (int index) => "Week ${index + 1}",
                            ).toList(),
                            List<int>.generate(
                              11,
                              (int index) => index,
                            ).toList(),
                            widget.reportList
                                .map((report) =>
                                    double.tryParse(
                                      report.toJson()[ent.key].toString(),
                                    ) ??
                                    0)
                                .toList(),
                            "Weeks",
                            "Intensity",
                          ),
                        )
                        .toList()
                    // [
                    //   getSingleGraph(
                    //     "Stomach Pain Intensity",
                    //     "",
                    //     List<String>.generate(
                    //       widget.reportList.length,
                    //       (int index) => "Week ${index + 1}",
                    //     ).toList(),
                    //     List<int>.generate(
                    //       11,
                    //       (int index) => index,
                    //     ).toList(),
                    //     widget.reportList
                    //         .map((report) => report.stomachPain!.toDouble())
                    //         .toList(),
                    //     "Weeks",
                    //     "Intensity",
                    //   ),
                    // ],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSingleGraph(
    String topLeftTitle,
    String topRightTitle,
    List<String>? xAxis,
    List<int>? yAxis,
    List<double>? data,
    String xAxisLabel,
    String yAxisLabel,
  ) {
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                topLeftTitle,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                topRightTitle,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 28,
          ),
          SizedBox(
            height: 180,
            width: MediaQuery.of(context).size.width,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  //dynamic data
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text(xAxisLabel),
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1.0,
                        getTitlesWidget: (val, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              xAxis!.elementAt(val.toInt()),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(yAxisLabel),
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1.0,
                      reservedSize: 40,
                      getTitlesWidget: (val, meta) {
                        return Text(
                          yAxis!.elementAt(val.toInt()).toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  //Constant data
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                maxX: xAxis!.length.toDouble() - 1.0,
                maxY: yAxis!.length.toDouble() - 1.0,
                //Constant data
                lineTouchData: const LineTouchData(enabled: false),
                minX: 0,
                minY: 0,
                borderData: FlBorderData(
                    border: Border.all(color: Colors.grey, width: 1)),
                gridData: const FlGridData(
                  horizontalInterval: 1.0,
                  verticalInterval: 1.0,
                ),
                baselineX: 0,
                baselineY: 0,
                lineBarsData: [
                  //dynamic
                  LineChartBarData(
                    spots: spotGenerator(
                        data!.length, data, yAxis.last, yAxis.length - 1),
                    //constant
                    color: primaryColor,
                    lineChartStepData:
                        const LineChartStepData(stepDirection: 1),
                    preventCurveOvershootingThreshold: 1,
                    preventCurveOverShooting: true,
                    isCurved: true,
                    isStrokeCapRound: true,
                    barWidth: 2,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 3,
                        color: primaryColor,
                        strokeColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<FlSpot> spotGenerator(
      int end, List<double> data, int apiMaxVal, int newYAxisMaxVal) {
    List<FlSpot> spotList = [];
    double ySpot = 0.0;

    if (apiMaxVal > newYAxisMaxVal) {
      for (int i = 0; i < end; i++) {
        double temp = (data[i] / apiMaxVal);
        ySpot = temp * newYAxisMaxVal;
        spotList.add(FlSpot(i.toDouble(), ySpot));
      }
    } else {
      for (int i = 0; i < end; i++) {
        ySpot = data[i];
        spotList.add(FlSpot(i.toDouble(), ySpot));
      }
    }
    return spotList;
  }
}
