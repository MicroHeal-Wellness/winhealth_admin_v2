import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/food_item.dart';
import '../../../services/activity_service.dart';
import '../../../utils/activity_utils.dart';


class FoodMealForm extends StatefulWidget {
  final String mealName;
  final List<FoodItem> mealItems;
  final Function(List<FoodItem> value) onChange;

  const FoodMealForm(
      {Key? key,
      required this.mealName,
      required this.mealItems,
      required this.onChange})
      : super(key: key);

  @override
  State<FoodMealForm> createState() => _FoodMealFormState();
}

class _FoodMealFormState extends State<FoodMealForm> {
  TextEditingController textFieldController = TextEditingController();
  bool isInputEmpty = true;
  List<FoodItem> modelsfiltered = [];
  List<FoodItem> selected = [];
  bool loading = false;
  bool loading2 = false;

  @override
  void initState() {
    super.initState();
    getInitData();
    textFieldController.text = '';
  }

  getInitData() async {
    setState(() {
      loading = true;
    });
    selected = widget.mealItems;
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onItemAdd(selectedItem) {
    if (textFieldController.text.isNotEmpty) {
      if (selected
          .where((element) => element.name == textFieldController.text)
          .isEmpty) {
        selected.add(selectedItem!);
      } else {
        Fluttertoast.showToast(msg: "already selected");

        textFieldController.text = '';
        isInputEmpty = true;
      }
    }

    setState(() {
      textFieldController.text = '';
      isInputEmpty = true;
      selectedItem = null;
      modelsfiltered.clear();
    });
  }

  void onItemRemove(item) {
    setState(() {
      selected.removeWhere((i) => i == item);
    });
    widget.onChange(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mealName[0].toUpperCase() + widget.mealName.substring(1),
          style: const TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        leading: const BackButton(color: Colors.white),
        backgroundColor: getFoodMealColor(widget.mealName),
      ),
      floatingActionButton: selected.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {
                widget.onChange(selected);
              },
              child: const Icon(Icons.save),
            ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 32, left: 16, right: 16),
                      child: Wrap(
                        spacing: 12,
                        children: selected.map(
                          (item) {
                            return Chip(
                              onDeleted: () => onItemRemove(item),
                              deleteIcon: const Icon(Icons.remove_circle),
                              label: Text(item.name!),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: TextField(
                                controller: textFieldController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  hintText: 'Add food and drink items',
                                ),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onChanged: (val) async {
                                  setState(() {
                                    loading2 = true;
                                  });
                                  if (val.isEmpty) {
                                    modelsfiltered.clear();
                                  } else {
                                    modelsfiltered =
                                        await ActivityService.searchNutrients(
                                            val);
                                  }
                                  setState(() {
                                    loading2 = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading2
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  textFieldController.text =
                                      modelsfiltered[index].name!;
                                  onItemAdd(modelsfiltered[index]);
                                  widget.onChange(selected);
                                },
                                title: Text(
                                  modelsfiltered[index].name!,
                                ),
                                subtitle: Text(
                                  "${modelsfiltered[index].energy!} Kcal",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                            itemCount: modelsfiltered.length,
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
