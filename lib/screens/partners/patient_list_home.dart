import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/components/patient_info_card.dart';
import 'package:winhealth_admin_v2/models/answer.dart';
import 'package:winhealth_admin_v2/models/patient_group.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/patient_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class PatientListHome extends StatefulWidget {
  final PatientGroup patientGroup;
  final UserModel currentUser;
  const PatientListHome(
      {super.key, required this.patientGroup, required this.currentUser});

  @override
  State<PatientListHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientListHome> {
  ScrollController scrollController = ScrollController();
  int page = 1;
  bool showbtn = false;
  bool showNotes = false;
  bool loading = false;
  List<UserModel> patientList = [];
  List<Answer> answer = [];

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
      List<UserModel> patientList2 =
          await PatientService.getPatientsByPatientGroup(
              widget.patientGroup.id!,
              page: page,
              limit: 10);
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
    patientList = await PatientService.getPatientsByPatientGroup(
        widget.patientGroup.id!,
        page: 1,
        limit: 10);
    page = page + 1;
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
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${widget.patientGroup.name}'s Patients",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 16,
                    ),
                    patientList.isEmpty
                        ? const Center(
                            child: Text("No Patients"),
                          )
                        : Wrap(
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
                                    child: PatientInfoCard(
                                      patient: patient,
                                      currentUser: widget.currentUser,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
