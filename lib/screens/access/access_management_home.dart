// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/models/role.dart';
import 'package:winhealth_admin_v2/services/role_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class AccessMangementHome extends StatefulWidget {
  const AccessMangementHome({super.key});

  @override
  State<AccessMangementHome> createState() => _AccessMangementHomeState();
}

class _AccessMangementHomeState extends State<AccessMangementHome> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  ScrollController scrollController = ScrollController();
  TextEditingController namesController = TextEditingController();
  bool showbtn = false;
  Roles? selectedRole;
  List<Roles> roles = [];
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
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        const Text(
                          "Role & Access management",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 32,
                          height:
                              32, // Add height for vertical spacing when wrapped
                        ),
                        GestureDetector(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Add Role"),
                                content: Form(
                                  key: formKey,
                                  child: TextFormField(
                                    controller: namesController,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Please Enter a valid Name";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                actions: [
                                  MaterialButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        bool resp = await RoleService.addRole({
                                          "title": namesController.text,
                                          "permission": []
                                        });
                                        Navigator.of(context).pop();
                                        if (resp) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "New Role Added Successfully");
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "New Role Addition Failed");
                                        }
                                      }
                                    },
                                    child: const Text("Add"),
                                  ),
                                ],
                              ),
                            );
                            await getInitData();
                          },
                          child: const CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
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
                        children: roles
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedRole = e;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.all(12),
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: (selectedRole != null &&
                                            selectedRole!.id == e.id)
                                        ? primaryColor
                                        : Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        e.title!,
                                        style: TextStyle(
                                          color: (selectedRole != null &&
                                                  selectedRole!.id == e.id)
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Total Permissions: ${e.permission!.length.toString().padLeft(2, "0")}",
                                        style: TextStyle(
                                          color: (selectedRole != null &&
                                                  selectedRole!.id == e.id)
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 16,
                    ),
                    selectedRole != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: accessSpecifiers.entries
                                .map(
                                  (e) => SizedBox(
                                    width: 500,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e.value,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Switch(
                                          value: selectedRole!.permission!
                                              .contains(e.key),
                                          onChanged: (val) {
                                            if (selectedRole!.permission!
                                                .contains(e.key)) {
                                              selectedRole!.permission!
                                                  .remove(e.key);
                                            } else {
                                              selectedRole!.permission!
                                                  .add(e.key);
                                            }
                                            setState(() {});
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 32,
                    ),
                    selectedRole != null
                        ? MaterialButton(
                            onPressed: () async {
                              bool resp = await RoleService.udpateRole(
                                  selectedRole!.id!,
                                  {"permission": selectedRole!.permission!});
                              if (resp) {
                                Fluttertoast.showToast(msg: "Role Updated!");
                                await getInitData();
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Role Update Failed!");
                              }
                            },
                            color: primaryColor,
                            minWidth: 500,
                            height: 60,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Save/Update Role",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
    );
  }
}
