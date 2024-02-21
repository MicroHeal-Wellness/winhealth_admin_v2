// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:winhealth_admin_v2/screens/activity/activity_items_forms/food_meal_button.dart';

import '../../../models/activity.dart';
import '../../../models/food_item.dart';
import '../../../models/user_model.dart';
import '../../../services/activity_service.dart';
import '../../../utils/constants.dart';

Map<String, List<FoodItem>> foodMeals = {
  'breakfast': [],
  'lunch': [],
  'dinner': [],
  'others': [],
};

class ActivityItemFoodForm extends StatefulWidget {
  final ActivityItem? activityItem;
  final UserModel? currentUser;
  final Function(Map<String, dynamic> value) onChange;

  const ActivityItemFoodForm({
    Key? key,
    this.activityItem,
    required this.currentUser,
    required this.onChange,
  }) : super(key: key);

  @override
  State<ActivityItemFoodForm> createState() => _ActivityItemFoodFormState();
}

class _ActivityItemFoodFormState extends State<ActivityItemFoodForm> {
  TextEditingController textFieldController = TextEditingController();
  bool isInputEmpty = true;

  @override
  void initState() {
    super.initState();
    foodMeals = {
      'breakfast': [],
      'lunch': [],
      'dinner': [],
      'others': [],
    };
    genNutrientValue();
    textFieldController.text = '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onChangeMealItems(String mealName, List<FoodItem> items) {
    Map<String, dynamic> newValue = {};
    for (final _ in foodMeals.keys) {
      newValue['breakfast'] = widget.activityItem!.response == null
          ? []
          : widget.activityItem?.response.breakfast
              .map((e) => e.toJson())
              .toList();
      newValue['lunch'] = widget.activityItem!.response == null
          ? []
          : widget.activityItem?.response.lunch.map((e) => e.toJson()).toList();
      newValue['dinner'] = widget.activityItem!.response == null
          ? []
          : widget.activityItem?.response.dinner
              .map((e) => e.toJson())
              .toList();
      newValue['others'] = widget.activityItem!.response == null
          ? []
          : widget.activityItem?.response.others
              .map((e) => e.toJson())
              .toList();
    }
    newValue[mealName] = items.map((e) => e.toJson()).toList();
    widget.activityItem!.response = FoodActivity.fromJson(newValue);
    widget.onChange(newValue);
    onClickSave(context);
  }

  void onClickSave(BuildContext context) async {
    DateTime date = DateTime.now();
    Map<String, dynamic> params = {
      "activity_type": widget.activityItem!.activityType!,
      "response": widget.activityItem!.response.toJson(),
      "date":
          "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
    };
    bool res = await ActivityService.addActivityUpdate(params);
    if (res) {
      Fluttertoast.showToast(
        msg: "${widget.activityItem!.activityType!} Updated for Today",
      );
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(
        msg:
            "${widget.activityItem!.activityType!} Update failed use valid values",
      );
    }
  }

  double maxKcal = 0;
  double eatenKcal = 0;

  double maxcarbs = 0;
  double eatencarbs = 0;

  double maxProtien = 0;
  double eatenProtien = 0;

  double maxFat = 0;
  double eatenFat = 0;

