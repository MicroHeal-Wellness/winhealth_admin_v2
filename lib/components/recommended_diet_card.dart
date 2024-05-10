import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/diet_model.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

var typeBreif = {
  'morning': 'Mornning 8 AM - 11 AM',
  'afternoon': 'Afternoon 12 PM - 2 PM',
  'evening': 'Evening 5 PM - 7 PM',
  'night': 'Night 8 PM - 11 PM',
};

class RecommendedDietCard extends StatelessWidget {
  final DietModel recommendedDiet;
  final VoidCallback onDelete;
  final bool isSelected;
  const RecommendedDietCard(
      {super.key,
      required this.recommendedDiet,
      required this.onDelete,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    // typeBreif[recommendedDiet.type!]!,
                    recommendedDiet.name!,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete),
                  )
                ],
              ),
              const Divider(),
              Text(
                "Total Items: ${recommendedDiet.items!.length.toString().padLeft(2, "0")}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
