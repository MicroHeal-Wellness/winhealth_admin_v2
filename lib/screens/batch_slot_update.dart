// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/components/slot_card.dart';
import 'package:winhealth_admin_v2/models/slot.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/slot_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class BatchSlotUpdate extends StatefulWidget {
  final UserModel? currentUser;
  const BatchSlotUpdate({
    super.key,
    required this.currentUser,
  });

  @override
  State<BatchSlotUpdate> createState() => _BatchSlotUpdateState();
}

class _BatchSlotUpdateState extends State<BatchSlotUpdate> {
  ScrollController scrollController = ScrollController();
  bool showbtn = false;
  DateTime? fromDate = DateTime.now();
  DateTime? toDate = DateTime.now().add(
    const Duration(days: 1),
  );
  List<Slot> slots = [];

  bool chkClick(String time) {
    for (int i = 0; i < slots.length; i++) {
      if (slots[i].startTime == time) {
        return false;
      }
    }
    return true;
  }

  Color genStatusColor(String status) {
    if (status == "available") {
      return Colors.green;
    } else if (status == "booked") {
      return Colors.cyan;
    }
    return Colors.grey;
  }

  bool loading = true;
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
    slots = List.generate(
      12,
      (index) => Slot(
        startTime: "${(9 + index).toString().padLeft(2, "0")}:00:00",
        endTime: "${(10 + index).toString().padLeft(2, "0")}:00:00",
        status: "unavailable",
      ),
    );
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
                controller: scrollController,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Batch Update Slots ",
                        style: TextStyle(
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "From Date: ${fromDate!.day.toString().padLeft(2, "0")}-${fromDate!.month.toString().padLeft(2, "0")}-${fromDate!.year.toString().padLeft(2, "0")}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // const Spacer(),
                        const SizedBox(
                          width: 32,
                        ),
                        GestureDetector(
                          onTap: () async {
                            fromDate = await showDatePicker(
                                  context: context,
                                  initialDate: fromDate!,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 7),
                                  ),
                                ) ??
                                DateTime.now();
                            setState(() {});
                            await getInitData();
                          },
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.greenAccent,
                            child: Icon(
                              Icons.calendar_month,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "To Date: ${toDate!.day.toString().padLeft(2, "0")}-${toDate!.month.toString().padLeft(2, "0")}-${toDate!.year.toString().padLeft(2, "0")}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        GestureDetector(
                          onTap: () async {
                            toDate = await showDatePicker(
                                  context: context,
                                  initialDate: toDate!,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 7),
                                  ),
                                ) ??
                                DateTime.now();
                            setState(() {});
                            await getInitData();
                          },
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.greenAccent,
                            child: Icon(
                              Icons.calendar_month,
                              size: 24,
                            ),
                          ),
                        ),
                        const Spacer(),
                        MaterialButton(
                          onPressed: () async {},
                          color: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Apply",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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
                      height: 8,
                    ),
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.grey,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text("Unavailable"),
                        SizedBox(
                          width: 16,
                        ),
                        CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.green,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text("Available"),
                        SizedBox(
                          width: 16,
                        ),
                        CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.cyan,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text("Booked"),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 16,
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "* Click on unaviale slot to mark it as available",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: slots
                                .map(
                                  (slot) => GestureDetector(
                                    child: SizedBox(
                                      width: 170,
                                      child: SlotsCard(
                                        title: slot.startTime!,
                                        color: genStatusColor(slot.status!),
                                      ),
                                    ),
                                    onTap: () {
                                      if (slot.status == "unavailable") {
                                        setState(() {
                                          slot.status = "available";
                                        });
                                      } else {
                                        setState(() {
                                          slot.status = "unvailable";
                                        });
                                      }
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(
                          width: 32,
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
