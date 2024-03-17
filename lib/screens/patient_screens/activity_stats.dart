// import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:winhealth_admin_v2/components/graphs/comparision_graph_builder.dart';
import 'package:winhealth_admin_v2/components/graphs/single_graph_builder.dart';
import 'package:winhealth_admin_v2/models/activity_stat.dart';
import 'package:winhealth_admin_v2/models/form_response.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/activity_service.dart';
import 'package:winhealth_admin_v2/services/questionare_service.dart';

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
  double score = 0;
  double maxScore = 0;
  List<FormResponse> responses = [];
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
    responses = await QuestionareService.getFormAnswer(widget.patient.id!);
    if (responses.isNotEmpty) {
      if (responses.first.answers!.isNotEmpty) {
        for (Answer element in responses.first.answers!) {
          if (element.formAnswersId!.question!.question!
              .contains("What is the main symptom bringing you here?")) {
            score += element.formAnswersId!.response!.length == 1
                ? 4
                : element.formAnswersId!.response!.length == 2
                    ? 8
                    : element.formAnswersId!.response!.length == 3
                        ? 10
                        : 0;
            maxScore += 10;
          } else if (element.formAnswersId!.question!.question!
              .contains("When did your symptoms first start?")) {
            score += element.formAnswersId!.response!.first ==
                    "Less than a week ago"
                ? 3
                : element.formAnswersId!.response!.first == "A few weeks"
                    ? 5
                    : element.formAnswersId!.response!.first == "A few months"
                        ? 7
                        : element.formAnswersId!.response!.first ==
                                "More than a year"
                            ? 10
                            : 0;
            maxScore += 10;
          } else if (element.formAnswersId!.question!.question!
              .contains("Which of these conditions are you suffering from?")) {
            score += element.formAnswersId!.response!.isNotEmpty ? 20 : 0;
            maxScore += 20;
          } else if (element.formAnswersId!.question!.question!.contains(
              "How strongly are your symptoms are limiting your daily lifestyle?")) {
            score += element.formAnswersId!.response!.first == "None"
                ? 0
                : element.formAnswersId!.response!.first == "Not very severe"
                    ? 3
                    : element.formAnswersId!.response!.first == "Moderate"
                        ? 5
                        : element.formAnswersId!.response!.first == "Severe"
                            ? 7
                            : element.formAnswersId!.response!.first ==
                                    "Extremely severe"
                                ? 10
                                : 0;
            maxScore += 15;
          } else if (element.formAnswersId!.question!.question!
              .contains(" List all your current medications with dosage?")) {
            List<String> meds = element.formAnswersId!.response!.first
                .split(RegExp(r'[\n,;.]'));
            score += meds.isEmpty
                ? 0
                : meds.length == 1
                    ? 3
                    : meds.length == 2
                        ? 5
                        : meds.length == 3
                            ? 7
                            : meds.length >= 3
                                ? 10
                                : 0;
            maxScore += 10;
          } else if (element.formAnswersId!.question!.question!
              .contains("What is your current bloating condition?")) {
            score += element.formAnswersId!.response!.first == "No bloating"
                ? 0
                : element.formAnswersId!.response!.first == "Not very severe"
                    ? 5
                    : element.formAnswersId!.response!.first == "Severe"
                        ? 8
                        : element.formAnswersId!.response!.first ==
                                "Extremely severe"
                            ? 10
                            : 0;
            maxScore += 10;
          } else if (element.formAnswersId!.question!.question!
              .contains("What is your current stool frequency in a day?")) {
            score += int.parse(element.formAnswersId!.response!.first) >= 1 &&
                    int.parse(element.formAnswersId!.response!.first) <= 2
                ? 0
                : int.parse(element.formAnswersId!.response!.first) >= 3 &&
                        int.parse(element.formAnswersId!.response!.first) <= 5
                    ? 10
                    : int.parse(element.formAnswersId!.response!.first) > 5 &&
                            int.parse(element.formAnswersId!.response!.first) <=
                                10
                        ? 15
                        : 0;
            maxScore += 15;
          } else if (element.formAnswersId!.question!.question!
              .contains("What is your current abdominal pain?")) {
            score += element.formAnswersId!.response!.first == "No pain"
                ? 0
                : element.formAnswersId!.response!.first ==
                        "Noticeable discomfort"
                    ? 5
                    : element.formAnswersId!.response!.first ==
                            "Severe discomfort"
                        ? 8
                        : element.formAnswersId!.response!.first ==
                                "Extreme Pain"
                            ? 10
                            : 0;
            maxScore += 10;
          }
        }
      }
    }
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
                                        "${score.round()} / ${(maxScore).round()}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      radius: 100,
                                      lineWidth: 28,
                                      percent: score / maxScore,
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
