// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/components/form_card.dart';
import 'package:winhealth_admin_v2/components/form_response.dart';
import 'package:winhealth_admin_v2/models/form_response.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/add_response_screen.dart';
import 'package:winhealth_admin_v2/services/questionare_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class FormsHome extends StatefulWidget {
  final UserModel patient;
  const FormsHome({
    super.key,
    required this.patient,
  });

  @override
  State<FormsHome> createState() => _FormsHomeState();
}

class _FormsHomeState extends State<FormsHome> {
  bool showbtn = false;
  bool loading = false;
  bool showResponse = false;
  ScrollController scrollController = ScrollController();
  List<FormResponse> formResponses = [];
  List<QuestionForm> forms = [];
  FormResponse? selectedFormResponse;
  @override
  void initState() {
    super.initState();
    getInitData();
  }

  getInitData() async {
    setState(() {
      loading = true;
    });
    formResponses =
        await QuestionareService.getAllFormAnswerByUserId(widget.patient.id!);
    forms = await QuestionareService.getAllNonAppForms();
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
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
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
                    Row(
                      children: [
                        const BackButton(),
                        const SizedBox(
                          width: 32,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${widget.patient.firstName}'s Form Responses",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        MaterialButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddResponsePage(
                                  patient: widget.patient,
                                ),
                              ),
                            );
                            await getInitData();
                          },
                          color: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Add Response",
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
                        Expanded(
                          flex: 1,
                          child: formResponses.isEmpty
                              ? const Center(
                                  child: Text("No Form Response Found"),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (selectedFormResponse != null &&
                                            selectedFormResponse!.id ==
                                                formResponses[index].id) {
                                          setState(() {
                                            selectedFormResponse = null;
                                          });
                                        } else {
                                          setState(() {
                                            selectedFormResponse =
                                                formResponses[index];
                                          });
                                        }
                                      },
                                      child: FormCard(
                                        formResponse: formResponses[index],
                                        isSelected:
                                            selectedFormResponse != null &&
                                                selectedFormResponse!.id ==
                                                    formResponses[index].id,
                                      ),
                                    );
                                  },
                                  itemCount: formResponses.length,
                                ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Form Response Info",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              selectedFormResponse != null
                                  ? Text(
                                      "Form: ${selectedFormResponse!.form!.name}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const Text(
                                      "Select a form to show responses",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                              selectedFormResponse == null
                                  ? const SizedBox()
                                  : const SizedBox(
                                      height: 16,
                                    ),
                              selectedFormResponse == null
                                  ? const SizedBox()
                                  : FormResponseCard(
                                      formResponse: selectedFormResponse!,
                                    )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  addResponseDialogBoxPopup() {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Choose Form to add response to"),
        content: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Available forms for ${widget.patient.firstName}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: forms
                  .map(
                    (e) => OutlinedButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FormInputScreen(
                                form: e, patient: widget.patient),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          e.name!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    });
  }
}
