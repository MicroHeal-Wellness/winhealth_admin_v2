import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:winhealth_admin_v2/components/nutrient_data_box.dart';
import 'package:winhealth_admin_v2/models/diet_item_model.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class DietItemCard extends StatelessWidget {
  final DietItemModel recommendedDietItem;
  final bool showMenu;
  final VoidCallback onRemove;
  final VoidCallback onEdit;
  const DietItemCard(
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
                      recommendedDietItem.quantity!.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
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
                        "${recommendedDietItem.foodItem!.ingredients![index].item!.description!} x ${recommendedDietItem.foodItem!.ingredients![index].quantity!} (${recommendedDietItem.foodItem!.ingredients![index].standardizedCup!.standardizedCup!}, ${recommendedDietItem.foodItem!.ingredients![index].standardizedCup!.standardizedValue} ${recommendedDietItem.foodItem!.ingredients![index].standardizedCup!.standardizedUnit})",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      children: [
                         Padding(
                          padding:
                              const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                "** The following nutrient data is per${recommendedDietItem.foodItem!.ingredients![index].item!.type != "American Foods" ? " 100 gm" : ""} serving.", style: const TextStyle(fontSize: 18, color: Colors.red),),
                          ),
                        ),
                        NutrientBox(
                            ingredientModel: recommendedDietItem
                                .foodItem!.ingredients![index].item!),
                      ],
                    );
                  },
                  shrinkWrap: true,
                  itemCount: recommendedDietItem.foodItem!.ingredients!.length,
                ),
                // Wrap(
                //   children: [
                //   ],
                // ),const Divider(),
                const Text(
                  "Cooking Instruction: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(
                  recommendedDietItem.foodItem!.cookingInstructions!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const Text(
                  "Food Item Specific Notes: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(
                  recommendedDietItem.foodItem!.specialNotes!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const Divider(),
                const Text(
                  "Recipie Specific Notes: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(
                  recommendedDietItem.specialInstruction!,
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
