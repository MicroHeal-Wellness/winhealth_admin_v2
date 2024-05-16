// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:winhealth_admin_v2/components/diet_item_card.dart';
import 'package:winhealth_admin_v2/components/food_item_card.dart';
import 'package:winhealth_admin_v2/components/food_item_info_card.dart';
import 'package:winhealth_admin_v2/components/food_recipie_info_card.dart';
import 'package:winhealth_admin_v2/components/recommended_diet_card.dart';
import 'package:winhealth_admin_v2/models/diet_item_model.dart';
import 'package:winhealth_admin_v2/models/diet_model.dart';
import 'package:winhealth_admin_v2/models/food_item.dart';
import 'package:winhealth_admin_v2/models/food_item_model.dart';
import 'package:winhealth_admin_v2/models/recommended_diet.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/new_recipie_screen.dart';
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

  List<DietModel> recommendedDiets = [];
  List<FoodItemModel> filterdFoodRecipieItems = [];
  DietModel? selecetedRecommendedDiet;
  TextEditingController searchController = TextEditingController();
  TextEditingController qunatityController = TextEditingController(text: "");
  TextEditingController instructionController = TextEditingController(text: "");
  TextEditingController specialNotesController =
      TextEditingController(text: "");
  TextEditingController dietPlanController = TextEditingController(text: "");
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

  double genDoubleValue(String val) {
    if (val.contains("±")) {
      return double.parse(val.split("±").first);
    } else {
      return double.parse(val);
    }
  }

  void genNutrientValue() {
    genNutrientLimits();
    eatenKcal = 0;
    eatencarbs = 0;
    eatenProtien = 0;
    eatenFat = 0;
    if (showNotes) {
      for (int i = 0; i < recommendedDiets.length; i++) {
        for (int j = 0; j < recommendedDiets[i].items!.length; j++) {
          for (int k = 0;
              k < recommendedDiets[i].items![j].foodItem!.ingredients!.length;
              k++) {
            eatenKcal += genDoubleValue(recommendedDiets[i]
                    .items![j]
                    .foodItem!
                    .ingredients![k]
                    .item!
                    .energyKcal!) *
                ((int.parse(recommendedDiets[i]
                            .items![j]
                            .foodItem!
                            .ingredients![k]
                            .standardizedCup!
                            .standardizedValue!) *
                        recommendedDiets[i]
                            .items![j]
                            .foodItem!
                            .ingredients![k]
                            .quantity!) /
                    (int.parse(recommendedDiets[i]
                        .items![j]
                        .foodItem!
                        .ingredients![k]
                        .item!
                        .baseQuantity!)));
            eatencarbs += genDoubleValue(recommendedDiets[i]
                    .items![j]
                    .foodItem!
                    .ingredients![k]
                    .item!
                    .carbohydrates!) *
                ((int.parse(recommendedDiets[i]
                            .items![j]
                            .foodItem!
                            .ingredients![k]
                            .standardizedCup!
                            .standardizedValue!) *
                        recommendedDiets[i]
                            .items![j]
                            .foodItem!
                            .ingredients![k]
                            .quantity!) /
                    (int.parse(recommendedDiets[i]
                        .items![j]
                        .foodItem!
                        .ingredients![k]
                        .item!
                        .baseQuantity!)));
            eatenProtien += genDoubleValue(recommendedDiets[i]
                    .items![j]
                    .foodItem!
                    .ingredients![k]
                    .item!
                    .protein!) *
                ((int.parse(recommendedDiets[i]
                            .items![j]
                            .foodItem!
                            .ingredients![k]
                            .standardizedCup!
                            .standardizedValue!) *
                        recommendedDiets[i]
                            .items![j]
                            .foodItem!
                            .ingredients![k]
                            .quantity!) /
                    (int.parse(recommendedDiets[i]
                        .items![j]
                        .foodItem!
                        .ingredients![k]
                        .item!
                        .baseQuantity!)));
            eatenFat += genDoubleValue(recommendedDiets[i]
                    .items![j]
                    .foodItem!
                    .ingredients![k]
                    .item!
                    .totalFat!) *
                ((int.parse(recommendedDiets[i]
                            .items![j]
                            .foodItem!
                            .ingredients![k]
                            .standardizedCup!
                            .standardizedValue!) *
                        recommendedDiets[i]
                            .items![j]
                            .foodItem!
                            .ingredients![k]
                            .quantity!) /
                    (int.parse(recommendedDiets[i]
                        .items![j]
                        .foodItem!
                        .ingredients![k]
                        .item!
                        .baseQuantity!)));
          }
        }
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
                                            !showNotes
                                                ? "0 g / 0 g"
                                                : "$eatencarbs g / $maxcarbs g",
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
                                            !showNotes
                                                ? "0 g / 0 g"
                                                : "$eatenProtien g / $maxProtien g",
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
                                            !showNotes
                                                ? "0 g / 0 g"
                                                : "$eatenFat g / $maxFat g",
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
                                              !showNotes
                                                  ? "0"
                                                  : (maxKcal - eatenKcal)
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
                                            !showNotes
                                                ? "0 Kcal"
                                                : "$eatenKcal Kcal",
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
                                            !showNotes
                                                ? "0 Kcal"
                                                : "$maxKcal Kcal",
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
                                    "Diet Plans",
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
                                        "Add Diet Plan",
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
                                        "No Diet Plans",
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
                                                specialNotesController.clear();
                                                selecetedRecommendedDiet = null;
                                                showNotes = !showNotes;
                                              });
                                            } else {
                                              setState(() {
                                                selecetedRecommendedDiet =
                                                    recommendedDiets[index];
                                                specialNotesController.text =
                                                    recommendedDiets[index]
                                                            .specialNotes ??
                                                        "";
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
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              showNotes
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Food Items for Diet Plan: ${selecetedRecommendedDiet!.name!}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                        MaterialButton(
                                          onPressed: () async {
                                            await DietService
                                                .updateRecommendedDietGroup(
                                                    selecetedRecommendedDiet!
                                                        .id,
                                                    {
                                                  "special_notes":
                                                      specialNotesController
                                                          .text,
                                                });
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
                                              "Update Special Notes",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : const Text(
                                      "Select a Diet plan to add/show the Food items data",
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
                                  : const Text(
                                      "Diet Plan Notes",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              !showNotes
                                  ? const SizedBox()
                                  : TextFormField(
                                      controller: specialNotesController,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      minLines: 5,
                                      maxLines: 10,
                                      decoration: const InputDecoration(
                                        hintText: 'Diet Plan Special Notes:',
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
                              !showNotes
                                  ? const SizedBox()
                                  : const SizedBox(
                                      height: 16,
                                    ),
                              !showNotes
                                  ? const SizedBox()
                                  : MaterialButton(
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
                                        borderRadius: BorderRadius.circular(12),
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
                                            "No Diet items in selected Diet Plan",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return DietItemCard(
                                              recommendedDietItem:
                                                  selecetedRecommendedDiet!
                                                      .items![index],
                                              onEdit: () async {
                                                setState(() {
                                                  qunatityController.text =
                                                      (selecetedRecommendedDiet!
                                                                  .items![index]
                                                                  .quantity ??
                                                              1)
                                                          .toString();
                                                  instructionController.text =
                                                      selecetedRecommendedDiet!
                                                              .items![index]
                                                              .specialInstruction ??
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
                                                    .removeDietRecipeItem(
                                                  selecetedRecommendedDiet!.id,
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
    filterdFoodRecipieItems.clear();
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Search your food recipie item"),
            MaterialButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NewRecipeScreen(),
                  ),
                );
              },
              color: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Add New Recipe",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width > 300
              ? MediaQuery.of(context).size.width * 0.9
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
                    hintText: 'Enter Name of Food Recipie Item',
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
                    filterdFoodRecipieItems =
                        await DietService.getFoodRecipeItemsByQuery(value);
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
                    : filterdFoodRecipieItems.isEmpty
                        ? const Text("No Food Recipe Items found")
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filterdFoodRecipieItems.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      qunatityController.text = "1";
                                      instructionController.text = "N/A";
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
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Special Instruction for ${widget.patient.firstName}:',
                                                style: const TextStyle(
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
                                                'Qunatity:',
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
                                                    'Quantity of the Recipe Item:',
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
                                                    .addDietRecipeItem({
                                                  "diet_id":
                                                      selecetedRecommendedDiet!
                                                          .id,
                                                  "diet_item_id": {
                                                    "special_instruction":
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
                                                    "food_item":
                                                        filterdFoodRecipieItems[
                                                                index]
                                                            .id,
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
                                                  "Add Recipie Item for ${widget.patient.firstName}",
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
                                  child: FoodRecipieInfoCard(
                                    foodRecipieItem:
                                        filterdFoodRecipieItems[index],
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

  editFoodDialogBoxPopup(DietItemModel dietRecipeItem) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Edit Diet Item"),
        content: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Special Instruction for ${widget.patient.firstName}:',
                style: const TextStyle(
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
            const SizedBox(
              height: 12,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Qunatity:',
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
                hintText: 'Quantity of the Recipe Item:',
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
                bool resp = await DietService.udpateDietRecipeItem({
                  "special_instruction": instructionController.text.isEmpty
                      ? "N/A"
                      : instructionController.text,
                  "quantity": qunatityController.text.isEmpty
                      ? "N/A"
                      : qunatityController.text,
                }, dietRecipeItem.id);
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
                  "Update Item for ${widget.patient.firstName}",
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
    dietPlanController.clear();
    specialNotesController.clear();
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Add Diet Plan"),
        content: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Diet Plan Name:',
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
              controller: dietPlanController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Diet Plan Name:',
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
            TextFormField(
              controller: specialNotesController,
              style: const TextStyle(color: Colors.black),
              minLines: 5,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Diet Plan Special Notes:',
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
                bool resp = await DietService.addRecommendedDietGroup({
                  "patient": widget.patient.id,
                  "name": dietPlanController.text,
                  "special_notes": specialNotesController.text,
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
                  "Create Diet Plan for ${widget.patient.firstName}",
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
