import 'package:flutter/material.dart';

import '../../../models/activity.dart';
import '../../../utils/activity_utils.dart';
import '../../../utils/wh_slider.dart';

const maxWaterQuality = 10;
const divisionWaterQuantity = maxWaterQuality;

class ActivityItemWater extends StatelessWidget {
  final ActivityItem? activityItem;
  final Function(Map<String, dynamic> value) onChange;

  const ActivityItemWater({Key? key, this.activityItem, required this.onChange})
      : super(key: key);

  void onChangeHandler(double changedValue) {
    dynamic newValue = {
      'quantity': changedValue.toInt(),
    };
    onChange(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(
          child: Container(
        margin: const EdgeInsets.only(top: 32.0, bottom: 32.0),
        width: 150.0,
        height: 180.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              'images/activity-water.png',
            ),
          ),
        ),
      )),
      Container(
        margin: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Litres consumed",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            activityItem?.response != null
                ? Text(
                    "${activityItem?.response.quantity} liter",
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
            divisions: divisionWaterQuantity,
            max: maxWaterQuality.toDouble(),
            value: activityItem?.response == null
                ? 0
                : activityItem?.response.quantity.toDouble(),
            onChanged: (value) => onChangeHandler(value),
          )),
      Container(
        padding: const EdgeInsets.only(bottom: 24),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "0 liters",
            ),
            Text(
              "$maxWaterQuality liters",
            ),
          ],
        ),
      ),
    ]);
  }
}
