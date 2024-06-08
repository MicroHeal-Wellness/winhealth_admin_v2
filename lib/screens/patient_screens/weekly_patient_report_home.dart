import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/components/report_card.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/models/weekly_patient_report_model.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/add_weekly_report.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/edit_weekly_report.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/report_summary.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/view_report_response.dart';
import 'package:winhealth_admin_v2/services/weekly_report_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class WeeklyPatientReportHome extends StatefulWidget {
  final UserModel patient;
  const WeeklyPatientReportHome({super.key, required this.patient});

  @override
  State<WeeklyPatientReportHome> createState() => _WeeklyPatientReportState();
}

class _WeeklyPatientReportState extends State<WeeklyPatientReportHome> {
  bool showbtn = false;
  bool loading = false;
  List<WeeklyPatientReportModel> reportList = [];
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
    getInitData();
  }

  getInitData() async {
    setState(() {
      loading = true;
    });
    reportList = await WeeklyReportService.fetchWeeklyReportByPatientId(
        widget.patient.id);
    setState(() {
      loading = false;
    });
  }

  ScrollController scrollController = ScrollController();
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
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const BackButton(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${widget.patient.firstName}'s Weekly Reports",
                          style: const TextStyle(
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
                  Row(
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportSummary(
                                reportList: reportList,
                              ),
                            ),
                          );
                          await getInitData();
                        },
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "View summary",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 32,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddWeeklyReport(
                                patient: widget.patient,
                              ),
                            ),
                          );
                          await getInitData();
                        },
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Add report",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
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
                    flex: 1,
                    child: reportList.isEmpty
                        ? const Center(
                            child: Text("No Form Response Found"),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              return ReportCard(
                                  weeklyPatientReport: reportList[index],
                                  onEdit: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditWeeklyReport(
                                          weeklyPatientReportModel:
                                              reportList[index],
                                        ),
                                      ),
                                    );
                                    await getInitData();
                                  },
                                  onView: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewReportResponse(
                                          weeklyReportResponse:
                                              reportList[index],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            itemCount: reportList.length,
                          ),
                  )
                ],
              ),
            ),
    );
  }
}
