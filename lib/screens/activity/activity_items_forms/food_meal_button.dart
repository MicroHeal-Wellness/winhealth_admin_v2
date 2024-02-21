import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/screens/activity/activity_items_forms/food_meal_form.dart';

import '../../../models/food_item.dart';
import '../../../utils/activity_utils.dart';

class FoodMealButton extends StatelessWidget {
  final String mealName;
  final List<FoodItem> mealItems;
  final Function(List<FoodItem> value) onChange;

  const FoodMealButton({
    Key? key,
    required this.mealName,
    required this.mealItems,
    required this.onChange,
  }) : super(key: key);

  void onClickFoodMeal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodMealForm(
          mealName: mealName,
          mealItems: mealItems,
          onChange: onChange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color itemColor = getFoodMealColor(mealName);
    return GestureDetector(
        onTap: () => onClickFoodMeal(context),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            // color: Colors.white,
            color: mealItems.isEmpty ? Colors.white : itemColor,
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            border: Border.all(
              color: itemColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealName[0].toUpperCase() + mealName.substring(1),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: mealItems.isEmpty ? Colors.black87 : Colors.white,
                ),
              ),
              mealItems.isEmpty
                  ? Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: itemColor,
                    )
                  : SizedBox(
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: itemColor,
                          ),
                        ),
                        child: Icon(
                          Icons.done,
                          color: itemColor,
                          size: 14,
                        ),
                      ),
                    )
            ],
          ),
        ));
  }
}
