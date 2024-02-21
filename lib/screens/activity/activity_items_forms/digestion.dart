

import 'package:flutter/material.dart';

import '../../../models/activity.dart';
import '../../../utils/activity_utils.dart';
import '../../../utils/wh_slider.dart';


List<String> constipationTypes = [
  "None",
  "Not very severe",
  "Quite severe",
  "Severe",
  "Extremely severe",
];
var divisionConstipation = constipationTypes.length - 1;

List<String> bloatedTypes = [
  "None",
  "Not very severe",
  "Quite severe",
  "Severe",
  "Extremely severe",
];
var divisionBloated = bloatedTypes.length - 1;

List<String> diarrheaTypes = [
  "None",
  "Not very severe",
  "Quite severe",
  "Severe",
  "Extremely severe",
];
var divisionDiarrhea = diarrheaTypes.length - 1;

List<String> painTypes = [
  "None",
  "Noticeable discomfort",
  "Tolerable pain",
  "In a lot of pain",
  "Extreme pain",
];
var divisionPain = painTypes.length - 1;

class ActivityItemDigestion extends StatelessWidget {
  final ActivityItem? activityItem;
  final Function(Map<String, dynamic> value) onChange;

  const ActivityItemDigestion({Key? key, this.activityItem, required this.onChange})
      : super(key: key);

  void onChangeHandler(String key, dynamic value) {
    dynamic newValue = {
      'constipation': activityItem!.response == null ? 0 : activityItem?.response.constipation,
      'bloated': activityItem!.response == null ? 0 : activityItem?.response.bloated,
      'diarrhea': activityItem!.response == null ? 0 : activityItem?.response.diarrhea,
      'pain': activityItem!.response == null ? 0 : activityItem?.response.pain,
    };
    newValue[key] = value;
    onChange(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Constipation
      Container(
        margin: const EdgeInsets.only(top: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Constipation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            activityItem?.response != null
                ? Text(
                    constipationTypes[activityItem?.response ==null ? 0 : activityItem?.response.constipation],
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: getActivityItemColor(activityItem!.activityType!)),
                  )
                : const Text(""),
          ],
        ),
      ),
      Container(
          padding: const EdgeInsets.only(left: 4, right: 8),
          child: WHSlider(
            activeColor: getActivityItemColor(activityItem!.activityType!),
            divisions: divisionConstipation,
            max: divisionConstipation.toDouble(),
            value: activityItem?.response ==null ? 0 : activityItem?.response.constipation?.toDouble(),
            onChanged: (value) => onChangeHandler('constipation', value.round()),
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            constipationTypes[0],
          ),
          Text(
            constipationTypes[constipationTypes.length - 1],
          ),
        ],
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 32)),

      // Bloated
      Container(
        margin: const EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Bloated",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            activityItem?.response != null
                ? Text(
                    bloatedTypes[ activityItem?.response ==null ? 0 : activityItem?.response.bloated ],
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: getActivityItemColor(activityItem!.activityType!)),
                  )
                : const Text(""),
          ],
        ),
      ),
      Container(
          padding: const EdgeInsets.only(left: 4, right: 8),
          child: WHSlider(
            activeColor: getActivityItemColor(activityItem!.activityType!),
            divisions: divisionBloated,
            max: divisionBloated.toDouble(),
            value: activityItem?.response ==null ? 0 :  activityItem?.response.bloated?.toDouble(),
            onChanged: (value) => onChangeHandler('bloated', value.round()),
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            constipationTypes[0],
          ),
          Text(
            constipationTypes[constipationTypes.length - 1],
          ),
        ],
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 32)),

      // Diarrhea
      Container(
        margin: const EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Diarrhea",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            activityItem?.response != null
                ? Text(
                    diarrheaTypes[activityItem?.response ==null ? 0 : activityItem?.response.diarrhea],
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: getActivityItemColor(activityItem!.activityType!)),
                  )
                : const Text(""),
          ],
        ),
      ),
      Container(
          padding: const EdgeInsets.only(left: 4, right: 8),
          child: WHSlider(
            activeColor: getActivityItemColor(activityItem!.activityType!),
            divisions: divisionDiarrhea,
            max: divisionDiarrhea.toDouble(),
            value: activityItem?.response ==null ? 0 :  activityItem?.response.diarrhea?.toDouble(),
            onChanged: (value) => onChangeHandler('diarrhea', value.round()),
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            constipationTypes[0],
          ),
          Text(
            constipationTypes[constipationTypes.length - 1],
          ),
        ],
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 32)),

      // Pain
      Container(
        margin: const EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Pain",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            activityItem?.response != null
                ? Text(
                    painTypes[activityItem?.response ==null ? 0 : activityItem?.response.pain ],
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: getActivityItemColor(activityItem!.activityType!)),
                  )
                : const Text(""),
          ],
        ),
      ),
      Container(
          padding: const EdgeInsets.only(left: 4, right: 8),
          child: WHSlider(
            activeColor: getActivityItemColor(activityItem!.activityType!),
            divisions: divisionPain,
            max: divisionPain.toDouble(),
            value: activityItem?.response ==null ? 0 :  activityItem?.response.pain?.toDouble() ,
            onChanged: (value) => onChangeHandler('pain', value.round()),
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            constipationTypes[0],
          ),
          Text(
            constipationTypes[constipationTypes.length - 1],
          ),
        ],
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 24)),
    ]);
  }
}
