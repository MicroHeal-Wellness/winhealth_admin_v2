// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/activity.dart';
import '../../models/user_model.dart';
import '../../services/activity_service.dart';
import '../../utils/activity_utils.dart';
import 'acitivity_item_form.dart';

class ActivityItemScreen extends StatefulWidget {
  final UserModel currentUser;
  final ActivityItem activityItem;
  final DateTime dateTime;
  final bool allowUpdate;
  const ActivityItemScreen(
      {super.key,
      required this.currentUser,
      required this.dateTime,
      required this.activityItem,
      this.allowUpdate = true});

  @override
  State<ActivityItemScreen> createState() => _ActivityItemScreenState();
}

class _ActivityItemScreenState extends State<ActivityItemScreen> {
  @override
  void initState() {
    super.initState();
    getInitData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool loading = true;
  bool isSavingActivity = false;

  getInitData() async {
    setState(() {
      loading = true;
    });
    setState(() {
      loading = false;
    });
  }

  void onClickSave(BuildContext context) async {
    Map<String, dynamic> params = {
      "activity_type": widget.activityItem.activityType!,
      "response": widget.activityItem.response.toJson(),
      "user_created": widget.currentUser.id,
      "date":
          "${widget.dateTime.year.toString().padLeft(4, '0')}-${widget.dateTime.month.toString().padLeft(2, '0')}-${widget.dateTime.day.toString().padLeft(2, '0')}"
    };
    setState(() {
      isSavingActivity = true;
    });
    bool res = await ActivityService.addActivityUpdate(params);
    setState(() {
      isSavingActivity = false;
    });
    if (res) {
      Fluttertoast.showToast(
        msg: "${widget.activityItem.activityType!} Updated for Today",
      );
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(
        msg:
            "${widget.activityItem.activityType!} Update failed use valid values",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.activityItem.activityType![0].toUpperCase() +
              widget.activityItem.activityType!.substring(1),
          style: const TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        leading: const BackButton(color: Colors.white),
        backgroundColor:
            getActivityItemColor(widget.activityItem.activityType!),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Vertically center the widget inside the column
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ActivityItemForm(
                      activityItem: widget.activityItem,
                      currentUser: widget.currentUser,
                      onChange: (value) {
                        {
                          setState(
                            () {
                              if (widget.activityItem.activityType! == 'food') {
                                widget.activityItem.response =
                                    FoodActivity.fromJson(value);
                              }
                              if (widget.activityItem.activityType! ==
                                  'sleep') {
                                widget.activityItem.response =
                                    SleepActivity.fromJson(value);
                              }
                              if (widget.activityItem.activityType! ==
                                  'water') {
                                widget.activityItem.response =
                                    WaterActivity.fromJson(value);
                              }
                              if (widget.activityItem.activityType! ==
                                  'stress') {
                                widget.activityItem.response =
                                    StressActivity.fromJson(value);
                              }
                              if (widget.activityItem.activityType! ==
                                  'stool') {
                                widget.activityItem.response =
                                    StoolActivity.fromJson(value);
                              }
                              if (widget.activityItem.activityType! ==
                                  'digestion') {
                                widget.activityItem.response =
                                    DigestionActivity.fromJson(value);
                              }
                            },
                          );
                        }
                      },
                    ),
                    widget.allowUpdate
                        ? widget.activityItem.activityType! != 'food'
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff333333),
                                  minimumSize: const Size.fromHeight(48),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(24.0)), // <-- Radius
                                  ),
                                ),
                                onPressed: isSavingActivity
                                    ? null
                                    : () => onClickSave(context),
                                child: Text(
                                  isSavingActivity ? "Saving..." : 'Save',
                                  style: const TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              )
                            : const SizedBox()
                        : const SizedBox(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}
