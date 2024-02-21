import 'package:flutter/material.dart';

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 1;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class WHSlider extends StatelessWidget {
  final double value;
  final Color? activeColor;
  final int? divisions;
  final double? min;
  final double max;
  final String? label;
  final Function(double)? onChanged;

  const WHSlider(
      {Key? key,
      required this.value,
      this.activeColor,
      this.divisions,
      this.min,
      required this.max,
      this.label,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
        // data: SliderThemeData(
        //   trackShape: CustomTrackShape(),
        // ),
        data: SliderTheme.of(context).copyWith(
          // trackHeight: 10.0,
          // trackShape: RoundedRectSliderTrackShape(),
          trackShape: CustomTrackShape(),
          // activeTrackColor: Colors.purple.shade800,
          // inactiveTrackColor: Colors.purple.shade100,
          // thumbShape: RoundSliderThumbShape(
          //   enabledThumbRadius: 14.0,
          //   pressedElevation: 8.0,
          // ),
          // thumbColor: Colors.pinkAccent,
          // overlayColor: Colors.pink.withOpacity(0.2),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
          // tickMarkShape: RoundSliderTickMarkShape(),
          // activeTickMarkColor: Colors.pinkAccent,
          // inactiveTickMarkColor: Colors.white,
          valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
          valueIndicatorColor: Colors.black,
          valueIndicatorTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
          showValueIndicator: ShowValueIndicator.onlyForDiscrete,
        ),
        child: Slider(
          activeColor: activeColor,
          inactiveColor: const Color(0xffD9D9D9),
          min: min ?? 0,
          max: max,
          divisions: divisions,
          value: value,
          // label: label ?? value.toString(),
          onChanged: onChanged,
        ));
  }
}
