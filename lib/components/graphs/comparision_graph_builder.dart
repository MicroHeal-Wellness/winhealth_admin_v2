import 'package:chips_choice/chips_choice.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/activity_stat.dart';

class ComparisonGraphBuilder extends StatefulWidget {
  final ActivityStat? stats;

  const ComparisonGraphBuilder({Key? key, required this.stats})
      : super(key: key);

  @override
  State<ComparisonGraphBuilder> createState() => _ComparisonGraphBuilderState();
}

class _ComparisonGraphBuilderState extends State<ComparisonGraphBuilder> {
  List<String> options = ["Daily", "Weekly", "Monthly"];
  Map optionsLabel = {
    "Daily": "Last 2 days",
    "Weekly": "Last 7 days",
    "Monthly": "Last 30 days",
  };
  int selectedView = 0;
  List<String> otherGraphList = ["Food", "Water", "Sleep", "Stress", "Stool"];
  int compWithConstipation = 0;
  int compWithDiarrhea = 0;
  int compWithBloated = 0;
  int compWithPain = 0;

  List<Color> lineColors = const [
    Color(0xFF7253BF),
    Color(0xFF3982EC),
    Color(0xFFFF6777),
    Color(0xFF7253BF),
    Color(0xFFE0883B),
    Color(0xFF5BC496),
  ];

