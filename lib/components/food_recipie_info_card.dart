import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/food_item.dart';
import 'package:winhealth_admin_v2/models/food_item_model.dart';

class FoodRecipieInfoCard extends StatelessWidget {
  final FoodItemModel foodRecipieItem;
  const FoodRecipieInfoCard({super.key, required this.foodRecipieItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.4))),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Text(
                  foodRecipieItem.name!.trim(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const Divider(),
            const Text(
              "Ingredients: ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    "${foodRecipieItem.ingredients![index].item!.description!} , ${foodRecipieItem.ingredients![index].quantity!} (${foodRecipieItem.ingredients![index].standardizedCup!.standardizedCup!}, ${foodRecipieItem.ingredients![index].standardizedCup!.standardizedValue} ${foodRecipieItem.ingredients![index].standardizedCup!.standardizedUnit})",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: foodRecipieItem.ingredients![index].item!
                            .toJson()
                            .entries
                            .map(
                              (e) => e.value != null
                                  ? RichText(
                                      text: TextSpan(
                                        text: "${e.key}: ",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: e.value,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            )
                            .toList(),
                      ),
                    )
                  ],
                );
              },
              shrinkWrap: true,
              itemCount: foodRecipieItem.ingredients!.length,
            ),
            const Divider(),
            const Text(
              "Added on: ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              foodRecipieItem.dateCreated!.toIso8601String().split(".").first,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              "Cooking Instruction: ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              foodRecipieItem.cookingInstructions!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              "Special Instructions: ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              foodRecipieItem.specialNotes!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
