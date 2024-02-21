import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/form_response.dart';

class FormResponseCard extends StatelessWidget {
  final FormResponse formResponse;
  const FormResponseCard({super.key, required this.formResponse});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: formResponse.answers!
              .map((e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "⦿ ${formResponse.form!.questions!.firstWhere((element) => element.formQuestionId!.id == e.formAnswersId!.question!).formQuestionId!.question!}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        "➼ ${e.formAnswersId!.response!.join("\n")}",
                        style: const TextStyle(fontSize: 18),
                      )
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
