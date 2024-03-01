import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:winhealth_admin_v2/components/patient_mini_card.dart';
import 'package:winhealth_admin_v2/models/appointment.dart';
import 'package:winhealth_admin_v2/models/package.dart';
import 'package:winhealth_admin_v2/models/subscription.dart';
import 'package:winhealth_admin_v2/models/task_list.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/appointment_service.dart';
import 'package:winhealth_admin_v2/services/patient_service.dart';
import 'package:winhealth_admin_v2/services/subscription_service.dart';
import 'package:winhealth_admin_v2/services/task_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';
import 'package:winhealth_admin_v2/utils/date_time_utils.dart';

class TaskView extends StatefulWidget {
  final UserModel currentUser;
  const TaskView({super.key, required this.currentUser});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  ScrollController scrollController = ScrollController();
  bool showbtn = false;
  DateTime? currentDate = DateTime.now();
  bool loading = true;
  List<UserModel> patients = [];
  List<UserModel> donePatients = [];
  List<UserModel> unDonePatients = [];
  List<Subscription> subscriptionLog = [];
  List<Package> plans = [];
  List<Task> tasks = [];
  Package? selectedPlan;
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
      donePatients.clear();
      unDonePatients.clear();
    });
    patients = await PatientService.getPatients();
    plans = await SubscriptionService.fetchSubscriptionPackages();
    selectedPlan = plans.first;
    tasks = await TaskService.fetchTasks(selectedPlan!.id!);
    for (UserModel element in patients) {
      subscriptionLog =
          await SubscriptionService.fetchActiveSubscriptionByUserIdAndPackageId(
              element.id, selectedPlan!.id!);
      if (subscriptionLog.isNotEmpty) {
        Subscription selectedSubscription = subscriptionLog.first;
        DateTime startDate = selectedSubscription.dateCreated!;
        DateTime today = DateTime.now().add(const Duration(days: 1));
        if (tasks[today.difference(startDate).inDays - 1].consultationTitle !=
            null) {
          List<Appointment> appointments =
              await AppointmentService.getAppointmentsByDateAndPatientId(
            element.id!,
            DateTimeUtils.apiFormattedDate(currentDate.toString()),
          );
          if (appointments.isNotEmpty) {
            donePatients.add(element);
          } else {
            unDonePatients.add(element);
          }
        } else {
          unDonePatients.add(element);
        }
      } else {
        unDonePatients.add(element);
      }
    }
    setState(() {
      selectedPlan = plans.first;
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
                        "Task View",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        runSpacing: 16,
                        spacing: 16,
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
                          SizedBox(
                            height: 50,
                            width: 300,
                            child: FormField<Package>(
                              builder: (FormFieldState<Package> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 10, 20, 20),
                                    errorStyle: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Package>(
                                      isExpanded: true,
                                      value: selectedPlan,
                                      hint: const Text("Select Plan"),
                                      items: plans
                                          .map<DropdownMenuItem<Package>>(
                                              (Package value) {
                                        return DropdownMenuItem<Package>(
                                          value: value,
                                          child: Text(value.title!),
                                        );
                                      }).toList(),
                                      onChanged: (Package? newValue) {
                                        setState(() {
                                          selectedPlan = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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
                      runSpacing: 16,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Booked Patients (${donePatients.length})",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            donePatients.isEmpty
                                ? const Text("No Patients")
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: donePatients
                                        .map(
                                          (e) => PatientMiniCard(
                                            patient: e,
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "UnBooked Patients (${unDonePatients.length})",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            unDonePatients.isEmpty
                                ? const Text("No Patients")
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: unDonePatients
                                        .map(
                                          (e) => PatientMiniCard(
                                            patient: e,
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
