import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/ingredient_model.dart';

class NutrientBox extends StatelessWidget {
  final IngredientModel ingredientModel;
  const NutrientBox({super.key, required this.ingredientModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 16, bottom: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          RichText(
            text: TextSpan(
              text: "Id: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Type: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Description: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Category: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Protein: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.protein,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Total fat: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.totalFat,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Total dietary fiber: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.totalDietaryFiber,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Insoluble dietary fiber: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.insolubleDf,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Soluble dietary fiber: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.solubleDf,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Carbohydrates: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.carbohydrates,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Energy kcal: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.energyKcal,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Thiamine: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.thiamineB1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Riboflavin: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.riboflavinB2,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Niacin: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.niacinB3,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Pantothenic acid: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.pantotenicAcidB5,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Total b6: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.totalB6,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Biotin: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.biotinB7,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Total folates: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.totalFolatesB9,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Vit A: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.vitA,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Vit E: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.vitE,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "VIT K2: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.vitK2,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Calcium: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.cadmiumCd,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Iron: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.ironFe,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Magnesium: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.magnesiumMg,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Manganese: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.manganeseMn,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Nickel: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.nickelNi,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Phosphorous: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.phosphorousP,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Potassium: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.potassiumK,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Selenium: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.seleniumSe,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Sodium: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.sodiumNa,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Zinc: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ingredientModel.zincZn,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
