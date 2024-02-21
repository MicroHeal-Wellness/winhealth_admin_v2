// import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:winhealth_admin_v2/components/graphs/comparision_graph_builder.dart';
import 'package:winhealth_admin_v2/components/graphs/single_graph_builder.dart';
import 'package:winhealth_admin_v2/models/activity_stat.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/activity_service.dart';

class ActivityStats extends StatefulWidget {
  final UserModel patient;
  const ActivityStats({super.key, required this.patient});

  @override
  State<ActivityStats> createState() => _ActivityStatsState();
}

class _ActivityStatsState extends State<ActivityStats>
    with TickerProviderStateMixin {
  ActivityStat? stats;
  bool isLoading = false;
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    getInitData();
  }

  getInitData() async {
    setState(() {
      isLoading = true;
    });
    tabController = TabController(length: 2, vsync: this);
    stats = await ActivityService.getActivitiesStatByUserID(widget.patient.id!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Activity Stats for : ${widget.patient.firstName}"),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   elevation: 0.0,
      //   iconTheme: const IconThemeData(color: Colors.black),
      // ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const BackButton(),
                            const SizedBox(
                              width: 32,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${widget.patient.firstName}'s Activity Stats",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  children: [
                                    CircularPercentIndicator(
                                      center: Text(
                                        stats!.score.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      radius: 100,
                                      lineWidth: 28,
                                      percent: 0.7,
                                      progressColor: const Color(0xFF18B892),
                                      backgroundColor: Colors.grey,
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    const Text(
                                      "Your Wellness Score",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    SingleGraphBuilder(stats: stats),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 32,
                            ),
                            Expanded(
                              flex: 1,
                              child: ComparisonGraphBuilder(stats: stats),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ),
    );
  }
}
