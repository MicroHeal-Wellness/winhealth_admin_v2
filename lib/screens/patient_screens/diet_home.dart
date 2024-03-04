// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:winhealth_admin_v2/components/food_item_card.dart';
import 'package:winhealth_admin_v2/components/food_item_info_card.dart';
import 'package:winhealth_admin_v2/components/recommended_diet_card.dart';
import 'package:winhealth_admin_v2/models/food_item.dart';
import 'package:winhealth_admin_v2/models/recommended_diet.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/diet_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class DietHome extends StatefulWidget {
  final UserModel patient;
  const DietHome({super.key, required this.patient});

  @override
  State<DietHome> createState() => _DietHomeState();
}

class _DietHomeState extends State<DietHome> {
  ScrollController scrollController = ScrollController();
  bool showbtn = false;
  bool showNotes = false;
  bool loading = false;
  bool searchLoading = false;

  List<RecommendedDiet> recommendedDiets = [];
  List<FoodItem> filterdFoodItems = [];
  RecommendedDiet? selecetedRecommendedDiet;
  TextEditingController searchController = TextEditingController();
  TextEditingController qunatityController = TextEditingController(text: "");
  TextEditingController instructionController = TextEditingController(text: "");
  TextEditingController recipeController = TextEditingController(text: "");
  @override
  void initState() {
    scrollController.addListener(() {
      //scroll listener
      double showoffset =
          10.0; //Back to top botton will show on scroll offset 10.0

      if (scrollController.offset > showoffset) {
        showbtn = true;
        setState(() {
          //update state
        });
      } else {
        showbtn = false;
        setState(() {
          //update state
        });
      }
    });
    getInitData();
    super.initState();
  }

  getInitData() async {
    setState(() {
      loading = true;
      showNotes = false;
      selecetedRecommendedDiet = null;
    });
    recommendedDiets =
        await DietService.getRecommendedDietByPatientID(widget.patient.id!);
    setState(() {
      loading = false;
    });
  }

  var typeBreif = {
    'morning': 'Mornning 8 AM - 11 AM',
    'afternoon': 'Afternoon 12 PM - 2 PM',
    'evening': 'Evening 5 PM - 7 PM',
    'night': 'Night 8 PM - 11 PM',
  };
  List<String> typeList = [
    'morning',
    'afternoon',
    'evening',
    'night',
  ];

  String selectedType = 'morning';

  double maxKcal = 0;
  double eatenKcal = 0;

  double maxcarbs = 0;
  double eatencarbs = 0;

  double maxProtien = 0;
  double eatenProtien = 0;

  double maxFat = 0;
  double eatenFat = 0;

