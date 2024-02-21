import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/components/directory_user_info_Card.dart';
import 'package:winhealth_admin_v2/components/doctor_info_card.dart';

import 'package:winhealth_admin_v2/models/role.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/doctor_service.dart';
import 'package:winhealth_admin_v2/services/role_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class UserDirectory extends StatefulWidget {
  final UserModel currentUser;
  const UserDirectory({super.key, required this.currentUser});

  @override
  State<UserDirectory> createState() => _UserDirectoryState();
}

class _UserDirectoryState extends State<UserDirectory> {
  ScrollController scrollController = ScrollController();
  bool loading = false;
  bool showbtn = false;
  List<UserModel> doctorsList = [];
  List<Roles> roles = [];

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
    super.initState();
  }

  getInitData() async {
    setState(() {
      loading = true;
    });
    roles = await RoleService.fetchAllRolls();
    doctorsList = await DoctorService.getDirectoryUsers();
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
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "User Directory",
                        style: TextStyle(
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

                    Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 16,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      children: doctorsList
                          .map((doctor) => SizedBox(
                                width: MediaQuery.of(context).size.width > 1800
                                    ? 350
                                    : MediaQuery.of(context).size.width > 1200
                                        ? 400
                                        : 600,
                                child: DirectoryUserInfoCard(
                                  doctor: doctor,
                                  currentUser: widget.currentUser,
                                  roles: roles,
                                  callback: getInitData,
                                ),
                              ))
                          .toList(),
                    )
                    // GridView.builder(
                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: MediaQuery.of(context).size.width > 1800
                    //         ? 3
                    //         : MediaQuery.of(context).size.width > 1200
                    //             ? 2
                    //             : 1,
                    //     childAspectRatio:
                    //         MediaQuery.of(context).size.width > 600 ? 2 : 1.5,
                    //     crossAxisSpacing: 16,
                    //     mainAxisSpacing: 16,
                    //   ),
                    //   itemBuilder: (context, index) {
                    //     return DoctorInfoCard(
                    //       doctor: doctorsList[index],
                    //       currentUser: widget.currentUser,
                    //       roles: roles,
                    //       callback: getInitData,
                    //     );
                    //   },
                    //   shrinkWrap: true,
                    //   itemCount: doctorsList.length,
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}