  void genNutrientLimits() {
    // maxKcal = 0;
    // maxcarbs = 0;
    // maxProtien = 0;
    // maxFat = 0;

    double age =
        (DateTime.now().difference(widget.currentUser!.dob!).inDays / 365)
            .ceilToDouble();
    double weight = double.parse(widget.currentUser!.weight ?? "0.0");
    double height = double.parse(widget.currentUser!.height ?? "0.0");
    Map<String, String> exerciseListEng = {
      "never": "Never",
      "light": "Light",
      "moderate": "Moderate",
      "active": "Active",
      "highlyactive": "Highly Active"
    };
    if (widget.currentUser!.gender == "male") {
      maxKcal = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      maxKcal = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
    if (widget.currentUser!.exerciseType == null ||
        widget.currentUser!.exerciseType == "never") {
      maxKcal = maxKcal * 1.2;
    } else if (widget.currentUser!.exerciseType == "light") {
      maxKcal = maxKcal * 1.375;
    } else if (widget.currentUser!.exerciseType == "moderate") {
      maxKcal = maxKcal * 1.55;
    } else if (widget.currentUser!.exerciseType == "active") {
      maxKcal = maxKcal * 1.725;
    } else if (widget.currentUser!.exerciseType == "highlyactive") {
      maxKcal = maxKcal * 1.9;
    }
    setState(() {
      maxcarbs = double.parse(((maxKcal * 0.45) / 4).toStringAsFixed(2));
      maxProtien = double.parse(((maxKcal * 0.25) / 4).toStringAsFixed(2));
      maxFat = double.parse(((maxKcal * 0.3) / 9).toStringAsFixed(2));

      maxKcal = double.parse(maxKcal.toStringAsFixed(2));
    });
  }

  void genNutrientValue() {
    genNutrientLimits();
    eatenKcal = 0;
    eatencarbs = 0;
    eatenProtien = 0;
    eatenFat = 0;
    if (widget.activityItem!.response != null &&
        widget.activityItem!.response.breakfast != null) {
      for (int i = 0; i < widget.activityItem!.response.breakfast.length; i++) {
        eatenKcal += widget.activityItem!.response.breakfast[i].energy;
        eatencarbs += widget.activityItem!.response.breakfast[i].cho;
        eatenProtien += widget.activityItem!.response.breakfast[i].protien;
        eatenFat += widget.activityItem!.response.breakfast[i].unsaturatedFats;
        eatenFat += widget.activityItem!.response.breakfast[i].saturatedFat;
      }
    }
    if (widget.activityItem!.response != null &&
        widget.activityItem!.response.lunch != null) {
      for (int i = 0; i < widget.activityItem!.response.lunch.length; i++) {
        eatenKcal += widget.activityItem!.response.lunch[i].energy;
        eatencarbs += widget.activityItem!.response.lunch[i].cho;
        eatenProtien += widget.activityItem!.response.lunch[i].protien;
        eatenFat += widget.activityItem!.response.lunch[i].unsaturatedFats;
        eatenFat += widget.activityItem!.response.lunch[i].saturatedFat;
      }
    }
    if (widget.activityItem!.response != null &&
        widget.activityItem!.response.dinner != null) {
      for (int i = 0; i < widget.activityItem!.response.dinner.length; i++) {
        eatenKcal += widget.activityItem!.response.dinner[i].energy;
        eatencarbs += widget.activityItem!.response.dinner[i].cho;
        eatenProtien += widget.activityItem!.response.dinner[i].protien;
        eatenFat += widget.activityItem!.response.dinner[i].unsaturatedFats;
        eatenFat += widget.activityItem!.response.dinner[i].saturatedFat;
      }
    }
    if (widget.activityItem!.response != null &&
        widget.activityItem!.response.others != null) {
      for (int i = 0; i < widget.activityItem!.response.others.length; i++) {
        eatenKcal += widget.activityItem!.response.others[i].energy;
        eatencarbs += widget.activityItem!.response.others[i].cho;
        eatenProtien += widget.activityItem!.response.others[i].protien;
        eatenFat += widget.activityItem!.response.others[i].unsaturatedFats;
        eatenFat += widget.activityItem!.response.others[i].saturatedFat;
      }
    }
    setState(() {
      eatenKcal = double.parse(eatenKcal.toStringAsFixed(2));
      eatencarbs = double.parse(eatencarbs.toStringAsFixed(2));
      eatenProtien = double.parse(eatenProtien.toStringAsFixed(2));
      eatenFat = double.parse(eatenFat.toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    genNutrientValue();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 16.0),
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Eaten",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "$eatenKcal Kcal",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        "Total Required",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF3982EC),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "$maxKcal Kcal",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      CircularPercentIndicator(
                        radius: 55,
                        lineWidth: 8,
                        percent: (eatenKcal / maxKcal) > 1
                            ? 1
                            : (eatenKcal / maxKcal),
                        progressColor: primaryColor,
                        backgroundColor: Colors.grey,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (maxKcal - eatenKcal).toStringAsFixed(2),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 20),
                            ),
                            Text(
                              (maxKcal - eatenKcal) > 0
                                  ? "Kcal left"
                                  : "Extra Kcal",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      (maxKcal - eatenKcal) < 0
                          ? CircularPercentIndicator(
                              radius: 55,
                              lineWidth: 8,
                              percent:
                                  ((maxKcal - eatenKcal).abs() / maxKcal * 2),
                              progressColor: Colors.black,
                              backgroundColor: Colors.transparent,
                              circularStrokeCap: CircularStrokeCap.round,
                              // center: Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Text(
                              //       (maxKcal - eatenKcal).abs().toStringAsFixed(2),
                              //       style: const TextStyle(
                              //           color: Colors.grey, fontSize: 20),
                              //     ),
                              //     Text(
                              //       (maxKcal - eatenKcal) > 0
                              //           ? "Kcal left"
                              //           : "Extra Kcal",
                              //       style: const TextStyle(
                              //           color: Colors.grey, fontSize: 12),
                              //     ),
                              //   ],
                              // ),
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Divider(
                height: 2,
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Carbs",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFF7253BF),
                            ),
                            width: MediaQuery.of(context).size.width *
                                0.2 *
                                ((eatencarbs / maxcarbs) > 1
                                    ? 1
                                    : (eatencarbs / maxcarbs)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "$eatencarbs g / $maxcarbs g",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Protien",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.green,
                            ),
                            width: MediaQuery.of(context).size.width *
                                0.2 *
                                ((eatenProtien / maxProtien) > 1
                                    ? 1
                                    : (eatenProtien / maxProtien)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "$eatenProtien g / $maxProtien g",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Fat",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: primaryColor,
                            ),
                            width: MediaQuery.of(context).size.width *
                                0.2 *
                                ((eatenFat / maxFat) > 1
                                    ? 1
                                    : (eatenFat / maxFat)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "$eatenFat g / $maxFat g",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      const SizedBox(height: 16.0),
      Text(
        "What did you eat today?",
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16.0),
      FoodMealButton(
          mealName: foodMeals.keys.elementAt(0),
          mealItems: widget.activityItem?.response != null
              ? widget.activityItem?.response.breakfast
              : foodMeals['breakfast'],
          onChange: (List<FoodItem> items) =>
              onChangeMealItems(foodMeals.keys.elementAt(0), items)),
      FoodMealButton(
          mealName: foodMeals.keys.elementAt(1),
          mealItems: widget.activityItem?.response != null
              ? widget.activityItem?.response.lunch
              : foodMeals['lunch'],
          onChange: (List<FoodItem> items) =>
              onChangeMealItems(foodMeals.keys.elementAt(1), items)),
      FoodMealButton(
          mealName: foodMeals.keys.elementAt(2),
          mealItems: widget.activityItem?.response != null
              ? widget.activityItem?.response.dinner
              : foodMeals['dinner'],
          onChange: (List<FoodItem> items) =>
              onChangeMealItems(foodMeals.keys.elementAt(2), items)),
      FoodMealButton(
          mealName: foodMeals.keys.elementAt(3),
          mealItems: widget.activityItem?.response != null
              ? widget.activityItem?.response.others
              : foodMeals['others'],
          onChange: (List<FoodItem> items) =>
              onChangeMealItems(foodMeals.keys.elementAt(3), items)),
      // Container(
      //     child: Column(
      //   children: foodMeals.keys
      //       .map((meal) => FoodMealButton(
      //           mealName: meal,
      //           mealItems: mealsData[meal] ?? foodMeals[meal],
      //           onChange: (List<String> items) => onChangeMealItems(meal, items)))
      //       .toList(),
      // ))
    ]);
  }
}
