import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/components/partner_card.dart';
import 'package:winhealth_admin_v2/components/patient_group_card.dart';
import 'package:winhealth_admin_v2/models/partner.dart';
import 'package:winhealth_admin_v2/models/patient_group.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/partner_group_service.dart';
import 'package:winhealth_admin_v2/services/partner_service.dart';
import 'package:winhealth_admin_v2/services/patient_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class PartnerHome extends StatefulWidget {
  final UserModel currentUser;
  const PartnerHome({
    super.key,
    required this.currentUser,
  });

  @override
  State<PartnerHome> createState() => _PartnerHomeState();
}

class _PartnerHomeState extends State<PartnerHome> {
  ScrollController scrollController = ScrollController();
  bool loading = false;
  bool showbtn = false;
  List<Partner> partners = [];
  List<PatientGroup> patientGroups = [];
  List<int> patientGroupsCount = [];

  Partner? selectedPartner;
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
    partners = await PartnerService.fetchAllPartners();
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Partners",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              MaterialButton(
                                onPressed: () async {
                                  // await Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => AddResponsePage(
                                  //       patient: widget.patient,
                                  //     ),
                                  //   ),
                                  // );
                                  Fluttertoast.showToast(
                                      msg: "Featured Locked!");
                                  await getInitData();
                                },
                                color: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Add Partner",
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
                          Align(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                              direction: Axis.horizontal,
                              runSpacing: 16,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 16,
                              children: partners
                                  .map(
                                    (partner) => SizedBox(
                                      width: MediaQuery.of(context).size.width >
                                              1800
                                          ? 350
                                          : MediaQuery.of(context).size.width >
                                                  1200
                                              ? 400
                                              : 600,
                                      child: InkWell(
                                        onTap: () async {
                                          if (selectedPartner != null &&
                                              selectedPartner!.id ==
                                                  partner.id) {
                                            setState(() {
                                              selectedPartner = null;
                                            });
                                          } else {
                                            patientGroups =
                                                await PartnerGroupService
                                                    .fetchPatientGroupsByPartner(
                                                        partner.id!);
                                            patientGroupsCount.clear();
                                            for (var element in patientGroups) {
                                              int count = await PatientService
                                                  .getPatientCountByPatientGroup(
                                                      element.id!);
                                              patientGroupsCount.add(count);
                                            }
                                            setState(() {
                                              selectedPartner = partner;
                                            });
                                          }
                                        },
                                        child: PartnerCard(
                                          partner: partner,
                                          isSelected: selectedPartner != null &&
                                              selectedPartner!.id == partner.id,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Patient Groups",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: patientGroups.isEmpty
                              ? const Center(
                                  child: Text("No Patient Group"),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      PatientGroupCard(
                                          patientGroup: patientGroups[index],
                                          currentUser: widget.currentUser,
                                          patientGroupPatientCount:
                                              patientGroupsCount[index]),
                                  itemCount: patientGroups.length,
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
