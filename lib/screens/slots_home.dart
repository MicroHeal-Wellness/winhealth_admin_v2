// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/components/slot_card.dart';
import 'package:winhealth_admin_v2/models/slot.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/screens/batch_slot_update.dart';
import 'package:winhealth_admin_v2/services/slot_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class SlotsHome extends StatefulWidget {
  final UserModel? currentUser;
  const SlotsHome({super.key, required this.currentUser});

  @override
  State<SlotsHome> createState() => _SlotsHomeState();
}

class _SlotsHomeState extends State<SlotsHome> {
  ScrollController scrollController = ScrollController();
  bool showbtn = false;
  DateTime? currentDate = DateTime.now();
  List<Slot> slots = [];

  bool chkClick(String time) {
    for (int i = 0; i < slots.length; i++) {
      if (slots[i].startTime == time) {
        print("false");
        return false;
      }
    }
    print("true");
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
    print(slots.length);
    slots = await SlotService.getSlotsByDocterID(widget.currentUser!.id!,
        "${currentDate!.year}-${currentDate!.month.toString().padLeft(2, "0")}-${currentDate!.day.toString().padLeft(2, "0")}");
    print(slots.length);
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
                        "Slots ",
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
                            "Date: ${currentDate!.day.toString().padLeft(2, "0")}-${currentDate!.month.toString().padLeft(2, "0")}-${currentDate!.year.toString().padLeft(2, "0")}",
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
                            currentDate = await showDatePicker(
                                  context: context,
                                  initialDate: currentDate!,
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2923),
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
                        // const SizedBox(
                        //   width: 32,
                        // ),
                        // GestureDetector(
                        //   onTap: () async {
                        //     await Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (context) => BatchSlotUpdate(
                        //           currentUser: widget.currentUser,
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   child: const CircleAvatar(
                        //     radius: 24,
                        //     backgroundColor: Colors.blueAccent,
                        //     child: Icon(
                        //       Icons.change_circle,
                        //       color: Colors.white,
                        //       size: 24,
                        //     ),
                        //   ),
                        // ),
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
                                    onTap: () async {
                                      if (slot.status == "unavailable" &&
                                          DateTime(
                                            currentDate!.year,
                                            currentDate!.month,
                                            currentDate!.day,
                                            int.parse(slot.startTime!
                                                .split(":")
                                                .first),
                                            int.parse(
                                              slot.startTime!.split(":")[1],
                                            ),
                                          ).isAfter(DateTime.now())) {
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Slot Update"),
                                            content: const Text(
                                              "Are you sure you want to mark the slot as available?",
                                            ),
                                            actions: [
                                              MaterialButton(
                                                onPressed: () async {
                                                  bool res = await SlotService
                                                      .updateSlotById(
                                                    slot.id!,
                                                    "available",
                                                  );
                                                  if (res) {
                                                    Fluttertoast.showToast(
                                                        msg: "Slot Updated");
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Slot Update Failed");
                                                  }
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Ok"),
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Cancel"),
                                              )
                                            ],
                                          ),
                                        );
                                        await getInitData();
                                      } else if (slot.status == "available" &&
                                          DateTime(
                                            currentDate!.year,
                                            currentDate!.month,
                                            currentDate!.day,
                                            int.parse(slot.startTime!
                                                .split(":")
                                                .first),
                                            int.parse(
                                              slot.startTime!.split(":")[1],
                                            ),
                                          ).isAfter(
                                            DateTime.now(),
                                          )) {
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Slot Update"),
                                            content: const Text(
                                              "Are you sure you want to mark the slot as unavailable?",
                                            ),
                                            actions: [
                                              MaterialButton(
                                                onPressed: () async {
                                                  bool res = await SlotService
                                                      .updateSlotById(
                                                    slot.id!,
                                                    "unavailable",
                                                  );
                                                  if (res) {
                                                    Fluttertoast.showToast(
                                                        msg: "Slot Updated");
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Slot Update Failed");
                                                  }
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Ok"),
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Cancel"),
                                              )
                                            ],
                                          ),
                                        );
                                        await getInitData();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "You cannot update an invalid slot");
                                      }
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        // GridView.builder(
                        //   gridDelegate:
                        //       const SliverGridDelegateWithMaxCrossAxisExtent(
                        //     maxCrossAxisExtent: 170,
                        //     childAspectRatio: 7 / 3,
                        //     crossAxisSpacing: 20,
                        //     mainAxisSpacing: 20,
                        //   ),
                        //   itemBuilder: (context, index) {
                        //     return GestureDetector(
                        //         child: SlotsCard(
                        //           title: slots[index].startTime!,
                        //           color: genStatusColor(slots[index].status!),
                        //         ),
                        //         onTap: () async {});
                        //   },
                        //   shrinkWrap: true,
                        //   itemCount: slots.length,
                        // ),
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
