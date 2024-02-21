import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/screens/form_builder/add_form.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

import '../../models/form_response.dart';

class PatientFormBuilder extends StatelessWidget {
  PatientFormBuilder({super.key});

  List<FormResponse> dummyFormResponses = List<FormResponse>.generate(
    6,
    (index) => FormResponse(
      id: 'id$index',
      userCreated: 'user$index',
      patient: 'patient$index',
      dateCreated: DateTime.now(),
      userUpdated: 'userUpdated$index',
      dateUpdated: 'dateUpdated$index',
      answers: List<Answer>.generate(
        3,
        (answerIndex) => Answer(
            // Fill this with the properties of your Answer class

            ),
      ),
      form: QuestionForm(
          // Fill this with the properties of your QuestionForm class
          ),
    ),
  );

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: dummyFormResponses.isEmpty
            ? Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  child: const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "No Forms Created Yet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Click on the + button on the top right corner to create a new form",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]),
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return availableForm(index);
                },
                itemCount: dummyFormResponses.length,
              ));
  }

  PreferredSize appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 32, width: double.infinity), // Add some padding
            Text(
              "Patient Form Builder",
              softWrap: true,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Add Form
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddForm(),
                  ),
                );
              },
              child: const Text(
                "Add Form",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container availableForm(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withOpacity(0.4),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(dummyFormResponses[index].form?.name ?? "Form Name",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Last Updated: ${dummyFormResponses[index].dateUpdated?.toString().split(".").first.split("T").join(" ")}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )),
            Text(
                "No of Questions: ${dummyFormResponses[index].answers?.length.toString().padLeft(2, "0")}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {},
        ),
      ),
    );
  }
}
