// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/models/role.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/doctor_service.dart';

class DirectoryUserInfoCard extends StatefulWidget {
  final UserModel doctor;
  final UserModel currentUser;
  final List<Roles> roles;
  final Function callback;
  const DirectoryUserInfoCard(
      {super.key,
      required this.doctor,
      required this.currentUser,
      required this.roles,
      required this.callback});

  @override
  State<DirectoryUserInfoCard> createState() => _DirectoryUserInfoCardState();
}

class _DirectoryUserInfoCardState extends State<DirectoryUserInfoCard> {
  Roles? selecetedRole;
  @override
  void initState() {
    super.initState();
    selecetedRole = widget.roles.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                MenuAnchor(
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(Icons.more_horiz),
                      tooltip: 'Show menu',
                    );
                  },
                  menuChildren: [
                    MenuItemButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      onPressed: (widget.currentUser.access != null &&
                              widget.currentUser.access!.permission!
                                  .contains("changerole"))
                          ? () async {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Add Role"),
                                  content: DropdownMenu<Roles>(
                                    initialSelection: selecetedRole,
                                    onSelected: (Roles? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        selecetedRole = value!;
                                      });
                                    },
                                    dropdownMenuEntries: widget.roles
                                        .map<DropdownMenuEntry<Roles>>(
                                            (Roles value) {
                                      return DropdownMenuEntry<Roles>(
                                          value: value, label: value.title!);
                                    }).toList(),
                                  ),
                                  actions: [
                                    MaterialButton(
                                      onPressed: () async {
                                        bool resp =
                                            await DoctorService.udpateDoctor(
                                                widget.doctor.id!,
                                                {"access": selecetedRole!.id});
                                        Navigator.of(context).pop();
                                        if (resp) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "New Role Udpated Successfully");
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "New Role Updation Failed");
                                        }
                                      },
                                      child: const Text("Assign"),
                                    ),
                                  ],
                                ),
                              );
                              await widget.callback();
                            }
                          : () {
                              Fluttertoast.showToast(msg: "Access Denied");
                            },
                      child: const Text('Change Role'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 8,
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
                  "${widget.doctor.firstName} ${widget.doctor.lastName}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Text(
                  "Email: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.doctor.emailAddress == null
                      ? widget.doctor.email!
                      : widget.doctor.emailAddress!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            // Row(
            //   children: [
            //     const Text(
            //       "Phone: ",
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     Text(
            //       "+91 ${widget.doctor.phoneNumber}",
            //       style: const TextStyle(
            //         fontSize: 16,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            // Row(
            //   children: [
            //     const Text(
            //       "DOB: ",
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     Text(
            //       "${widget.doctor.dob!.toString().split(" ").firstOrNull}",
            //       style: const TextStyle(
            //         fontSize: 16,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            Row(
              children: [
                const Text(
                  "Role: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.doctor.access == null
                      ? "Not yet signed"
                      : widget.roles
                          .firstWhere(
                            (element) => element.id == widget.doctor.access!.id,
                          )
                          .title!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
