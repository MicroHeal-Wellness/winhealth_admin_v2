import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/components/notes_card.dart';
import 'package:winhealth_admin_v2/components/reports_card.dart';
import 'package:winhealth_admin_v2/models/notes.dart';
import 'package:winhealth_admin_v2/models/report.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';
import 'package:winhealth_admin_v2/services/note_service.dart';
import 'package:winhealth_admin_v2/services/report_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';
import 'package:http/http.dart' as http;

class ReportHome extends StatefulWidget {
  final UserModel patient;
  const ReportHome({
    super.key,
    required this.patient,
  });

  @override
  State<ReportHome> createState() => _ReportHomeState();
}

class _ReportHomeState extends State<ReportHome> {
  bool showbtn = false;
  bool loading = false;
  List<Report> reports = [];
  ScrollController scrollController = ScrollController();
  PlatformFile? selectedFile;
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
    getInitData();
    super.initState();
  }

  getInitData() async {
    setState(() {
      loading = true;
    });
    reports = await ReportService.fetchReportsByPatientId(widget.patient.id!);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100.withOpacity(0.4),
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: showbtn ? 1.0 : 0.0,
        child: FloatingActionButton(
          onPressed: () {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
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
              child: SingleChildScrollView(
                controller: scrollController,
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
                            "${widget.patient.firstName}'s Uploads",
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
                    const Divider(),
                    const SizedBox(
                      height: 16,
                    ),
                    reports.isEmpty
                        ? const Center(
                            child: Text(
                              "No Uploads",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ReportsCard(report: reports[index]);
                            },
                            itemCount: reports.length,
                          )
                  ],
                ),
              ),
            ),
    );
  }
}