  void genNutrientLimits() {
    double age = (DateTime.now().difference(widget.patient.dob!).inDays / 365)
        .ceilToDouble();
    double weight = double.parse(widget.patient.weight ?? "0.0");
    double height = double.parse(widget.patient.height ?? "0.0");

    if (widget.patient.gender!.toLowerCase() == "male") {
      maxKcal = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      maxKcal = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
    if (widget.patient.exerciseType == null ||
        widget.patient.exerciseType == "never") {
      maxKcal = maxKcal * 1.2;
    } else if (widget.patient.exerciseType == "light") {
      maxKcal = maxKcal * 1.25;
    } else if (widget.patient.exerciseType == "moderate") {
      maxKcal = maxKcal * 1.35;
    } else if (widget.patient.exerciseType == "active") {
      maxKcal = maxKcal * 1.5;
    } else if (widget.patient.exerciseType == "highlyactive") {
      maxKcal = maxKcal * 1.65;
    }
    setState(() {
      maxcarbs = double.parse(((maxKcal * 0.55) / 4).toStringAsFixed(2));
      maxProtien = double.parse(((maxKcal * 0.15) / 4).toStringAsFixed(2));
      maxFat = double.parse(((maxKcal * 0.30) / 9).toStringAsFixed(2));
      maxKcal = double.parse(maxKcal.toStringAsFixed(2));
    });
  }

  void genNutrientValue() {
    genNutrientLimits();
    eatenKcal = 0;
    eatencarbs = 0;
    eatenProtien = 0;
    eatenFat = 0;
    for (int i = 0; i < recommendedDiets.length; i++) {
      for (int j = 0; j < recommendedDiets[i].items!.length; j++) {
        eatenKcal += recommendedDiets[i].items![j].foodItem!.energy!;
        eatencarbs += recommendedDiets[i].items![j].foodItem!.cho!;
        eatenProtien += recommendedDiets[i].items![j].foodItem!.protien!;
        eatenFat += recommendedDiets[i].items![j].foodItem!.saturatedFats!;
        eatenFat += recommendedDiets[i].items![j].foodItem!.unSaturatedFats!;
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100.withOpacity(0.4),
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: showbtn ? 1.0 : 0.0,
        child: FloatingActionButton(
          onPressed: () {
            scrollController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn);
          },
          backgroundColor: primaryColor,
          child: const Icon(
            Icons.arrow_upward,
          ),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const BackButton(),
                        const SizedBox(
                          width: 32,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${widget.patient.firstName}'s Diet",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Summary",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.4))),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Carbs",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            "$eatencarbs g / $maxcarbs g",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          const Text(
                                            "Protien",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            "$eatenProtien g / $maxProtien g",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          const Text(
                                            "Fat",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            "$eatenFat g / $maxFat g",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      CircularPercentIndicator(
                                        radius: 55,
                                        lineWidth: 8,
                                        percent: (eatenKcal / maxKcal) > 1
                                            ? 1
                                            : (eatenKcal / maxKcal),
                                        progressColor: primaryColor,
                                        backgroundColor: Colors.grey,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        center: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              (maxKcal - eatenKcal)
                                                  .toStringAsFixed(2),
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 20),
                                            ),
                                            const Text(
                                              "Kcal left",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Routines",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                  const Spacer(),
                                  MaterialButton(
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) =>
                                            addRoutuineDialogBoxPopup(),
                                      );
                                      await getInitData();
                                    },
                                    color: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Text(
                                        "Add Routine",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              recommendedDiets.isEmpty
                                  ? const Center(
                                      child: Text(
                                        "No Diet Group",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          child: RecommendedDietCard(
                                            onDelete: () async {
                                              bool resp = await DietService
                                                  .removeRecommendedDietGroup(
                                                      recommendedDiets[index]
                                                          .id);
                                              if (resp) {
                                                await getInitData();
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Something Went Wrong, Please Try again",
                                                );
                                              }
                                            },
                                            recommendedDiet:
                                                recommendedDiets[index],
                                            isSelected:
                                                selecetedRecommendedDiet == null
                                                    ? false
                                                    : selecetedRecommendedDiet!
                                                            .id ==
                                                        recommendedDiets[index]
                                                            .id,
                                          ),
                                          onTap: () {
                                            if (selecetedRecommendedDiet !=
                                                    null &&
                                                selecetedRecommendedDiet!.id ==
                                                    recommendedDiets[index]
                                                        .id) {
                                              setState(() {
                                                selecetedRecommendedDiet = null;
                                                showNotes = !showNotes;
                                              });
                                            } else {
                                              setState(() {
                                                selecetedRecommendedDiet =
                                                    recommendedDiets[index];
                                                showNotes = !showNotes;
                                              });
                                            }
                                          },
                                        );
                                      },
                                      shrinkWrap: true,
                                      itemCount: recommendedDiets.length,
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Nutrient Data for Selected Diet Group",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              showNotes
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Selected: ${typeBreif[selecetedRecommendedDiet!.type!]}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        MaterialButton(
                                          onPressed: () async {
                                            await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  addFoodDialogBoxPopup(),
                                            );
                                            await getInitData();
                                          },
                                          color: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Text(
                                              "Add Food Item",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : const Text(
                                      "Select a Diet Group to add/show the Nutrient Data",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                              !showNotes
                                  ? const SizedBox()
                                  : const SizedBox(
                                      height: 16,
                                    ),
                              !showNotes
                                  ? const SizedBox()
                                  : selecetedRecommendedDiet!.items!.isEmpty
                                      ? const Center(
                                          child: Text(
                                            "No Recommended Diet",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return FoodItemCard(
                                              recommendedDietItem:
                                                  selecetedRecommendedDiet!
                                                      .items![index],
                                              onEdit: () async {
                                                setState(() {
                                                  qunatityController.text =
                                                      selecetedRecommendedDiet!
                                                              .items![index]
                                                              .quantity ??
                                                          "1";
                                                  instructionController.text =
                                                      selecetedRecommendedDiet!
                                                              .items![index]
                                                              .cookingInstruction ??
                                                          "N/A";
                                                });
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      editFoodDialogBoxPopup(
                                                    selecetedRecommendedDiet!
                                                        .items![index],
                                                  ),
                                                );
                                                await getInitData();
                                              },
                                              onRemove: () async {
                                                bool resp = await DietService
                                                    .removeRecommendedDietItem(
                                                  selecetedRecommendedDiet!
                                                      .items![index].id,
                                                );
                                                if (resp) {
                                                  await getInitData();
                                                } else {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Something Went Wrong Please Try Again",
                                                  );
                                                }
                                              },
                                            );
                                          },
                                          itemCount: selecetedRecommendedDiet!
                                              .items!.length,
                                        ),
                              !showNotes
                                  ? const SizedBox()
                                  : const SizedBox(
                                      height: 16,
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  addFoodDialogBoxPopup() {
    searchController.clear();
    filterdFoodItems.clear();
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Search your food item"),
        content: SizedBox(
          width: MediaQuery.of(context).size.width > 300
              ? MediaQuery.of(context).size.width * 0.4
              : 300,
          height: MediaQuery.of(context).size.height * 0.9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Enter Name of Food Item',
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    fillColor: Colors.transparent,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                  onFieldSubmitted: (value) async {
                    setState(() {
                      searchLoading = true;
                    });
                    filterdFoodItems =
                        await DietService.getFoodItemsByQuery(value);
                    setState(() {
                      searchLoading = false;
                    });
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                const SizedBox(
                  height: 16,
                ),
                searchLoading
                    ? const CircularProgressIndicator()
                    : filterdFoodItems.isEmpty
                        ? const Text("No Food Items found")
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filterdFoodItems.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      qunatityController.text =
                                          filterdFoodItems[index]
                                                  .recomendedQuantity ??
                                              "1";
                                      instructionController.text = "N/A";
                                      recipeController.text =
                                          filterdFoodItems[index].recipe ??
                                              "N/A";
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        scrollable: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        title: const Text("Add Food Item"),
                                        content: Column(
                                          children: [
                                            FoodItemCard(
                                              showMenu: false,
                                              onEdit: () {},
                                              onRemove: () {},
                                              recommendedDietItem:
                                                  RecommendedDietItem(
                                                      id: filterdFoodItems[
                                                              index]
                                                          .id,
                                                      quantity: filterdFoodItems[
                                                              index]
                                                          .recomendedQuantity,
                                                      foodItem:
                                                          filterdFoodItems[
                                                              index],
                                                      cookingInstruction:
                                                          recipeController.text,
                                                      otherInstruction:
                                                          instructionController
                                                              .text),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            const Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Updated Recommended Quantity:',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            TextFormField(
                                              controller: qunatityController,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Updated Recommended Quantity:',
                                                hintStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                fillColor: Colors.transparent,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            const Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Updated Recommended Recipe:',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            TextFormField(
                                              controller: recipeController,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Updated Recommended Recipe:',
                                                hintStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                fillColor: Colors.transparent,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            const Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Updated Instructions:',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            TextFormField(
                                              controller: instructionController,
                                              minLines: 5,
                                              maxLines: 10,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Enter updated instructions',
                                                hintStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                fillColor: Colors.transparent,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                bool resp = await DietService
                                                    .addRecommendedDietItem({
                                                  "recommended_diet_id":
                                                      selecetedRecommendedDiet!
                                                          .id,
                                                  "recommended_diet_item_id": {
                                                    "food_item":
                                                        filterdFoodItems[index]
                                                            .id,
                                                    "other_instruction":
                                                        instructionController
                                                                .text.isEmpty
                                                            ? "N/A"
                                                            : instructionController
                                                                .text,
                                                    "quantity":
                                                        qunatityController
                                                                .text.isEmpty
                                                            ? "N/A"
                                                            : qunatityController
                                                                .text,
                                                    "cooking_instruction":
                                                        recipeController
                                                                .text.isEmpty
                                                            ? "N/A"
                                                            : recipeController
                                                                .text,
                                                  }
                                                });
                                                if (resp) {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Added Food Item for ${widget.patient.firstName}",
                                                  );
                                                } else {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Something Went Wrong Please Try Again",
                                                  );
                                                }
                                              },
                                              color: primaryColor,
                                              minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Add Item for ${widget.patient.firstName}",
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: FoodItemInfoCard(
                                    foodItem: filterdFoodItems[index],
                                  ),
                                );
                              },
                            ),
                          )
              ],
            ),
          ),
        ),
      );
    });
  }

  editFoodDialogBoxPopup(RecommendedDietItem recommendedDietItem) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Add Food Item"),
        content: Column(
          children: [
            FoodItemCard(
              showMenu: false,
              onEdit: () {},
              onRemove: () {},
              recommendedDietItem: recommendedDietItem,
            ),
            const SizedBox(
              height: 12,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Updated Recommended Quantity:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: qunatityController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Updated Recommended Quantity:',
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                fillColor: Colors.transparent,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Updated Instructions:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: instructionController,
              minLines: 5,
              maxLines: 10,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Enter updated instructions',
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                fillColor: Colors.transparent,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            MaterialButton(
              onPressed: () async {
                bool resp = await DietService.udpateRecommendedDietItem({
                  "cooking_instruction": instructionController.text.isEmpty
                      ? "N/A"
                      : instructionController.text,
                  "quantity": qunatityController.text.isEmpty
                      ? "N/A"
                      : qunatityController.text,
                }, selecetedRecommendedDiet!.id);
                if (resp) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Updated Food Item for ${widget.patient.firstName}",
                  );
                } else {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Something Went Wrong Please Try Again",
                  );
                }
              },
              color: primaryColor,
              minWidth: MediaQuery.of(context).size.width,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Add Item for ${widget.patient.firstName}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  addRoutuineDialogBoxPopup() {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Add Routine"),
        content: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Choose New Routine:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(12, 10, 20, 20),
                    errorStyle: const TextStyle(
                        color: Colors.redAccent, fontSize: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      hint: const Text(
                        "Choose New Routine",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      items: typeList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(typeBreif[value]!),
                        );
                      }).toList(),
                      isExpanded: true,
                      isDense: true,
                      onChanged: (String? newSelected) {
                        setState(() {
                          selectedType = newSelected!;
                        });
                      },
                      value: selectedType,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            MaterialButton(
              onPressed: () async {
                bool resp = await DietService.addRecommendedDietGroup({
                  "patient": widget.patient.id,
                  "type": selectedType,
                });
                if (resp) {
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Added Routine for ${widget.patient.firstName}",
                  );
                } else {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Something Went Wrong Please Try Again",
                  );
                }
              },
              color: primaryColor,
              minWidth: MediaQuery.of(context).size.width,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Add Routine for ${widget.patient.firstName}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
