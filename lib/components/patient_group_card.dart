import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/partner.dart';
import 'package:winhealth_admin_v2/models/patient_group.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/screens/partners/patient_list_home.dart';
import 'package:winhealth_admin_v2/services/patient_service.dart';

class PatientGroupCard extends StatefulWidget {
  final PatientGroup patientGroup;
  final UserModel currentUser;
  const PatientGroupCard({
    super.key,
    required this.patientGroup,
    required this.currentUser,
  });

  @override
  State<PatientGroupCard> createState() => _PatientGroupCardState();
}

class _PatientGroupCardState extends State<PatientGroupCard> {
  @override
  void initState() {
    super.initState();
    getInitData();
  }

  int patientCount = 0;
  getInitData() async {
    patientCount = await PatientService.getPatientCountByPatientGroup(
        widget.patientGroup.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PatientListHome(
              patientGroup: widget.patientGroup,
              currentUser: widget.currentUser,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // ignore: prefer_const_constructors
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Patients: ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$patientCount",
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
              Row(
                children: [
                  const Text(
                    "Name: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${widget.patientGroup.name}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Added on: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.patientGroup.dateCreated.toString().split(".").first,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
