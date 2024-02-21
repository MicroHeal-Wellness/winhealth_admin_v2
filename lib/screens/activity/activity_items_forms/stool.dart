import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/activity.dart';
import '../../../utils/activity_utils.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/constants.dart';
import '../../../utils/wh_slider.dart';

class ActivityItemStool extends StatefulWidget {
  final ActivityItem? activityItem;
  final bool allowUpdate;
  final Function(Map<String, dynamic> value) onChange;

  const ActivityItemStool(
      {Key? key,
      this.activityItem,
      required this.onChange,
      required this.allowUpdate})
      : super(key: key);

  @override
  State<ActivityItemStool> createState() => _ActivityItemStoolState();
}

class _ActivityItemStoolState extends State<ActivityItemStool> {
  int totalCount = 0;
  bool loading = true;
  List<Map<String, dynamic>> formOfStoolTypes = [
    {
      'name': "Separated hard lumps",
      'icon': AppIcons.stoolFormSeparatedHardLumps,
      'count': 0,
    },
    {
      'name': "Lumpy and Sausage",
      'icon': AppIcons.stoolFormLumpyAndSausage,
      'count': 0,
    },
    {
      'name': "Sausage with cracks",
      'icon': AppIcons.stoolFormSausageWithCracks,
      'count': 0,
    },
    {
      'name': "Perfectly Smooth",
      'icon': AppIcons.stoolFormPerfectlySmooth,
      'count': 0,
    },
    {
      'name': "Mushy",
      'icon': AppIcons.stoolFormMushy,
      'count': 0,
    },
    {
      'name': "Liquid",
      'icon': AppIcons.stoolFormLiquid,
      'count': 0,
    },
    {
      'name': "Soft Blobs",
      'icon': AppIcons.stoolFormSoftBlobs,
      'count': 0,
    },
  ];
  void onChangeHandler(String kayName, int keyValue) {
    dynamic newValue = {
      'frequency': keyValue.toInt(),
      'formOfStoolTypes': formOfStoolTypes,
    };
    if (kayName == 'frequency') {
      setState(() {
        totalCount = keyValue.toInt();
      });
    }
    newValue[kayName] = keyValue;
    widget.onChange(newValue);
  }

  int divisionStoolFrequency = 12;
  @override
  void initState() {
    super.initState();
    getInitData();
  }

  getInitData() {
    setState(() {
      loading = true;
    });
    if (widget.activityItem != null && widget.activityItem!.response != null) {
      totalCount = widget.activityItem!.response.frequency ?? 0;
      if (widget.activityItem!.response.formOfStoolTypes.length ==
          formOfStoolTypes.length) {
        formOfStoolTypes.clear();
        widget.activityItem!.response.formOfStoolTypes.forEach(
          (form) => {
            print(form),
            formOfStoolTypes.add(
              form,
            ),
          },
        );
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Frequency of stool",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                    (widget.activityItem?.response != null)
                        ? Text(
                            "${widget.activityItem?.response.frequency} times",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: getActivityItemColor(
                                    widget.activityItem!.activityType!)),
                          )
                        : const Text(""),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(left: 4, right: 8),
                  child: WHSlider(
                    activeColor: getActivityItemColor(
                        widget.activityItem!.activityType!),
                    divisions: divisionStoolFrequency,
                    max: divisionStoolFrequency.toDouble(),
                    value: widget.activityItem?.response == null
                        ? 0
                        : widget.activityItem?.response.frequency.toDouble() ??
                            0,
                    onChanged: (value) =>
                        onChangeHandler('frequency', value.toInt()),
                  )),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "0 times",
                  ),
                  Text(
                    "12 times",
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 16)),
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 24),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Form of stool",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width > 1600
                        ? 7
                        : size.width > 1000
                            ? 5
                            : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: formOfStoolTypes.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(16 - size.height * 0.01),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        // color: selectedOptionIndex == index ? primaryColor : tileColor,
                        color: const Color(0xFFF2F2F2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(formOfStoolTypes[index]['icon'],
                              color:
                                  //  selectedOptionIndex == index
                                  //     ? Colors.white
                                  //     :
                                  primaryColor),
                          Text(
                            formOfStoolTypes[index]['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // quanity button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              !widget.allowUpdate
                                  ? const SizedBox()
                                  : GestureDetector(
                                      onTap: () {
                                        if (formOfStoolTypes[index]['count'] >
                                            0) {
                                          setState(() {
                                            formOfStoolTypes[index]['count']--;
                                          });
                                        } else {
                                          setState(() {
                                            formOfStoolTypes[index]['count'] =
                                                0;
                                          });
                                          // Fluttertoast.showToast(
                                          //     msg: "Count can't be less than 0",
                                          //     toastLength: Toast.LENGTH_SHORT,
                                          //     gravity: ToastGravity.BOTTOM,
                                          //     timeInSecForIosWeb: 1,
                                          //     backgroundColor: Colors.red,
                                          //     textColor: Colors.white,
                                          //     fontSize: 16.0);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: const Color(0xFF5BC496),
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4)),
                              Text(
                                !widget.allowUpdate
                                    ? widget.activityItem!.response == null
                                        ? "0"
                                        : widget.activityItem!.response
                                            .formOfStoolTypes![index]['count']
                                            .toString()
                                    : "${formOfStoolTypes[index]['count']}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4)),
                              !widget.allowUpdate
                                  ? const SizedBox()
                                  : GestureDetector(
                                      onTap: () {
                                        if (formOfStoolTypes
                                                .map((e) => e['count'])
                                                .reduce((value, element) =>
                                                    value + element) <
                                            totalCount) {
                                          setState(() {
                                            formOfStoolTypes[index]['count']++;
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Total Count can't be more than selected count",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: const Color(0xFF5BC496),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 16)),
            ],
          );
  }
}
