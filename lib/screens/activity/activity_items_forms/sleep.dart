

import 'package:flutter/material.dart';

import '../../../models/activity.dart';
import '../../../utils/activity_utils.dart';
import '../../../utils/wh_slider.dart';


List<String> sleepQualityTypes = [
  "Awful",
  "Bad",
  "Not bad",
  "Good",
  "Great",
];
var divisionSleepQuality = sleepQualityTypes.length - 1;
const divisionSleepDuration = 16;

class ActivityItemSleep extends StatelessWidget {
  final ActivityItem? activityItem;
  final Function(Map<String, dynamic> value) onChange;

  const ActivityItemSleep({Key? key, this.activityItem, required this.onChange})
      : super(key: key);

  void onChangeHandler(String key, dynamic value) {
    dynamic newValue = {
      'duration':
          activityItem!.response == null ? 0 : activityItem?.response.duration,
      'quality':
          activityItem!.response == null ? 0 : activityItem?.response.quality,
    };
    newValue[key] = value;
    onChange(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(
          child: Container(
        margin: const EdgeInsets.only(top: 24.0, bottom: 32.0),
        width: 150.0,
        height: 180.0,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/activity-sleep.png'))),
      )),
      Container(
        margin: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Quality of sleep",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            activityItem?.response != null
                ? Text(
                    sleepQualityTypes[activityItem!.response == null
                        ? 0
                        : activityItem!.response.quality],
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color:
                            getActivityItemColor(activityItem!.activityType!)),
                  )
                : const Text(""),
          ],
        ),
      ),
      Container(
          padding: const EdgeInsets.only(left: 4, right: 8),
          child: WHSlider(
            activeColor: getActivityItemColor(activityItem!.activityType!),
            divisions: divisionSleepQuality,
            max: divisionSleepQuality.toDouble(),
            value: activityItem?.response == null
                ? 0
                : activityItem?.response.quality.toDouble(),
            onChanged: (value) => onChangeHandler('quality', value.round()),
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            sleepQualityTypes[0],
          ),
          Text(
            sleepQualityTypes[sleepQualityTypes.length - 1],
          ),
        ],
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 32)),
      Container(
        margin: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Duration of sleep (hours)",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            activityItem?.response != null
                ? Text(
                    "${activityItem?.response.duration} hours",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color:
                            getActivityItemColor(activityItem!.activityType!)),
                  )
                : const Text(""),
          ],
        ),
      ),
      Container(
          padding: const EdgeInsets.only(left: 4, right: 8),
          child: WHSlider(
            activeColor: getActivityItemColor(activityItem!.activityType!),
            divisions: divisionSleepDuration,
            max: divisionSleepDuration.toDouble(),
            value: activityItem?.response == null
                ? 0
                : activityItem?.response.duration.toDouble(),
            onChanged: (value) => onChangeHandler('duration', value.round()),
          )),
      Container(
        padding: const EdgeInsets.only(bottom: 24),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "0 hours",
            ),
            Text(
              "$divisionSleepDuration hours",
            ),
          ],
        ),
      ),
    ]);
  }
}
