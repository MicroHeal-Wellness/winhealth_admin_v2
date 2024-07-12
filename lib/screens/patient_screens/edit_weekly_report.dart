import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/models/weekly_patient_nutrient_report_model.dart';
import 'package:winhealth_admin_v2/services/weekly_nutrient_report_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';
import 'package:winhealth_admin_v2/utils/wh_slider.dart';

class EditWeeklyReport extends StatefulWidget {
  final WeeklyPatientNutrientReportModel weeklyPatientReportModel;
  const EditWeeklyReport({
    super.key,
    required this.weeklyPatientReportModel,
  });

  @override
  State<EditWeeklyReport> createState() => _EditWeeklyhReportState();
}

class _EditWeeklyhReportState extends State<EditWeeklyReport> {
  bool showbtn = false;
  bool loading = true;
  ScrollController scrollController = ScrollController();
  TextEditingController weekController = TextEditingController();
  double stomachPain = 0;
  double stomachPainNos = 0;
  double acidReflex = 0;
  double acidReflexNos = 0;
  double acidity = 0;
  double acidityNos = 0;
  double heartBurn = 0;
  double heartBurnNos = 0;
  double bloating = 0;
  double bloatingNos = 0;
  double burping = 0;
  double burpingNos = 0;
  double farting = 0;
  double fartingNos = 0;
  double constipation = 0;
  double constipationNos = 0;
  double diarrhoea = 0;
  double diarrhoeaNos = 0;

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
    setInitstate();
    super.initState();
  }

  setInitstate() {
    setState(() {
      loading = true;
    });
    weekController.text = widget.weeklyPatientReportModel.week ?? "";
    stomachPain = widget.weeklyPatientReportModel.stomachPain!.toDouble();
    stomachPainNos = widget.weeklyPatientReportModel.stomachPainNos!.toDouble();
    acidReflex = widget.weeklyPatientReportModel.acidReflux!.toDouble();
    acidReflexNos = widget.weeklyPatientReportModel.acidRefluxNos!.toDouble();
    acidity = widget.weeklyPatientReportModel.acidity!.toDouble();
    acidityNos = widget.weeklyPatientReportModel.acidityNos!.toDouble();
    heartBurn = widget.weeklyPatientReportModel.heartBurn!.toDouble();
    heartBurnNos = widget.weeklyPatientReportModel.heartBurnNos!.toDouble();
    bloating = widget.weeklyPatientReportModel.bloating!.toDouble();
    bloatingNos = widget.weeklyPatientReportModel.bloatingNos!.toDouble();
    burping = widget.weeklyPatientReportModel.burping!.toDouble();
    burpingNos = widget.weeklyPatientReportModel.burpingNos!.toDouble();
    farting = widget.weeklyPatientReportModel.farting!.toDouble();
    fartingNos = widget.weeklyPatientReportModel.fartingNos!.toDouble();
    constipation = widget.weeklyPatientReportModel.constipation!.toDouble();
    constipationNos =
        widget.weeklyPatientReportModel.constipationNos!.toDouble();
    diarrhoea = widget.weeklyPatientReportModel.diarrhoea!.toDouble();
    diarrhoeaNos = widget.weeklyPatientReportModel.diarrhoeaNos!.toDouble();
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
              child: Column(
                children: [
                  const Row(
                    children: [
                      BackButton(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Edit weekly patient report",
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
                                hintText: 'Enter Report Title:',
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
                              "Stomach Pain Intensity: $stomachPain",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: stomachPain,
                                onChanged: (value) {
                                  setState(() {
                                    stomachPain = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Stomach Pain Frequency: $stomachPainNos",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: stomachPainNos,
                                onChanged: (value) {
                                  setState(() {
                                    stomachPainNos = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Acid Reflux Intensity: $acidReflex",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: acidReflex,
                                onChanged: (value) {
                                  setState(() {
                                    acidReflex = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Acid Reflux Frequency: $acidReflexNos",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: acidReflexNos,
                                onChanged: (value) {
                                  setState(() {
                                    acidReflexNos = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Acidity Intensity: $acidity",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: acidity,
                                onChanged: (value) {
                                  setState(() {
                                    acidity = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Acidity Frequency: $acidityNos",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: acidityNos,
                                onChanged: (value) {
                                  setState(() {
                                    acidityNos = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Heart Burn Intensity: $heartBurn",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: heartBurn,
                                onChanged: (value) {
                                  setState(() {
                                    heartBurn = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Heart Burn Frequency: $heartBurnNos",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: heartBurnNos,
                                onChanged: (value) {
                                  setState(() {
                                    heartBurnNos = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Bloating Intensity: $bloating",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: bloating,
                                onChanged: (value) {
                                  setState(() {
                                    bloating = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Bloating Frequency: $bloatingNos",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: bloatingNos,
                                onChanged: (value) {
                                  setState(() {
                                    bloatingNos = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Burping Intensity: $burping",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: burping,
                                onChanged: (value) {
                                  setState(() {
                                    burping = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Burping Frequency: $burpingNos",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: burpingNos,
                                onChanged: (value) {
                                  setState(() {
                                    burpingNos = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Farting Intensity: $farting",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: farting,
                                onChanged: (value) {
                                  setState(() {
                                    farting = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Farting Frequency: $fartingNos",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: fartingNos,
                                onChanged: (value) {
                                  setState(() {
                                    fartingNos = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Constipation Intensity: $constipation",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: constipation,
                                onChanged: (value) {
                                  setState(() {
                                    constipation = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Constipation Frequency: $constipationNos",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: constipationNos,
                                onChanged: (value) {
                                  setState(() {
                                    constipationNos = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Diarrhoea Intensity: $diarrhoea",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: diarrhoea,
                                onChanged: (value) {
                                  setState(() {
                                    diarrhoea = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Diarrhoea Frequency: $diarrhoeaNos",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: WHSlider(
                                activeColor: primaryColor2,
                                divisions: 10,
                                max: 10,
                                value: diarrhoeaNos,
                                onChanged: (value) {
                                  setState(() {
                                    diarrhoeaNos = value;
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
                                  bool resp = await WeeklyNutrientReportService
                                      .updateWeeklyNutrientReport(widget.weeklyPatientReportModel.id,
                                    {
                                      "stomach_pain": stomachPain,
                                      "stomach_pain_nos": stomachPainNos,
                                      "acid_reflux": acidReflex,
                                      "acid_reflux_nos": acidReflexNos,
                                      "acidity": acidity,
                                      "acidity_nos": acidityNos,
                                      "heart_burn": heartBurn,
                                      "heart_burn_nos": heartBurnNos,
                                      "bloating": bloating,
                                      "bloating_nos": bloatingNos,
                                      "burping": burping,
                                      "burping_nos": burpingNos,
                                      "farting": farting,
                                      "farting_nos": fartingNos,
                                      "constipation": constipation,
                                      "constipation_nos": constipationNos,
                                      "diarrhoea": diarrhoea,
                                      "diarrhoea_nos": diarrhoeaNos,
                                      "week": weekController.text,
                                    },
                                  );
                                  if (resp) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Weekly report udpated successfully.");
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Some issue occured while updating Weekly report.");
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
                                  "Update report",
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
