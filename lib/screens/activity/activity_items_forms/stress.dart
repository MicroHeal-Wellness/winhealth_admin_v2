

import 'package:flutter/material.dart';

import '../../../models/activity.dart';
import '../../../utils/activity_utils.dart';
import '../../../utils/wh_slider.dart';

List<String> moodTypes = [
  "Happy, relaxed, calm, content",
  "Okay, well enough, passable",
  "Sad, upset, depressed",
  "Anxious, worried, fearful",
  "Disgusted, tired",
  "Angry, annoyed, tense, irritable",
];
var moodDivisions = moodTypes.length - 1;

class ActivityItemStress extends StatelessWidget {
  final ActivityItem? activityItem;
  final Function(Map<String, dynamic> value) onChange;

  const ActivityItemStress(
      {Key? key, this.activityItem, required this.onChange})
      : super(key: key);

  void onChangeHandler(dynamic changedValue) {
    dynamic newValue = {
      'mood': changedValue,
    };
    onChange(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 24.0, bottom: 32.0),
            width: 150.0,
            height: 180.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  'images/activity-mood.png',
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 32),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "How's your mood?",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          child: Center(
            child: Text(
              moodTypes[activityItem?.response == null
                  ? 0
                  : activityItem?.response.mood],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: getActivityItemColor(activityItem!.activityType!),
              ),
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.only(left: 4, right: 8),
            child: WHSlider(
              activeColor: getActivityItemColor(activityItem!.activityType!),
              divisions: moodDivisions,
              max: moodDivisions.toDouble(),
              value: activityItem?.response == null
                  ? 0
                  : activityItem?.response.mood?.toDouble(),
              // label: (activityItem?.value ?? 0).round().toString(),
              onChanged: (value) => onChangeHandler(value.round()),
            )),
        Container(
          padding: const EdgeInsets.only(bottom: 24),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Happy",
              ),
              Text(
                "Angry",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
