// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:winhealth_admin_v2/models/food_recipe_model.dart';
import 'package:winhealth_admin_v2/models/ingredient_model.dart';
import 'package:winhealth_admin_v2/services/diet_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class NewRecipeScreen extends StatefulWidget {
  const NewRecipeScreen({super.key});

  @override
  State<NewRecipeScreen> createState() => _NewRecipeScreenState();
}

enum DataFilter { recipes, ingredients }

class _NewRecipeScreenState extends State<NewRecipeScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController nameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController cookingInstructionController = TextEditingController();
  TextEditingController specialInstrctController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> recipeFormKey = GlobalKey<FormState>();
  bool searchLoading = false;
  List<FoodRecipeModel> ingredients = [];
  List<IngredientModel> searchFoodItems = [];
  DataFilter? selectedDataFilter = DataFilter.ingredients;
  bool showbtn = false;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              const Row(
                children: [
                  BackButton(),
                  SizedBox(
                    width: 32,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Add a new recipe",
                      style: TextStyle(
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
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.4))),
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: recipeFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Recipe Name: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              TextFormField(
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Name is required";
                                  }
                                  return null;
                                },
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
                              ),
                              const Divider(),
                              const Text(
                                "Ingredients: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              ingredients.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text("No Ingredients added"),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        return ExpansionTile(
                                          leading: IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              setState(() {
                                                ingredients.removeAt(index);
                                              });
                                            },
                                          ),
                                          title: Text(
                                            "${ingredients[index].item!.description!} X ${ingredients[index].quantity!} ${ingredients[index].unit}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                            ),
                                          ),
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: ingredients[index]
                                                    .item!
                                                    .toJson()
                                                    .entries
                                                    .map(
                                                      (e) => e.value != null
                                                          ? RichText(
                                                              text: TextSpan(
                                                                text:
                                                                    "${e.key}: ",
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 18,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        e.value,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          18,
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
                                      itemCount: ingredients.length,
                                    ),
                              const Divider(),
                              const Text(
                                "Cooking Instruction: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller: cookingInstructionController,
                                style: const TextStyle(color: Colors.black),
                                minLines: 5,
                                maxLines: 10,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Enter Cooking Instruction of Food Recipie Item',
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
                                height: 8,
                              ),
                              const Text(
                                "Special Instructions: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller: specialInstrctController,
                                style: const TextStyle(color: Colors.black),
                                minLines: 5,
                                maxLines: 10,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Enter Any Special Instruction of Food Recipie Item',
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
                                height: 8,
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  if (ingredients.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Add atleast one ingredient");
                                  } else if (recipeFormKey.currentState!
                                      .validate()) {
                                    var payload = {
                                      "name": nameController.text,
                                      "cooking_instructions":
                                          cookingInstructionController
                                                  .text.isEmpty
                                              ? "N/A"
                                              : cookingInstructionController
                                                  .text,
                                      "special_notes":
                                          specialInstrctController.text.isEmpty
                                              ? "N/A"
                                              : specialInstrctController.text,
                                      "ingredients": ingredients
                                          .map((e) => {
                                                "food_recipe_item_id": {
                                                  "item": e.item!.id,
                                                  "quantity": e.quantity,
                                                  "unit": e.unit,
                                                }
                                              })
                                          .toList()
                                    };
                                    bool resp = await DietService.addRecipeItem(
                                        payload);
                                    if (resp) {
                                      Navigator.of(context).pop(true);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Failed to add recipie");
                                    }
                                  }
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                color: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Add Recipe",
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
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.4))),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Search",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Radio<DataFilter>(
                                  value: DataFilter.ingredients,
                                  groupValue: selectedDataFilter,
                                  onChanged: (DataFilter? value) {
                                    setState(() {
                                      selectedDataFilter = value;
                                    });
                                  },
                                ),
                                Text("Ingredients"),
                                Radio<DataFilter>(
                                  value: DataFilter.recipes,
                                  groupValue: selectedDataFilter,
                                  onChanged: (DataFilter? value) {
                                    setState(() {
                                      selectedDataFilter = value;
                                    });
                                  },
                                ),
                                Text("Recipes"),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: searchController,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Search Food Recipie Ingredient',
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
                                searchFoodItems =
                                    await DietService.getFoodIngredientsByQuery(
                                        value,
                                        selectedDataFilter! == DataFilter.ingredients
                                            ? "Indian Foods"
                                            : "American%20Foods");
                                setState(() {
                                  searchLoading = false;
                                });
                              },
                            ),
                            searchLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : searchFoodItems.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Text("No Items found"),
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: searchFoodItems.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 16,
                                            ),
                                            child: GestureDetector(
                                              onTap: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      addIngredientDialogBoxPopup(
                                                          searchFoodItems[
                                                              index]),
                                                );
                                                setState(() {});
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.4),
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      searchFoodItems[index]
                                                          .description!,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    const Divider(),
                                                    Wrap(
                                                      spacing: 8,
                                                      runSpacing: 8,
                                                      children:
                                                          searchFoodItems[index]
                                                              .toJson()
                                                              .entries
                                                              .map(
                                                                (e) => (e.value !=
                                                                            null &&
                                                                        (e.key !=
                                                                            "description"))
                                                                    ? RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              "${e.key}: ",
                                                                          style:
                                                                              const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                18,
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  addIngredientDialogBoxPopup(IngredientModel ingredient) {
    unitController.clear();
    quantityController.clear();
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Add Ingredient info"),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width > 300
                ? MediaQuery.of(context).size.width * 0.9
                : 300,
            height: MediaQuery.of(context).size.height * 0.9,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ingredient.description!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    const Divider(),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ingredient
                          .toJson()
                          .entries
                          .map(
                            (e) => (e.value != null && (e.key != "description"))
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
                    const Divider(),
                    const Text(
                      "Quantity: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextFormField(
                      controller: quantityController,
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Quantity is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Quantity of the selected ingredient',
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
                    const Text(
                      "Unit: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextFormField(
                      controller: unitController,
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Unit is required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText:
                            'Enter Unit of the selected ingredient quantity',
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
                        if (formKey.currentState!.validate()) {
                          setState(
                            () {
                              ingredients.add(
                                FoodRecipeModel(
                                  item: ingredient,
                                  unit: unitController.text,
                                  quantity: int.parse(
                                    quantityController.text,
                                  ),
                                ),
                              );
                            },
                          );
                          Navigator.of(context).pop();
                          scrollController.animateTo(0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        }
                      },
                      color: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Add Ingredient",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
