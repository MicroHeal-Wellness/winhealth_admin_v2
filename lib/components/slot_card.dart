import 'package:flutter/material.dart';

class SlotsCard extends StatelessWidget {
  final String title;
  final Color color;
  const SlotsCard({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: color,
          
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 4)),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.alarm),
          const SizedBox(
            width: 8,
          ),
          Text(
            title,
          ),
        ],
      ),
    );
  }
}