  List<String> digestionCustomLbl = ["None", "", "Mild", "", "Extreme", ""];
  List<String> stressCustomLbl = ["Happy", "", "Sad", "", "Angry", ""];
  List<String> sleepCustomLbl = ["Awful", "", "Not Bad", "", "Great", ""];
  List<String> foodCustomLbl = ["low", "", "Medium", "", "High", ""];
  List<String> comparatorCustomLbl = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChipsChoice<int>.single(
          value: selectedView,
          onChanged: (val) => setState(() => selectedView = val),
          choiceItems: C2Choice.listFrom<int, String>(
            source: options,
            value: (i, v) => i,
            label: (i, v) => optionsLabel[v],
          ),
          choiceStyle: C2ChipStyle.filled(
            borderRadius: BorderRadius.circular(16),
            foregroundStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            color: const Color(0xffF2F2F2),
            selectedStyle: const C2ChipStyle(
              backgroundColor: Color.fromARGB(255, 219, 243, 253),
            ),
          ),
          wrapped: true,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
        ),
        const SizedBox(
          height: 20,
        ),
        getMultiGraph(getSelectedGraphView(options[selectedView]).constipation!,
            compWithConstipation, (val) {
          compWithConstipation = val;
        }, 0),
        getMultiGraph(getSelectedGraphView(options[selectedView]).bloated!,
            compWithBloated, (val) {
          compWithBloated = val;
        }, 1),
        getMultiGraph(getSelectedGraphView(options[selectedView]).diarrhea!,
            compWithDiarrhea, (val) {
          compWithDiarrhea = val;
        }, 2),
        getMultiGraph(
            getSelectedGraphView(options[selectedView]).pain!, compWithPain,
            (val) {
          compWithPain = val;
        }, 3),
      ],
    );
  }

  GraphData getSelectedGraphView(String view) {
    switch (view) {
      case "Daily":
        return widget.stats!.daily!;
      case "Weekly":
        return widget.stats!.weekly!;
      case "Monthly":
        return widget.stats!.monthly!;
      default:
        return widget.stats!.daily!;
    }
  }

  Widget getMultiGraph(GraphDetails graph, int comparator,
      Function(int) changeComparator, int colorIndex) {
    return SizedBox(
      height: 370,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                graph.label!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                graph.duration!,
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
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1.0,
                      getTitlesWidget: (val, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            graph.xAxis!.elementAt(val.toInt()),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1.0,
                      reservedSize: 45,
                      getTitlesWidget: (val, meta) {
                        return Text(
                          digestionCustomLbl.elementAt(val.toInt()),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
                  //Constant data
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        interval: 1.0,
                        getTitlesWidget: (val, meta) {
                          if (comparator == 0) {
                            return Text(
                              foodCustomLbl.elementAt(val.toInt()),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          } else if (comparator == 2) {
                            return Text(
                              sleepCustomLbl.elementAt(val.toInt()),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          } else if (comparator == 3) {
                            return Text(
                              stressCustomLbl.elementAt(val.toInt()),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          } else {
                            return Text(
                              getOtherGraph(comparator)
                                  .yAxis!
                                  .elementAt(val.toInt())
                                  .toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }
                        }),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                maxX: graph.xAxis!.length.toDouble() - 1.0,
                maxY: graph.yAxis!.length.toDouble() - 1.0,
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
                    spots: options[selectedView] == "Daily"
                        ? spotGenerator(graph.data!.length, graph.data!,
                            graph.yAxis!.last, graph.yAxis!.length - 1)
                        : options[selectedView] == "Weekly"
                            ? spotGenerator(graph.data!.length, graph.data!,
                                graph.yAxis!.last, graph.yAxis!.length - 1)
                            : spotGenerator(graph.data!.length, graph.data!,
                                graph.yAxis!.last, graph.yAxis!.length - 1),
                    //constant
                    color: lineColors[colorIndex],
                    lineChartStepData:
                        const LineChartStepData(stepDirection: 1),
                    preventCurveOvershootingThreshold: 1,
                    preventCurveOverShooting: true,
                    isCurved: true,
                    isStrokeCapRound: true,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 3,
                        color: lineColors[colorIndex],
                        strokeColor: lineColors[colorIndex],
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: options[selectedView] == "Daily"
                        ? spotGenerator(
                            graph.data!.length,
                            getOtherGraph(comparator).data!,
                            getOtherGraph(comparator).yAxis!.last,
                            getOtherGraph(comparator).yAxis!.length - 1)
                        : options[selectedView] == "Weekly"
                            ? spotGenerator(
                                graph.data!.length,
                                getOtherGraph(comparator).data!,
                                getOtherGraph(comparator).yAxis!.last,
                                getOtherGraph(comparator).yAxis!.length - 1)
                            : spotGenerator(
                                graph.data!.length,
                                getOtherGraph(comparator).data!,
                                getOtherGraph(comparator).yAxis!.last,
                                getOtherGraph(comparator).yAxis!.length - 1),
                    //constant
                    color: lineColors[colorIndex + 1],
                    lineChartStepData:
                        const LineChartStepData(stepDirection: 1),
                    preventCurveOvershootingThreshold: 1,
                    preventCurveOverShooting: true,
                    isCurved: true,
                    isStrokeCapRound: true,
                    barWidth: 1.5,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 3,
                        color: lineColors[colorIndex + 1],
                        strokeColor: lineColors[colorIndex + 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Row(
            children: [
              Text(
                "Compare with",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          ChipsChoice<int>.single(
            value: comparator,
            onChanged: (val) {
              setState(() {
                changeComparator(val);
              });
            },
            choiceItems: C2Choice.listFrom<int, String>(
              source: otherGraphList,
              value: (i, v) => i,
              label: (i, v) => v,
            ),
            choiceStyle: C2ChipStyle.filled(
              borderRadius: BorderRadius.circular(16),
              foregroundStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              color: const Color(0xffF2F2F2),
              selectedStyle: const C2ChipStyle(
                backgroundColor: Color.fromARGB(255, 219, 243, 253),
              ),
            ),
            alignment: WrapAlignment.start,
            wrapped: true,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ],
      ),
    );
  }

  GraphDetails getOtherGraph(int index) {
    switch (index) {
      case 0:
        return getSelectedGraphView(options[selectedView]).food!;
      case 1:
        return getSelectedGraphView(options[selectedView]).water!;
      case 2:
        return getSelectedGraphView(options[selectedView]).sleep!;
      case 3:
        return getSelectedGraphView(options[selectedView]).stress!;
      case 4:
        return getSelectedGraphView(options[selectedView]).stool!;
      default:
        return getSelectedGraphView(options[selectedView]).food!;
    }
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
