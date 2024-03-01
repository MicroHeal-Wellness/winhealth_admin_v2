import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/components/appointment_card.dart';
import 'package:winhealth_admin_v2/components/patient_info_card.dart';
import 'package:winhealth_admin_v2/models/appointment.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/appointment_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';
import 'package:winhealth_admin_v2/utils/date_time_utils.dart';

class AppointmentHome extends StatefulWidget {
  final UserModel? currentUser;
  const AppointmentHome({super.key, required this.currentUser});

  @override
  State<AppointmentHome> createState() => _AppointmentHomeState();
}

class _AppointmentHomeState extends State<AppointmentHome> {
  ScrollController scrollController = ScrollController();
  TextEditingController notesController = TextEditingController();
  bool showbtn = false;
  bool showNotes = false;
  DateTime? currentDate = DateTime.now();
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

  bool loading = false;
  List<Appointment> appointments = [];
  Appointment? selectedAppointment;

  getInitData() async {
    setState(() {
      loading = true;
    });
    await getAppointments();
    setState(() {
      loading = false;
    });
  }

  getAppointments() async {
    appointments = await AppointmentService.getAppointmentsByDocterIDandDate(
      widget.currentUser!.id!,
      DateTimeUtils.apiFormattedDate(currentDate.toString()),
    );
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Your Appointments",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runAlignment: WrapAlignment.start,
                      runSpacing: 16,
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
                            await getAppointments();
                            setState(() {});
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
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appointments.isEmpty
                            ? const Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "* No Appointments found for the selected date",
                                  softWrap: true,
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: AppointmentCard(
                                        isSelected: selectedAppointment == null
                                            ? false
                                            : selectedAppointment!.id ==
                                                appointments[index].id,
                                        appointment: appointments[index],
                                      ),
                                      onTap: () {
                                        if (MediaQuery.of(context).size.width >
                                            1600) {
                                          if (selectedAppointment != null &&
                                              selectedAppointment!.id ==
                                                  appointments[index].id) {
                                            setState(() {
                                              selectedAppointment = null;
                                              showNotes = !showNotes;
                                            });
                                          } else {
                                            setState(() {
                                              selectedAppointment =
                                                  appointments[index];
                                              showNotes = !showNotes;
                                            });
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: PatientInfoCard(
                                                patient: appointments[index]
                                                    .userCreated!,
                                                currentUser:
                                                    widget.currentUser!,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                  shrinkWrap: true,
                                  itemCount: appointments.length,
                                ),
                              ),
                        const SizedBox(
                          width: 32,
                        ),
                        MediaQuery.of(context).size.width > 1600
                            ? appointments.isEmpty
                                ? const SizedBox()
                                : Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Appointment Info",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                        showNotes
                                            ? Text(
                                                "ID: ${selectedAppointment!.id}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : const Text(
                                                "Select an Appointment to show notes",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                        !showNotes
                                            ? const SizedBox()
                                            : const SizedBox(
                                                height: 16,
                                              ),
                                        !showNotes ||
                                                selectedAppointment == null
                                            ? const SizedBox()
                                            : PatientInfoCard(
                                                patient: selectedAppointment!
                                                    .userCreated!,
                                                currentUser:
                                                    widget.currentUser!,
                                              )
                                      ],
                                    ),
                                  )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

}
