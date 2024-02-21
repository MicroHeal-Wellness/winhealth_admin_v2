import 'package:chips_choice/chips_choice.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/activity_stat.dart';

class SingleGraphBuilder extends StatefulWidget {
  final ActivityStat? stats;

  const SingleGraphBuilder({Key? key, required this.stats}) : super(key: key);

  @override
  State<SingleGraphBuilder> createState() => _SingleGraphBuilderState();
}

class _SingleGraphBuilderState extends State<SingleGraphBuilder> {
  List<String> options = [
    "Daily",
    "Weekly",
    "Monthly",
  ];
  Map optionsLabel = {
    "Daily": "Last 2 days",
    "Weekly": "Last 7 days",
    "Monthly": "Last 30 days",
  };
  int selectedView = 0;

  List<Color> lineColors = const [
    Color(0xFF7253BF),
    Color(0xFF3982EC),
    Color(0xFFFF6777),
    Color(0xFF7253BF),
    Color(0xFFE0883B),
    Color(0xFF5BC496),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ChipsChoice<int>.single(
        value: selectedView,
        onChanged: (val) => setState(() => selectedView = val),
        choiceItems: C2Choice.listFrom<int, String>(
          source: options,
          value: (i, v) => i,
          label: (i, v) => optionsLabel[v],
        ),
        choiceStyle: C2ChipStyle(
          borderRadius: BorderRadius.circular(16),
          foregroundStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        wrapped: true,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        getSingleGraph(getSelectedGraphView(options[selectedView]).food!, 0,
            ["Low", "", "Medium", "", "High", ""]),
        getSingleGraph(getSelectedGraphView(options[selectedView]).water!, 1),
        getSingleGraph(getSelectedGraphView(options[selectedView]).sleep!, 2,
            ["Awful", "", "", "Not bad", "", "Great"]),
        getSingleGraph(getSelectedGraphView(options[selectedView]).stress!, 3,
            ["Happy", "", "", "Sad", "", "Angry"]),
        getSingleGraph(getSelectedGraphView(options[selectedView]).stool!, 4),
        // getSingleGraph(
        //     getSelectedGraphView(options[selectedView]).digestion!, 4),
      ])
    ]);
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

  Widget getSingleGraph(GraphDetails graph, int i,
      [List<String> customLbls = const []]) {
    return SizedBox(
      height: 250,
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
                    sideTitles: options[selectedView] == "Monthly"
                        ? SideTitles(
                            showTitles: true,
                            interval: 5.0,
                            getTitlesWidget: (val, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  graph.xAxis!.elementAt(val.toInt()),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            })
                        : SideTitles(
                            showTitles: true,
                            interval: 1.0,
                            getTitlesWidget: (val, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  graph.xAxis!.elementAt(val.toInt()),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            }),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1.0,
                        reservedSize: 40,
                        getTitlesWidget: (val, meta) {
                          if (customLbls.isNotEmpty) {
                            return Text(
                              customLbls.elementAt(val.toInt()),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            );
                          } else {
                            return Text(
                              graph.yAxis!.elementAt(val.toInt()).toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            );
                          }
                        }),
                  ),
                  //Constant data
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
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
                    color: lineColors[i],
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
                        color: lineColors[i],
                        strokeColor: lineColors[i],
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
