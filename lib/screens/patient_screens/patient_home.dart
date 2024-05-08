import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/components/patient_info_card.dart';
import 'package:winhealth_admin_v2/components/patient_info_card_2.dart';
import 'package:winhealth_admin_v2/models/answer.dart';
import 'package:winhealth_admin_v2/models/patient_group.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/partner_group_service.dart';
import 'package:winhealth_admin_v2/services/patient_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';
import 'package:winhealth_admin_v2/utils/drag.dart';

class PatientHome extends StatefulWidget {
  final UserModel currentUser;
  const PatientHome({super.key, required this.currentUser});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  ScrollController scrollController = ScrollController();
  int page = 1;
  bool showbtn = false;
  bool showNotes = false;
  bool loading = false;
  int patientCount = 0;
  List<UserModel> patientList = [];
  List<PatientGroup> patientGroups = [];
  List<Answer> answer = [];
  String? patientGroupId;

  UserModel? selectedPatient;
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
    scrollController.addListener(_loadMoreData);
    super.initState();
  }

  void _loadMoreData() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      List<UserModel> patientList2 = [];
      if (patientGroupId == "1") {
        patientList2 =
            await PatientService.getUnassignedPatients(page: page, limit: 8);
      } else {
        patientList2 = await PatientService.getPatientsByPatientGroup(
            patientGroupId!,
            page: page,
            limit: 8);
      }
      if (patientList2.isNotEmpty) {
        page = page + 1;
        setState(() {
          patientList.addAll(patientList2);
        });
      }
    }
  }

  getInitData() async {
    setState(() {
      loading = true;
    });
    // patientGroups.add(PatientGroup(id: "0", name: "All"));
    patientGroups = await PatientGroupService.fetchAllPatientGroups();
    patientGroups.add(PatientGroup(id: "1", name: "Unassigned"));
    patientList = await PatientService.getPatientsByPatientGroup(
        patientGroups.first.id!,
        page: 1,
        limit: 8);
    patientCount = await PatientService.getPatientCountByPatientGroup(
      patientGroups.first.id!,
    );
    page = page + 1;
    setState(() {
      patientGroupId = patientGroups.first.id!;
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      patientGroupId == "1"
                          ? "Unassigned Patients ($patientCount)"
                          : "Patients ($patientCount)",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Selected Patient Group:",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: patientGroupId,
                          focusColor: Colors.white,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (String? value) async {
                            if (value == "1") {
                              patientList =
                                  await PatientService.getUnassignedPatients(
                                page: 1,
                                limit: 8,
                              );
                              patientCount = await PatientService
                                  .getUnassignedPatientsCount();
                            } else {
                              patientList = await PatientService
                                  .getPatientsByPatientGroup(
                                value!,
                                page: 1,
                                limit: 8,
                              );
                              patientCount = await PatientService
                                  .getPatientCountByPatientGroup(
                                value,
                              );
                            }
                            setState(() {
                              patientGroupId = value;
                              page = 1;
                            });
                          },
                          items: patientGroups.map<DropdownMenuItem<String>>(
                              (PatientGroup value) {
                            return DropdownMenuItem<String>(
                              value: value.id,
                              child: Text(value.name!),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 16,
                  ),
                  patientList.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text(
                                "No Patients in the selected patient group"),
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Wrap(
                              direction: Axis.horizontal,
                              runSpacing: 16,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 16,
                              children: patientList
                                  .map(
                                    (patient) => SizedBox(
                                      width: MediaQuery.of(context).size.width >
                                              1800
                                          ? 350
                                          : MediaQuery.of(context).size.width >
                                                  1200
                                              ? 400
                                              : 600,
                                      child: PatientInfoCard2(
                                        patient: patient,
                                        currentUser: widget.currentUser,
                                        patientGroups: patientGroups,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
