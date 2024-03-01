import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/screens/task_view/doctor_profile.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class DoctorSelectionPage extends StatelessWidget {
  final List<UserModel> doctors;
  final UserModel patient;
  const DoctorSelectionPage({super.key, required this.doctors, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Select a Doctor"),
        centerTitle: true,
      ),
      body: doctors.isEmpty
          ? const Center(
              child: Text("No Doctors Available, Please Check Back Later"),
            )
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 32),
                    child: const Text(
                      "Available Experts",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      // border: Border.all(color: Colors.blueAccent),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 3,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Wrap(
                        children: doctors
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DoctorProfile(
                                        doctor: e,
                                        patient: patient,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  color: Colors.white,
                                  height: 200,
                                  width: 200,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 16.0),
                                        width: 60.0,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                getDoctorAvatarPath(e.gender!)),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          '${e.firstName} ${e.lastName}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff333333),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        jobLabel(e.doctorType ?? ''),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff4F4F4F),
                                        ),
                                      ),
                                      Text(
                                        e.speaks!
                                            .map((e1) => langCode(e1))
                                            .toString(),
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
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
