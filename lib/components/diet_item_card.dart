import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/diet_item_model.dart';

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
                    // const Text(
                    //   " Type: ",
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w900,
                    //   ),
                    // ),
                    // Text(
                    //   recommendedDietItem.foodItem!.name!,
                    //   style: const TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    // const Text(
                    //   " | FODMAP Type: ",
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w900,
                    //   ),
                    // ),
                    // Text(
                    //   'recommendedDietItem.foodItem!.fodmapType!.toUpperCase()',
                    //   style: const TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
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
                        "${recommendedDietItem.foodItem!.ingredients![index].item!.description!} , ${recommendedDietItem.foodItem!.ingredients![index].quantity!} ${recommendedDietItem.foodItem!.ingredients![index].unit}",
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
                            children: recommendedDietItem
                                .foodItem!.ingredients![index].item!
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
