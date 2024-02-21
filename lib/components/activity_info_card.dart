import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/components/food_item_info_card.dart';
import 'package:winhealth_admin_v2/models/activity.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/screens/activity/activity_item.dart';
import 'package:winhealth_admin_v2/screens/activity/activity_items_forms/digestion.dart';
import 'package:winhealth_admin_v2/screens/activity/activity_items_forms/food.dart';
import 'package:winhealth_admin_v2/screens/activity/activity_items_forms/sleep.dart';
import 'package:winhealth_admin_v2/screens/activity/activity_items_forms/stool.dart';
import 'package:winhealth_admin_v2/screens/activity/activity_items_forms/stress.dart';
import 'package:winhealth_admin_v2/screens/activity/activity_items_forms/water.dart';

List<String> moodTypes = [
  "Happy, relaxed, calm, content",
  "Okay, well enough, passable",
  "Sad, upset, depressed",
  "Anxious, worried, fearful",
  "Disgusted, tired",
  "Angry, annoyed, tense, irritable",
];
List<String> sleepQualityTypes = [
  "Awful",
  "Bad",
  "Not bad",
  "Good",
  "Great",
];

List<String> constipationTypes = [
  "None",
  "Not very severe",
  "Quite severe",
  "Severe",
  "Extremely severe",
];

List<String> bloatedTypes = [
  "None",
  "Not very severe",
  "Quite severe",
  "Severe",
  "Extremely severe",
];

List<String> diarrheaTypes = [
  "None",
  "Not very severe",
  "Quite severe",
  "Severe",
  "Extremely severe",
];

List<String> painTypes = [
  "None",
  "Noticeable discomfort",
  "Tolerable pain",
  "In a lot of pain",
  "Extreme pain",
];

class ActivityInfoCard extends StatefulWidget {
  final ActivityItem activityItem;
  final UserModel patient;
  final UserModel currentUser;
  final DateTime currentDateTime;
  final bool isEditable;
  final Function func;
  const ActivityInfoCard(
      {super.key,
      required this.activityItem,
      required this.patient,
      required this.func,
      required this.currentDateTime,
      required this.currentUser,
      required this.isEditable});

  @override
  State<ActivityInfoCard> createState() => _ActivityInfoCardState();
}

class _ActivityInfoCardState extends State<ActivityInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Activity: ${widget.activityItem.activityType}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // const Spacer(),
                widget.isEditable &&
                        (widget.currentUser.access != null &&
                            widget.currentUser.access!.permission!
                                .contains("editactivityinfo"))
                    ? MaterialButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ActivityItemScreen(
                                currentUser: widget.patient,
                                activityItem: widget.activityItem,
                                dateTime: widget.currentDateTime,
                              ),
                            ),
                          );
                          await widget.func();
                        },
                        child: const Text("Edit"),
                      )
                    : const SizedBox()
              ],
            ),
            Text(
              "Last Update By: ${widget.activityItem.addedBy == null ? "N/A" : widget.activityItem.addedBy!.firstName}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            mapper(
              widget.activityItem.activityType,
            )
          ],
        ),
      ),
    );
  }

  callMapper(name) {
    switch (name) {
      case "stress":
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ActivityItemStress(
              activityItem: widget.activityItem,
              onChange: (s) {},
            ),
          ),
        );
      case "water":
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ActivityItemWater(
              activityItem: widget.activityItem,
              onChange: (s) {},
            ),
          ),
        );
      case "sleep":
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ActivityItemSleep(
              activityItem: widget.activityItem,
              onChange: (s) {},
            ),
          ),
        );
      case "stool":
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ActivityItemStool(
              activityItem: widget.activityItem,
              allowUpdate: true,
              onChange: (s) {},
            ),
          ),
        );
      case "food":
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ActivityItemFoodForm(
              activityItem: widget.activityItem,
              onChange: (s) {},
              currentUser: widget.patient,
            ),
          ),
        );
      case "digestion":
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ActivityItemDigestion(
              activityItem: widget.activityItem,
              onChange: (s) {},
            ),
          ),
        );
      default:
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ActivityItemStress(
              activityItem: widget.activityItem,
              onChange: (s) {},
            ),
          ),
        );
    }
  }

  mapper(name) {
    switch (name) {
      case "stress":
        return widget.activityItem.response == null
            ? const Text("No Data")
            : Text(
                "Mood: ${moodTypes[widget.activityItem.response.mood]}",
                style: const TextStyle(fontSize: 18),
              );
      case "water":
        return widget.activityItem.response == null
            ? const Text("No Data")
            : Text(
                "Amount: ${widget.activityItem.response.quantity} L",
                style: const TextStyle(fontSize: 18),
              );
      case "sleep":
        return widget.activityItem.response == null
            ? const Text("No Data")
            : Text(
                "Duration: ${widget.activityItem.response.duration} Hrs, Quality: ${sleepQualityTypes[widget.activityItem.response.quality]}",
                style: const TextStyle(fontSize: 18),
              );
      case "stool":
        return widget.activityItem.response == null
            ? const Text("No Data")
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      Text(
                        "Frequency: ${widget.activityItem.response.frequency}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Text(
                        "Form: ",
                        style: TextStyle(fontSize: 18),
                      ),
                    ] +
                    widget.activityItem.response.formOfStoolTypes
                        .map<Text>((e) => Text(
                              "${e['name']}: ${e['count']}",
                              style: const TextStyle(fontSize: 18),
                            ))
                        .toList(),
              );
      case "food":
        return widget.activityItem.response == null
            ? const Text("No Data")
            :
            // Text(activityItem.response.breakfast);
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.activityItem.response.breakfast
                        .map<Widget>((food) => FoodItemInfoCard(
                              foodItem: food,
                            ))
                        .toList() +
                    widget.activityItem.response.lunch
                        .map<Widget>((food) => FoodItemInfoCard(
                              foodItem: food,
                            ))
                        .toList() +
                    widget.activityItem.response.dinner
                        .map<Widget>((food) => FoodItemInfoCard(
                              foodItem: food,
                            ))
                        .toList() +
                    widget.activityItem.response.others
                        .map<Widget>((food) => FoodItemInfoCard(
                              foodItem: food,
                            ))
                        .toList(),
              );
      case "digestion":
        return widget.activityItem.response == null
            ? const Text("No Data")
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Constipation: ${constipationTypes[widget.activityItem.response.constipation]}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Bloated: ${bloatedTypes[widget.activityItem.response.bloated]}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Diarrhea: ${diarrheaTypes[widget.activityItem.response.diarrhea]}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Pain: ${painTypes[widget.activityItem.response.pain]}",
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              );
      default:
        return const Text("No Data");
    }
  }
}
