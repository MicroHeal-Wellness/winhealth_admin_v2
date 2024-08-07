import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winhealth_admin_v2/components/side_bar_item.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/provider/sidebar_provvider.dart';
import 'package:winhealth_admin_v2/screens/appointment/appointment_home.dart';
import 'package:winhealth_admin_v2/screens/partners/partner_home.dart';
import 'package:winhealth_admin_v2/screens/pre/defualt_page.dart';
import 'package:winhealth_admin_v2/screens/doctors/doctor_home.dart';
import 'package:winhealth_admin_v2/screens/forms/patient_form_builder.dart';
import 'package:winhealth_admin_v2/screens/access/access_management_home.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/patient_home.dart';
import 'package:winhealth_admin_v2/screens/slot/slots_home.dart';
import 'package:winhealth_admin_v2/screens/task_view/task_view.dart';
import 'package:winhealth_admin_v2/screens/users/user_directory_home.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  UserModel? currentUser;
  bool loading = false;
  screenSwitcher(int index) {
    switch (index) {
      case -1:
        return const DefaultPage();
      case 0:
        return AppointmentHome(currentUser: currentUser!);
      case 1:
        return SlotsHome(currentUser: currentUser!);
      case 2:
        return PatientHome(currentUser: currentUser!);
      case 3:
        return DoctorHome(currentUser: currentUser!);
      case 4:
        return PatientFormBuilder();
      case 5:
        return UserDirectory(currentUser: currentUser!);
      case 6:
        return const AccessMangementHome();
      case 7:
        return TaskView(currentUser: currentUser!);
      case 9:
        return PartnerHome(currentUser: currentUser!);
      default:
        return const DefaultPage();
    }
  }

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  getInitData() async {
    setState(() {
      loading = true;
    });
    currentUser = await BaseService.getCurrentUser();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    padding: MediaQuery.of(context).size.width > 1600
                        ? const EdgeInsets.all(12.0)
                        : const EdgeInsets.all(2),
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.004,
                              vertical: size.width * 0.002),
                          child: Row(
                            mainAxisAlignment:
                                MediaQuery.of(context).size.width > 1200
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/logo_new.png",
                                height: MediaQuery.of(context).size.width > 1200
                                    ? 50 - size.width * 0.001
                                    : 36 - size.width * 0.005,
                              ),
                              MediaQuery.of(context).size.width > 1200
                                  ? const SizedBox(
                                      width: 32,
                                    )
                                  : const SizedBox(),
                              MediaQuery.of(context).size.width > 1200
                                  ? const Text(
                                      "Winhealth",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                        MediaQuery.of(context).size.width > 1200
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8),
                                child: Text(
                                  "${currentUser!.firstName}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        MediaQuery.of(context).size.width > 1200
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, bottom: 8),
                                child: Text(
                                  // "Doctor's Dashboard",
                                  currentUser!.access!.title!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        Divider(
                          endIndent: size.width * 0.01,
                          indent: size.width * 0.01,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        currentUser!.access != null &&
                                currentUser!.access!.permission!
                                    .contains("appointment")
                            ? const SideBarItem(
                                pageKey: 0,
                                iconData: Icons.alarm,
                                title: "Appointments",
                              )
                            : const SizedBox(),
                        currentUser!.access != null &&
                                currentUser!.access!.permission!
                                    .contains("slots")
                            ? const SideBarItem(
                                pageKey: 1,
                                iconData: Icons.add_box,
                                title: "Slots",
                              )
                            : const SizedBox(),
                        currentUser!.access != null &&
                                currentUser!.access!.permission!
                                    .contains("patients")
                            ? const SideBarItem(
                                pageKey: 2,
                                iconData: Icons.personal_injury,
                                title: "Patients",
                              )
                            : const SizedBox(),
                        currentUser!.access != null &&
                                currentUser!.access!.permission!
                                    .contains("doctors")
                            ? const SideBarItem(
                                pageKey: 3,
                                iconData: Icons.people_alt,
                                title: "Doctors",
                              )
                            : const SizedBox(),
                        currentUser!.access != null &&
                                currentUser!.access!.permission!
                                    .contains("formbuilder")
                            ? const SideBarItem(
                                pageKey: 4,
                                iconData: Icons.question_mark,
                                title: "Forms",
                              )
                            : const SizedBox(),
                        currentUser!.access != null &&
                                currentUser!.access!.permission!
                                    .contains("user_directory")
                            ? const SideBarItem(
                                pageKey: 5,
                                iconData: Icons.vaccines,
                                title: "User Directory",
                              )
                            : const SizedBox(),
                        currentUser!.access != null &&
                                currentUser!.access!.permission!
                                    .contains("accessmangement")
                            ? const SideBarItem(
                                pageKey: 6,
                                iconData: Icons.settings,
                                title: "Access",
                              )
                            : const SizedBox(),
                        currentUser!.access != null &&
                                currentUser!.access!.permission!
                                    .contains("taskview")
                            ? const SideBarItem(
                                pageKey: 7,
                                iconData: Icons.task_alt,
                                title: "TaskView",
                              )
                            : const SizedBox(),
                        currentUser!.role ==
                                '7afc4f86-e282-4eb6-a9f3-b7eb7290b3fb'
                            ? const SideBarItem(
                                pageKey: 9,
                                iconData: Icons.group,
                                title: "Partners",
                              )
                            : const SizedBox(),
                        const SideBarItem(
                          pageKey: 8,
                          isDisabled: true,
                          iconData: Icons.logout,
                          title: "Logout",
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 11,
                  child: screenSwitcher(
                      context.watch<SideBarProvider>().currentPage),
                )
              ],
            ),
    );
  }
}
