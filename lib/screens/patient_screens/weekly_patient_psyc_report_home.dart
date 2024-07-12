import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/components/report_card.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/models/weekly_patient_nutrient_report_model.dart';
import 'package:winhealth_admin_v2/models/weekly_patient_psyc_report_model.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/add_weekly_nutrient_report.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/add_weekly_psyc_report.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/edit_weekly_report.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/nutrient_report_summary.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/psyc_report_summary.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/view_report_response.dart';
import 'package:winhealth_admin_v2/services/weekly_nutrient_report_service.dart';
import 'package:winhealth_admin_v2/services/weekly_psyc_report_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class WeeklyPatientPsycReportHome extends StatefulWidget {
  final UserModel curentUser;
  final UserModel patient;
  const WeeklyPatientPsycReportHome(
      {super.key, required this.curentUser, required this.patient});

  @override
  State<WeeklyPatientPsycReportHome> createState() => _WeeklyPatientReportState();
}

class _WeeklyPatientReportState extends State<WeeklyPatientPsycReportHome> {
  bool showbtn = false;
  bool loading = false;
  List<WeeklyPatientPsycReportModel> reportList = [];
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
    reportList = await WeeklyPsycReportService.fetchWeeklyPsycReportByPatientId(
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
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const BackButton(),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${widget.patient.firstName}'s Weekly Psyc Reports",
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
                                builder: (context) => PsycReportSummary(
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
                        [
                          '12b13cd2-5929-47d2-846c-5b6ad05938d4',
                          '7afc4f86-e282-4eb6-a9f3-b7eb7290b3fb'
                        ].contains(widget.curentUser.role)
                            ? MaterialButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddWeeklyPsycReport(
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
                            : const SizedBox()
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 16,
                    ),
                    reportList.isEmpty
                        ? const Center(
                            child: Text(
                              "No reports for selected patient",
                              style: TextStyle(fontSize: 24),
                            ),
                          )
                        : Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  showBottomBorder: true,
                                  dataRowMinHeight: 32,
                                  dataRowMaxHeight: 64,
                                  border: TableBorder.all(
                                      width: 2.0, color: Colors.black),
                                  columns: [
                                    const DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Week',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ...WeeklyPatientPsycReportModel()
                                        .toJsonList()
                                        .entries
                                        .map(
                                          (ent) => DataColumn(
                                            label: Expanded(
                                              child: Text(
                                                ent.value,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                  ],
                                  rows: List.generate(
                                    reportList.length,
                                    (index) => DataRow(cells: [
                                      DataCell(
                                        Text(reportList[index].week!),
                                      ),
                                      ...WeeklyPatientPsycReportModel()
                                          .toJsonList()
                                          .entries
                                          .map(
                                            (el) => DataCell(
                                              Text(
                                                reportList[index]
                                                    .toJson()[el.key]
                                                    .toString(),
                                              ),
                                            ),
                                          )
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ),

                    // Expanded(
                    //   flex: 1,
                    //   child: reportList.isEmpty
                    //       ? const Center(
                    //           child: Text("No Form Response Found"),
                    //         )
                    //       : ListView.builder(
                    //           shrinkWrap: true,
                    //           controller: scrollController,
                    //           itemBuilder: (context, index) {
                    //             return ReportCard(
                    //                 weeklyPatientReport: reportList[index],
                    //                 onEdit: () async {
                    //                   await Navigator.of(context).push(
                    //                     MaterialPageRoute(
                    //                       builder: (context) => EditWeeklyReport(
                    //                         weeklyPatientReportModel:
                    //                             reportList[index],
                    //                       ),
                    //                     ),
                    //                   );
                    //                   await getInitData();
                    //                 },
                    //                 onView: () {
                    //                   Navigator.of(context).push(
                    //                     MaterialPageRoute(
                    //                       builder: (context) =>
                    //                           ViewReportResponse(
                    //                         weeklyReportResponse:
                    //                             reportList[index],
                    //                       ),
                    //                     ),
                    //                   );
                    //                 });
                    //           },
                    //           itemCount: reportList.length,
                    //         ),
                    // )
                  ],
                ),
              ),
            ),
    );
  }
}
