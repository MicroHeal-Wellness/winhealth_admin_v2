import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/form_response.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class FormCard extends StatelessWidget {
  final FormResponse formResponse;
  final bool isSelected;
  const FormCard(
      {super.key, required this.formResponse, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
        ),
        color: isSelected ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formResponse.form!.name!,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black),
            ),
            Text(
              "Last Filled/Update: ${formResponse.dateUpdated == null ? formResponse.dateCreated.toString().split(".").first.split("T").join(" ") : formResponse.dateUpdated.toString().split(".").first.split("T").join(" ")}",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: isSelected ? Colors.white : Colors.black),
            ),

            Text(
              "No of Questions: ${formResponse.answers!.length.toString().padLeft(2, "0")}",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: isSelected ? Colors.white : Colors.black),
            ),
            // const SizedBox(
            //   height: 16,
            // ),
            // MaterialButton(
            //   onPressed: () {},
            //   color: primaryColor,
            //   minWidth: 200,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: const Padding(
            //     padding: EdgeInsets.all(8.0),
            //     child: Text(
            //       "View Response",
            //       style: TextStyle(
            //         fontSize: 18,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
