// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:winhealth_admin_v2/models/slot.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/appointment_service.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';
import 'package:winhealth_admin_v2/services/doctor_service.dart';
import 'package:winhealth_admin_v2/services/slot_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';
import 'package:winhealth_admin_v2/utils/date_time_utils.dart';

class DoctorProfile extends StatefulWidget {
  final UserModel doctor;
  final UserModel patient;
  const DoctorProfile({super.key, required this.doctor, required this.patient});

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  bool isLoadingSlots = false;
  String? selectedDate;
  Slot? selectedSlot;
  List<String> displayDates = [];
  bool isDisplayDatesHasToday = false;
  bool schedulingAppointment = false;
  bool isValid = false;
  List<Slot> slots = [];
  List<Slot> availableSlots = [];
  UserModel? currentUser;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getInitData();
  }

  langCode(val) {
    switch (val) {
      case "english":
        return "English";
      case "telugu":
        return "తెలుగు";
      case "hindi":
        return "हिंदी";
      case "urdu":
        return "اردو";
      default:
        return val;
    }
  }

  String? lang = "english";

  getInitData() async {
    setState(() {
      isLoading = true;
    });
    // String date = DateTimeUtils.apiFormattedDate('2023-05-27');
    String date = DateTimeUtils.apiFormattedDate(DateTimeUtils.getUtcDateNow());
    currentUser = widget.patient;
    slots =
        await SlotService.getSlotsByDocterID(widget.doctor.id.toString(), date);
    setState(() {
      selectedDate = date;
      displayDates = getDisplayDates(date);
      isLoading = false;
    });
  }

  void updateNewDisplayDates(
      String newFirstDisplayDateObj, int newSelectedDateIndex) {
    String newFirstDisplayDate =
        DateTimeUtils.apiFormattedDate(newFirstDisplayDateObj);
    List<String> newDisplayDates = getDisplayDates(newFirstDisplayDate);

    setState(() {
      selectedDate = newDisplayDates[newSelectedDateIndex];
      displayDates = newDisplayDates;
    });
  }

  void onPreviousClick() {
    var firstDisplayDateObj = DateTime.parse(displayDates[0]).toLocal();
    var newFirstDisplayDateObj =
        firstDisplayDateObj.subtract(const Duration(days: 3)).toIso8601String();
    updateNewDisplayDates(newFirstDisplayDateObj, 2);
  }

  void onNextClick() {
    var lastDisplayDateObj = DateTime.parse(displayDates[2]).toLocal();
    var newFirstDisplayDateObj =
        lastDisplayDateObj.add(const Duration(days: 1)).toIso8601String();
    updateNewDisplayDates(newFirstDisplayDateObj, 0);
  }

  void updateValidation() {
    bool valid = selectedDate != null && selectedSlot?.id != null;
    setState(() {
      isValid = valid;
    });
  }

  void onDateSelect(String newDate) async {
    String date = DateTimeUtils.apiFormattedDate(newDate);
    slots =
        await SlotService.getSlotsByDocterID(widget.doctor.id.toString(), date);
    setState(() {
      selectedDate = date;
      selectedSlot = null;
    });
    updateValidation();
  }

  void onSlotSelect(Slot newSlot) {
    setState(() {
      selectedSlot = newSlot;
    });
    updateValidation();
  }

  void onScheduleAppointment(BuildContext context, String meId) async {
    setState(() {
      schedulingAppointment = true;
    });
    final Map<String, dynamic> payload = {
      "slot": {"id": selectedSlot?.id, "status": "booked"},
      "patient": currentUser!.id
    };
    List allowed = await AppointmentService.getAppointmentsByDateAndPatientId(
      widget.patient.id!,
      selectedDate!,
    );
    if (allowed.isEmpty) {
      await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Select Language"),
            content: DropdownButton<String>(
              isExpanded: true,
              value: lang,
              hint: const Text("Select Language"),
              items: widget.doctor.speaks!
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(langCode(value)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  lang = newValue!;
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                onPressed: lang != null
                    ? () async {
                        payload['language'] = lang;
                        bool res = await AppointmentService.createApppointment(
                            payload);
                        if (res) {
                          setState(() {
                            schedulingAppointment = false;
                          });
                          // await Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => MyBookings(
                          //       currentUser: currentUser!,
                          //     ),
                          //   ),
                          // );
                          Navigator.of(context).pop();
                          await getInitData();
                        }
                        // _performAction(_selectedLanguage!);
                      }
                    : null,
                child: const Text('OK'),
              ),
            ],
          );
        }),
      );
    } else {
      Fluttertoast.showToast(
          msg: "One Appointment is already active, cancel or reschedule it.");
    }
    setState(() {
      schedulingAppointment = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (slots.isNotEmpty) {
      List<Slot> currentSlots = slots
          .where((slot) =>
              DateTimeUtils.apiFormattedDate(slot.date.toString()) ==
              selectedDate)
          .toList();
      availableSlots =
          currentSlots.where((slot) => slot.status == 'available').toList();
      DateTime today = DateTime.now();
      if (availableSlots.isNotEmpty) {
        if (DateTimeUtils.apiFormattedDate(
                availableSlots.first.date.toString()) ==
            DateTimeUtils.apiFormattedDate(today.toString())) {
          availableSlots = availableSlots
              .where(
                (slot) => DateTime(
                  today.year,
                  today.month,
                  today.day,
                  int.parse(
                    slot.startTime!.split(":")[0],
                  ),
                  int.parse(
                    slot.startTime!.split(":")[1],
                  ),
                ).isAfter(today),
              )
              .toList();
        }
      }
      String todayDate =
          DateTimeUtils.apiFormattedDate(DateTimeUtils.getUtcDateNow());
      isDisplayDatesHasToday = displayDates[0] == todayDate;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getInitData();
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Header section
                    Container(
                        margin: const EdgeInsets.only(top: 32, bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    getDoctorAvatarPath(
                                        widget.doctor.gender ?? ''),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                          '${widget.doctor.firstName} ${widget.doctor.lastName}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff333333),
                                          ))),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      // doctorTypesMap[
                                      //         widget.doctor.doctorType] ??
                                      //     "",

                                      jobLabel(widget.doctor.doctorType ?? ""),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff4F4F4F),
                                      ),
                                    ),
                                  ),
                                  Text(
                                      '${((DateTime.now().difference((widget.doctor.registrationYear)!).inDays) / 365).round()} Years of Experience',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff4F4F4F),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        )),
                    // About section
                    Container(
                      margin: const EdgeInsets.only(top: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: const Text(
                                'About',
                                style: TextStyle(fontSize: 20),
                              )),
                          Text(
                            widget.doctor.bio ?? "",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: const Text(
                              "Speaks",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Text(
                            widget.doctor.speaks!
                                .map((e) => langCode(e))
                                .toString(),
                            style: const TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              child: const Text(
                                "AvailableSlots",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              height: 82, // fixed height
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: Ink(
                                      width: 32,
                                      height: double.infinity,
                                      decoration: const ShapeDecoration(
                                        color: Color(0xffF2F2F2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16.0)),
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: isDisplayDatesHasToday
                                            ? null
                                            : () => onPreviousClick(),
                                        child: Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: isDisplayDatesHasToday
                                              ? Colors.black26
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: displayDates.length,
                                    itemBuilder: (context, index) {
                                      String date = displayDates[index];
                                      Color selectedItemColor =
                                          selectedDate == date
                                              ? const Color(0xffFFD6DA)
                                              : const Color(0xffF2F2F2);
                                      return GestureDetector(
                                          onTap: () => onDateSelect(date),
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 16),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16)),
                                              color: selectedItemColor,
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 6),
                                                    child: Text(DateFormat(
                                                            "EEE")
                                                        .format(
                                                            DateTime.parse(date)
                                                                .toLocal()))),
                                                Text(DateFormat("MMMd").format(
                                                    DateTime.parse(date)
                                                        .toLocal()))
                                              ],
                                            ),
                                          ));
                                    },
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: Ink(
                                      width: 32,
                                      height: double.infinity,
                                      decoration: const ShapeDecoration(
                                        color: Color(0xffF2F2F2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16.0)),
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () => onNextClick(),
                                        child: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 24),
                            ),
                            isLoadingSlots
                                ? const SizedBox(
                                    height: 60,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4.0,
                                      ),
                                    ),
                                  )
                                : availableSlots.isEmpty
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 20),
                                        child: const Center(
                                          child: Text("No Slots Available"),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 50,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: availableSlots.length,
                                          itemBuilder: (context, index) {
                                            Color selectedItemColor =
                                                selectedSlot?.id ==
                                                        availableSlots[index].id
                                                    ? const Color(0xffFFD6DA)
                                                    : const Color(0xffF2F2F2);
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  right: 8, top: 4),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(16)),
                                                color: selectedItemColor,
                                              ),
                                              child: GestureDetector(
                                                onTap: () => onSlotSelect(
                                                    availableSlots[index]),
                                                child: Text(
                                                  DateTimeUtils.uiFormattedTime(
                                                    availableSlots[index]
                                                        .startTime!,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                            const Padding(
                              padding: EdgeInsets.only(top: 24),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 32),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff333333),
                                  minimumSize: const Size.fromHeight(48),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(24.0)), // <-- Radius
                                  ),
                                ),
                                onPressed: (isValid && !schedulingAppointment)
                                    ? () => onScheduleAppointment(
                                        context, currentUser!.id!)
                                    : null,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      child: Text(
                                        "Schedule",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: (isValid &&
                                                  !schedulingAppointment)
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    schedulingAppointment
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            // padding: const EdgeInsets.all(2.0),
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : Icon(
                                            Icons.send,
                                            color: (isValid &&
                                                    !schedulingAppointment)
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 38),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  List<String> getDisplayDates(String date) {
    var dateObject = DateTime.parse(date).toLocal();
    String date1 = DateTimeUtils.apiFormattedDate(date);
    final datePlus1 = dateObject.add(const Duration(days: 1)).toIso8601String();
    String date2 = DateTimeUtils.apiFormattedDate(datePlus1);
    final datePlus2 = dateObject.add(const Duration(days: 2)).toIso8601String();
    String date3 = DateTimeUtils.apiFormattedDate(datePlus2);
    return [date1, date2, date3];
  }
}
