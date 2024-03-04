import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/recommended_diet.dart';

var typeBreif = {
  'breakfast': 'Breakfast',
  'lunchanddinner': 'Lunch and Dinner',
  'snacks': 'Snacks',
  'junkfoods': 'Junk Foods',
  'others': 'Others',
};

class FoodItemCard extends StatelessWidget {
  final RecommendedDietItem recommendedDietItem;
  final bool showMenu;
  final VoidCallback onRemove;
  final VoidCallback onEdit;
  const FoodItemCard(
      {super.key,
      required this.recommendedDietItem,
      required this.onEdit,
      required this.onRemove,
      this.showMenu = true});

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
        child: Stack(
          children: [
            showMenu
                ? Align(
                    alignment: Alignment.topRight,
                    child: MenuAnchor(
                      builder: (BuildContext context, MenuController controller,
                          Widget? child) {
                        return IconButton(
                          onPressed: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                          icon: const Icon(Icons.more_horiz),
                          tooltip: 'Show menu',
                        );
                      },
                      menuChildren: [
                        MenuItemButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white),
                          ),
                          onPressed: onRemove,
                          child: const Text('Remove Item'),
                        ),
                        MenuItemButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white),
                          ),
                          onPressed: onEdit,
                          child: const Text('Edit Item'),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Text(
                      recommendedDietItem.foodItem!.name!.trim(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Wrap(
                  children: [
                    const Text(
                      "Recommended Quantity: x ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      recommendedDietItem.quantity!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      " Type: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      typeBreif[recommendedDietItem.foodItem!.type!]!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      " | FODMAP Type: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      recommendedDietItem.foodItem!.fodmapType!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Wrap(
                  children: [
                    const Text(
                      "Energy: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${recommendedDietItem.foodItem!.energy} KCal",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Carbohydrate: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${recommendedDietItem.foodItem!.cho} g",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Protien: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${recommendedDietItem.foodItem!.protien} g",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Unsaturated Fats: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${recommendedDietItem.foodItem!.unSaturatedFats} g",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Saturated Fats: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${recommendedDietItem.foodItem!.saturatedFats} g",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Fibre: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${recommendedDietItem.foodItem!.fibre} g",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Iron %: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${recommendedDietItem.foodItem!.ironPercentage} %",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Calcium %: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${recommendedDietItem.foodItem!.calciumPercentage} %",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Sodium: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${recommendedDietItem.foodItem!.sodium} g",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Vitamin A %: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${recommendedDietItem.foodItem!.vitaminAPercentage} %",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Vitamin C %: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${recommendedDietItem.foodItem!.vitaminCPercentage} %",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const Text(
                  "Other Instructions: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(
                  recommendedDietItem.otherInstruction!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const Text(
                  "Recipe: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(
                  recommendedDietItem.cookingInstruction!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
