// ignore_for_file: equal_keys_in_map, use_build_context_synchronously

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:winhealth_admin_v2/models/patient_group.dart';
import 'package:winhealth_admin_v2/services/partner_group_service.dart';
import 'package:winhealth_admin_v2/services/patient_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class CreatePatientScreen extends StatefulWidget {
  const CreatePatientScreen({super.key});

  @override
  State<CreatePatientScreen> createState() => _CreatePatientScreenState();
}

class _CreatePatientScreenState extends State<CreatePatientScreen> {
  List<PatientGroup> patientGroups = [];
  PatientGroup? selectedPatientGroup;
  bool showbtn = false;
  bool loading = false;
  bool isLoading = false;
  ScrollController scrollController = ScrollController();
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
    // patientGroups.add(PatientGroup(id: "0", name: "All"));
    patientGroups = await PatientGroupService.fetchAllPatientGroups();
    setState(() {
      selectedPatientGroup = patientGroups.first;
      loading = false;
    });
  }

  String selectedDiet = "Vegetarian";
  List<String> exerciseList = [
    "never",
    "light",
    "moderate",
    "active",
    "highlyactive"
  ];
  Map<String, String> exerciseListEng = {
    "never": "Never",
    "light": "Light",
    "moderate": "Moderate",
    "active": "Active",
    "highlyactive": "Highly Active"
  };
  String selectedExercise = "never";
  int heightCm = 55;
  int weightKg = 25;
  String weightUnit = "kg";
  List<String> weightUnitList = ["kg", "lb"];
  List<String> pregnancyResponseList = ["Yes", "No"];
  List<String> genderList = ["Male", "Female", "Diverse"];
  List<String> speaks = [];
  List<String> langs = [
    "english",
    "telugu",
    "hindi",
    "kannada",
    "malayalam",
    "urdu"
  ];
  List<String> dietList = [
    "Vegetarian",
    "Non-Vegetarian",
    "Eggetarian",
    "Vegan"
  ];
  String selectedPregnantResponse = "No";
  String countryCode = "+91";
  String selectedGender = "Male";
  bool isFemale = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController(
    text: DateFormat("yyyy-MM-dd").format(
      DateTime(
          DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
    ),
  );
  TextEditingController heightController = TextEditingController(text: "0");
  TextEditingController weightController = TextEditingController(text: "0");
  TextEditingController genderController = TextEditingController();
  TextEditingController exerciseController = TextEditingController();
  TextEditingController speaksController = TextEditingController();
  TextEditingController dietController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      BackButton(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Create Patient",
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
                  Form(
                    key: formKey,
                    child: Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Enter First Name:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: firstNameController,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Enter First Name',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                border: roundedGreyBorder,
                                focusedBorder: roundedGreyBorder,
                                enabledBorder: roundedGreyBorder,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return "First Name must not empty";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text(
                              "Enter Last Name:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: lastNameController,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Enter Last Name',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                border: roundedGreyBorder,
                                focusedBorder: roundedGreyBorder,
                                enabledBorder: roundedGreyBorder,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return "Last Name must not empty";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text(
                              "Enter Email Address:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Enter Email Address',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                fillColor: Colors.transparent,
                                filled: true,
                                border: roundedGreyBorder,
                                focusedBorder: roundedGreyBorder,
                                enabledBorder: roundedGreyBorder,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email id';
                                }
                                if (!RegExp(
                                        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                    .hasMatch(emailController.text)) {
                                  return 'Please enter a valid email id';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text(
                              "Enter Phone Number:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                prefixIcon: CountryCodePicker(
                                  onChanged: (CountryCode code) {
                                    setState(() {
                                      countryCode = code.dialCode!;
                                    });
                                  },
                                  initialSelection: countryCode,
                                  favorite: const ['+91', 'IN'],
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                ),
                                hintText: "Enter 10 digit phone nymber",
                                border: roundedGreyBorder,
                                focusedBorder: roundedGreyBorder,
                                enabledBorder: roundedGreyBorder,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              maxLength: 10,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Phone number cant be empty";
                                }
                                if (value.length != 10) {
                                  return "Enter valid number";
                                }
                                return null;
                              },
                              controller: phoneController,
                            ),
                            const Text(
                              "Speaks",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => CheckboxListTile(
                                value: speaks.contains(langs[index]),
                                title: Text(langCode(langs[index])),
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) => setState(
                                  () {
                                    if (value!) {
                                      speaks.add(langs[index]);
                                    } else {
                                      speaks.remove(langs[index]);
                                    }
                                  },
                                ),
                              ),
                              itemCount: langs.length,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'D.O.B',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: dobController,
                              textInputAction: TextInputAction.next,
                              readOnly: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                hintText: "Enter DOB",
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                                isDense: true,
                                border: roundedGreyBorder,
                                enabledBorder: roundedGreyBorder,
                                disabledBorder: roundedGreyBorder,
                                errorBorder: roundedGreyBorder,
                                focusedBorder: roundedGreyBorder,
                                prefixIcon: GestureDetector(
                                  child: const Icon(Icons.calendar_month),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      builder: (BuildContext context, child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            primaryColor: primaryColor,
                                            colorScheme:
                                                const ColorScheme.light(
                                                    primary: primaryColor),
                                            buttonTheme: const ButtonThemeData(
                                                textTheme:
                                                    ButtonTextTheme.primary),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      initialDate:
                                          DateTime.parse(dobController.text),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime(
                                          DateTime.now().year - 16,
                                          DateTime.now().month,
                                          DateTime.now().day),
                                    );
                                    if (pickedDate != null) {
                                      dobController.text =
                                          DateFormat("yyyy-MM-dd")
                                              .format(pickedDate);
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return "Select Date of Birth";
                                  } else if (DateTime.now()
                                          .difference(DateTime.parse(value))
                                          .inDays <
                                      6205) {
                                    return "Age Must be 18.";
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            const Text(
                              "Patient Group",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButton<PatientGroup>(
                                value: selectedPatientGroup,
                                onChanged: (newValue) {
                                  selectedPatientGroup = newValue!;
                                  if (selectedGender == "Female") {
                                    isFemale = true;
                                  } else {
                                    isFemale = false;
                                  }
                                  setState(() {});
                                },
                                isDense: true,
                                isExpanded: true,
                                icon: const Icon(Icons.expand_more_outlined),
                                items: patientGroups.map((PatientGroup e) {
                                  return DropdownMenuItem<PatientGroup>(
                                    value: e,
                                    child: Text(e.name!),
                                  );
                                }).toList(),
                                underline: Container(),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            const Text(
                              "Gender",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButton<String>(
                                value: selectedGender,
                                onChanged: (newValue) {
                                  selectedGender = newValue!;
                                  if (selectedGender == "Female") {
                                    isFemale = true;
                                  } else {
                                    isFemale = false;
                                  }
                                  setState(() {});
                                },
                                isDense: true,
                                isExpanded: true,
                                icon: const Icon(Icons.expand_more_outlined),
                                items: genderList.map((String e) {
                                  return DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                                underline: Container(),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            if (isFemale)
                              const Text(
                                "Are you pregnant?",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            if (isFemale) const SizedBox(height: 8),
                            if (isFemale)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedPregnantResponse,
                                  onChanged: (newValue) {
                                    selectedPregnantResponse = newValue!;
                                    setState(() {});
                                  },
                                  isDense: true,
                                  isExpanded: true,
                                  icon: const Icon(Icons.expand_more_outlined),
                                  items: pregnancyResponseList.map((String e) {
                                    return DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList(),
                                  underline: Container(),
                                ),
                              ),
                            if (isFemale)
                              const SizedBox(
                                height: 24,
                              ),
                            const Text(
                              "Height",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: heightController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              validator: (value) {
                                if (value == null) {
                                  return "Height must not empty";
                                }
                                if (value == "0") {
                                  return "Height must not zero";
                                }
                                return null;
                              },
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 240,
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Text(
                                                "Centimetre",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: CupertinoPicker(
                                                        scrollController:
                                                            FixedExtentScrollController(
                                                                initialItem:
                                                                    heightCm -
                                                                        55),
                                                        itemExtent: 32,
                                                        backgroundColor:
                                                            Colors.white,
                                                        onSelectedItemChanged:
                                                            (int index) {
                                                          setState(() {
                                                            heightCm =
                                                                55 + index;
                                                            heightController
                                                                    .text =
                                                                "$heightCm";
                                                          });
                                                        },
                                                        children: List<
                                                                Widget>.generate(
                                                            200, (int index) {
                                                          return Center(
                                                            child: Text(
                                                                '${55 + index}'),
                                                          );
                                                        })),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                hintText: "Height",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                                suffix: Text(
                                  "cm",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                isDense: true,
                                border: roundedGreyBorder,
                                enabledBorder: roundedGreyBorder,
                                disabledBorder: roundedGreyBorder,
                                errorBorder: roundedGreyBorder,
                                focusedBorder: roundedGreyBorder,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              '${(int.parse(heightController.text) / 30.48).floor()} feet ${(int.parse(heightController.text) / 2.54 % 12).round()} inches',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              "Weight",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: weightController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 200,
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Text(
                                                "Kilogram",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: CupertinoPicker(
                                                        scrollController:
                                                            FixedExtentScrollController(
                                                                initialItem:
                                                                    weightKg -
                                                                        25),
                                                        itemExtent: 32,
                                                        backgroundColor:
                                                            Colors.white,
                                                        onSelectedItemChanged:
                                                            (int index) {
                                                          setState(() {
                                                            weightKg =
                                                                25 + index;
                                                            weightController
                                                                    .text =
                                                                "$weightKg";
                                                          });
                                                        },
                                                        children: List<
                                                                Widget>.generate(
                                                            125, (int index) {
                                                          return Center(
                                                            child: Text(
                                                                '${25 + index}'),
                                                          );
                                                        })),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Weight must not empty";
                                }
                                if (value == "0") {
                                  return "Weight must not zero";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                hintText: "Weight",
                                suffix: GestureDetector(
                                  onTap: () {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (_) => SizedBox(
                                        height: 100,
                                        child: CupertinoPicker(
                                          backgroundColor: Colors.white,
                                          itemExtent: 30,
                                          useMagnifier: true,
                                          scrollController:
                                              FixedExtentScrollController(
                                                  initialItem: 0),
                                          children: weightUnitList
                                              .map((e) => Text(e))
                                              .toList(),
                                          onSelectedItemChanged: (value) {
                                            setState(() {
                                              weightUnit =
                                                  weightUnitList[value];
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    weightUnit,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                                isDense: true,
                                border: roundedGreyBorder,
                                enabledBorder: roundedGreyBorder,
                                disabledBorder: roundedGreyBorder,
                                errorBorder: roundedGreyBorder,
                                focusedBorder: roundedGreyBorder,
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            const Text(
                              "How Often do you exercise?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButton<String>(
                                value: selectedExercise,
                                onChanged: (newValue) {
                                  selectedExercise = newValue!;
                                  setState(() {});
                                },
                                isDense: true,
                                isExpanded: true,
                                icon: const Icon(Icons.expand_more_outlined),
                                items: exerciseList.map((String e) {
                                  return DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(exerciseListEng[e]!),
                                  );
                                }).toList(),
                                underline: Container(),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            const Text(
                              "Diet",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButton<String>(
                                value: selectedDiet,
                                onChanged: (newValue) {
                                  selectedDiet = newValue!;
                                  setState(() {});
                                },
                                isDense: true,
                                isExpanded: true,
                                icon: const Icon(Icons.expand_more_outlined),
                                items: dietList.map((String e) {
                                  return DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                                underline: Container(),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            MaterialButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  final Map<String, dynamic> params = {
                                    'first_name': firstNameController.text,
                                    'last_name': firstNameController.text,
                                    'email': emailController.text,
                                    'phone_number': phoneController.text,
                                    'dob': dobController.text,
                                    'gender': selectedGender,
                                    'pregnant': selectedPregnantResponse
                                                .toLowerCase() ==
                                            "no"
                                        ? false
                                        : true,
                                    'height':
                                        double.parse(heightController.text),
                                    'exercise_type': selectedExercise,
                                    'weight':
                                        double.parse(weightController.text),
                                    'diet': selectedDiet,
                                    'patient_group':
                                        selectedPatientGroup == null
                                            ? patientGroups.first
                                            : selectedPatientGroup!.id,
                                    'speaks': speaks,
                                    'role':
                                        "a4f8c484-438d-4c9e-ac17-2b1c7ecd57e1",
                                  };
                                  setState(() {
                                    isLoading = true;
                                  });
                                  bool resp =
                                      await PatientService.createPatient(
                                    params,
                                  );
                                  if (resp) {
                                    Fluttertoast.showToast(
                                        msg: "Patient Added successful");
                                    Navigator.of(context).pop();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Patient addition failed");
                                  }
                                }
                              },
                              color: primaryColor,
                              height: 48,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              minWidth: MediaQuery.of(context).size.width,
                              child: const Text(
                                "Add Patient",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
