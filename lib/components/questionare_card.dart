import 'package:flutter/material.dart';

class QuestionareCard extends StatelessWidget {
  final String question;
  final String answer;
  const QuestionareCard(
      {super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.question_mark),
              const SizedBox(
                width: 8,
              ),
              Text(
                "Q-> $question",
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.abc),
              const SizedBox(
                width: 8,
              ),
              Text(
                "A-> $answer",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
