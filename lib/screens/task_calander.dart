// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:winhealth_admin_v2/models/appointment.dart' as AppModel;
import 'package:winhealth_admin_v2/models/subscription.dart';
import 'package:winhealth_admin_v2/models/task_list.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/screens/doctor_profile.dart';
import 'package:winhealth_admin_v2/screens/landing_screen.dart';
import 'package:winhealth_admin_v2/services/appointment_service.dart';
import 'package:winhealth_admin_v2/services/base_service.dart';
import 'package:winhealth_admin_v2/services/doctor_service.dart';
import 'package:winhealth_admin_v2/services/subscription_service.dart';
import 'package:winhealth_admin_v2/services/task_service.dart';

class TaskCalander extends StatefulWidget {
  const TaskCalander({
    super.key,
  });

  @override
  State<TaskCalander> createState() => _TaskCalanderState();
}

class _TaskCalanderState extends State<TaskCalander> {
  List<Task> tasks = [];
  List<Task> preTasks = [];
  List<Subscription> activeSubscriptions = [];
  List<AppModel.Appointment> patientAppointments = [];
  bool loading = false;
  DateTime today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  @override
  void initState() {
    super.initState();
    getInitialData();
  }

  Future<void> getInitialData() async {
    setState(() {
      loading = true;
    });
    UserModel? currentUser = await BaseService.getCurrentUser();
    if (currentUser != null) {
      activeSubscriptions =
          await SubscriptionService.fetchActiveSubscriptionByUserId(
              currentUser.id!);
      if (activeSubscriptions.isNotEmpty) {
        tasks =
            await TaskService.fetchTasks(activeSubscriptions.first.plan!.id!);
        preTasks = await TaskService.fetchPreTasks(
            activeSubscriptions.first.plan!.id!);
        patientAppointments = await AppointmentService.getAppointments();
      } else {
        Navigator.of(context).pop();
      }
    }
    setState(() {
      loading = false;
    });
  }

  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    DateTime startDate = activeSubscriptions.first.dateCreated!;
    for (Task element in tasks) {
      if (element.consultationTitle != null) {
        String status = getStatus(
          DateTime(startDate.year, startDate.month,
              startDate.day + element.day! - 1),
        );
        Color statusColor = getStatusColor(
          DateTime(startDate.year, startDate.month,
              startDate.day + element.day! - 1),
        );
        appointments.add(
          Appointment(
            startTime: DateTime(startDate.year, startDate.month,
                startDate.day + element.day! - 1, 9),
            endTime: DateTime(startDate.year, startDate.month,
                startDate.day + element.day! - 1, 22),
            subject:
                "${element.consultationTitle ?? "Book an appointment "} $status",
            color: statusColor,
            startTimeZone: '',
            endTimeZone: '',
            notes: getControl(
              DateTime(startDate.year, startDate.month,
                  startDate.day + element.day! - 1),
            ),
          ),
        );
      }
    }

    return _AppointmentDataSource(appointments);
  }

  getStatusColor(DateTime dateTime) {
    if (patientAppointments
        .where((element) => element.slot!.date == dateTime)
        .isEmpty) {
      if (dateTime == today) {
        return Colors.grey;
      } else if (dateTime.isAfter(today)) {
        return Colors.black;
      } else {
        return Colors.red;
      }
    } else {
      if (dateTime == today) {
        return Colors.blue;
      } else {
        return Colors.green;
      }
    }
  }

  getStatus(DateTime dateTime) {
    if (patientAppointments
        .where((element) => element.slot!.date == dateTime)
        .isEmpty) {
      if (dateTime == today) {
        return "(Pending)";
      } else if (dateTime.isAfter(today)) {
        return "(Upcoming)";
      } else {
        return "(Missed)";
      }
    } else {
      if (dateTime == today) {
        return "(Booked)";
      } else {
        return "(Completed)";
      }
    }
  }

  getControl(DateTime dateTime) {
    if (patientAppointments
        .where((element) => element.slot!.date == dateTime)
        .isEmpty) {
      if (dateTime == today) {
        return "true";
      } else if (dateTime.isAfter(today)) {
        return "false";
      } else {
        return "true";
      }
    } else {
      if (dateTime == today) {
        return "false";
      } else {
        return "false";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment Calander"),
        leading: const BackButton(),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : activeSubscriptions.isNotEmpty
              ? SfCalendar(
                  showTodayButton: true,
                  showDatePickerButton: true,
                  view: CalendarView.month,
                  dataSource: _getCalendarDataSource(),
                  allowedViews: const [CalendarView.month, CalendarView.week],
                  monthViewSettings: const MonthViewSettings(
                    showAgenda: true,
                    agendaItemHeight: 80,
                    showTrailingAndLeadingDates: false,
                  ),
                  onTap: (selected) async {
                    if (selected.appointments!.isNotEmpty &&
                        selected.targetElement == CalendarElement.appointment) {
                      if (selected.appointments!.first!.notes == "true") {
                        List<UserModel> doctors =
                            await DoctorService.getExperts();
                        if (doctors.isNotEmpty) {
                          int doctor = doctors.indexWhere(
                            (element) => selected.appointments!.first!.subject
                                .toLowerCase()
                                .contains(element.doctorType!.toLowerCase()),
                          );
                          if (doctor != -1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorProfile(
                                  doctor: doctors[doctor],
                                ),
                              ),
                            );
                          } else {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const LandingScreen(
                            //       index: 1,
                            //     ),
                            //   ),
                            // );
                          }
                        } else {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const LandingScreen(
                          //       index: 1,
                          //     ),
                          //   ),
                          // );
                        }
                      }
                    }
                  },
                )
              : const SizedBox(),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
