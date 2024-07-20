import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/models/weekly_patient_psyc_report_model.dart';
import 'package:winhealth_admin_v2/services/weekly_nutrient_report_service.dart';
import 'package:winhealth_admin_v2/services/weekly_psyc_report_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';
import 'package:winhealth_admin_v2/utils/wh_slider.dart';

class AddWeeklyPsycReport extends StatefulWidget {
  final UserModel patient;
  const AddWeeklyPsycReport({super.key, required this.patient});

  @override
  State<AddWeeklyPsycReport> createState() => _AddWeeklyPsycReportState();
}

class _AddWeeklyPsycReportState extends State<AddWeeklyPsycReport> {
  bool showbtn = false;
  ScrollController scrollController = ScrollController();
  TextEditingController weekController = TextEditingController();
  double perfectionistictSelfPresentationScale = 27;
  double perceivedStressScale = 0;
  double beckAnxietyInventory = 0;
  double beckDepressionInventory = 0;
  double ibsSss = 0;
  double the36Qol = 34;
  double das21 = 0;
  double eq5d5l = 5;

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
    super.initState();
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
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Row(
              children: [
                BackButton(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Add Weekly Patient Psyc Report",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Report Title",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: weekController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Enter Week name:',
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          fillColor: Colors.transparent,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Perfectionistict Self Presentation Scale: $perfectionistictSelfPresentationScale",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.only(left: 4, right: 8),
                        child: WHSlider(
                          activeColor:
                              Colors.blue, // Replace with your primaryColor2
                          min: 27,
                          divisions: 162,
                          max: 189,
                          value: perfectionistictSelfPresentationScale,
                          onChanged: (value) {
                            setState(() {
                              perfectionistictSelfPresentationScale = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Perceived Stress Scale: $perceivedStressScale",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.only(left: 4, right: 8),
                        child: WHSlider(
                          activeColor:
                              Colors.blue, // Replace with your primaryColor2
                          min: 0,
                          divisions: 40,
                          max: 40,
                          value: perceivedStressScale,
                          onChanged: (value) {
                            setState(() {
                              perceivedStressScale = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Beck Anxiety Inventory: $beckAnxietyInventory",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.only(left: 4, right: 8),
                        child: WHSlider(
                          activeColor:
                              Colors.blue, // Replace with your primaryColor2
                          min: 0,
                          divisions: 63,
                          max: 63,
                          value: beckAnxietyInventory,
                          onChanged: (value) {
                            setState(() {
                              beckAnxietyInventory = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Beck Depression Inventory: $beckDepressionInventory",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.only(left: 4, right: 8),
                        child: WHSlider(
                          activeColor:
                              Colors.blue, // Replace with your primaryColor2
                          min: 0,
                          divisions: 84,
                          max: 84,
                          value: beckDepressionInventory,
                          onChanged: (value) {
                            setState(() {
                              beckDepressionInventory = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "IBS SSS: $ibsSss",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.only(left: 4, right: 8),
                        child: WHSlider(
                          activeColor:
                              Colors.blue, // Replace with your primaryColor2
                          min: 0,
                          divisions: 500,
                          max: 500,
                          value: ibsSss,
                          onChanged: (value) {
                            setState(() {
                              ibsSss = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "36 QOL: $the36Qol",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.only(left: 4, right: 8),
                        child: WHSlider(
                          activeColor:
                              Colors.blue, // Replace with your primaryColor2
                          min: 34,
                          divisions: 136,
                          max: 170,
                          value: the36Qol,
                          onChanged: (value) {
                            setState(() {
                              the36Qol = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "DAS 21: $das21",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.only(left: 4, right: 8),
                        child: WHSlider(
                          activeColor:
                              Colors.blue, // Replace with your primaryColor2
                          min: 0,
                          divisions: 63,
                          max: 63,
                          value: das21,
                          onChanged: (value) {
                            setState(() {
                              das21 = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "EQ 5D 5L: $eq5d5l",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.only(left: 4, right: 8),
                        child: WHSlider(
                          activeColor:
                              Colors.blue, // Replace with your primaryColor2
                          min: 5,
                          divisions: 20,
                          max: 25,
                          value: eq5d5l,
                          onChanged: (value) {
                            setState(() {
                              eq5d5l = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          if (weekController.text.isNotEmpty) {
                            bool resp = await WeeklyPsycReportService
                                .createWeeklyPsycReport(
                              {
                                "perfectionistict_self_presentation_scale":
                                    perfectionistictSelfPresentationScale,
                                "perceived_stress_scale": perceivedStressScale,
                                "beck_anxiety_inventory": beckAnxietyInventory,
                                "beck_depression_inventory":
                                    beckDepressionInventory,
                                "ibs_sss": ibsSss,
                                "36_qol": the36Qol,
                                "das_21": das21,
                                "eq_5d_5l": eq5d5l,
                                "week": weekController.text,
                                "patient": widget.patient.id,
                              },
                            );
                            if (resp) {
                              Fluttertoast.showToast(
                                  msg: "Weekly report added successfully.");
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Some issue occured while adding Weekly report.");
                            }
                            Navigator.of(context).pop();
                          } else {
                            Fluttertoast.showToast(
                                msg: "Report Title is mandatory");
                          }
                        },
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Add report",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
