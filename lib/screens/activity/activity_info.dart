import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:winhealth_admin_v2/components/activity_info_card.dart';
import 'package:winhealth_admin_v2/models/activity.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/activity_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class ActivityInfo extends StatefulWidget {
  final UserModel patient;
  final UserModel currentUser;
  const ActivityInfo(
      {super.key, required this.patient, required this.currentUser});

  @override
  State<ActivityInfo> createState() => _ActivityInfoState();
}

class _ActivityInfoState extends State<ActivityInfo> {
  ScrollController scrollController = ScrollController();
  bool showbtn = false;
  DateTime today = DateTime.now();
  DateTime? currentDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  bool isLoadingActivities = false;
  List<ActivityItem> dayActivityList = [];
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
    getInitData();
    super.initState();
  }

  getInitData() async {
    setState(() {
      isLoadingActivities = true;
    });
    dayActivityList = await ActivityService.getActivitiesByUserIDandDate(
        widget.patient.id!, DateFormat('yyyy-MM-dd').format(currentDate!));
    setState(() {
      isLoadingActivities = false;
    });
  }

  bool loading = false;
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
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const BackButton(),
                        const SizedBox(
                          width: 32,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${widget.patient.firstName}'s Activity Info",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 64,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Date: ${currentDate!.day.toString().padLeft(2, "0")}-${currentDate!.month.toString().padLeft(2, "0")}-${currentDate!.year.toString().padLeft(2, "0")}",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // const Spacer(),
                        const SizedBox(
                          width: 32,
                        ),
                        GestureDetector(
                          onTap: () async {
                            currentDate = await showDatePicker(
                                  context: context,
                                  initialDate: currentDate!,
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2923),
                                ) ??
                                DateTime.now();
                            setState(() {});
                            await getInitData();
                          },
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: primaryColor,
                            child: Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                              size: 24,
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
                    ListView.builder(
                      itemBuilder: (context, index) {
                        return ActivityInfoCard(
                          activityItem: dayActivityList[index],
                          patient: widget.patient,
                          currentUser: widget.currentUser,
                          func: getInitData,
                          currentDateTime: currentDate!,
                          isEditable: currentDate!.isBefore(today),
                        );
                      },
                      itemCount: dayActivityList.length,
                      shrinkWrap: true,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:winhealth_admin_v2/screens/activity/activity_item.dart';
// import 'package:winhealth_admin_v2/screens/activity_stats.dart';

// import '../../models/activity.dart';
// import '../../models/user_model.dart';
// import '../../services/activity_service.dart';
// import '../../services/base_service.dart';
// import '../../utils/activity_utils.dart';
// import '../../utils/date_time_utils.dart';

// class ActivityInfo extends StatefulWidget {
//   const ActivityInfo({super.key, this.patient});

//   final UserModel? patient;

//   @override
//   State<ActivityInfo> createState() => _ActivityInfoState();
// }

// class _ActivityInfoState extends State<ActivityInfo> {
//   @override
//   void initState() {
//     super.initState();
//     getInitData();
//   }

//   List<String> displayDates = [];
//   bool isDisplayDatesHasToday = false;

//   bool isLoadingActivities = false;
//   List<ActivityItem> dayActivityList = [];
//   static String todayDate =
//       DateTimeUtils.apiFormattedDate(DateTimeUtils.getUtcDateNow());
//   String currentDate = todayDate;
//   UserModel? currentUser;

//   // void onPreviousClick() async {
//   //   var dateObj = DateTime.parse(currentDate).toLocal();
//   //   var prevDate = dateObj.subtract(const Duration(days: 1)).toIso8601String();
//   //   String date = DateTimeUtils.apiFormattedDate(prevDate);
//   //   setState(() {
//   //     currentDate = date;
//   //   });
//   //   await getDateWiseActivity(date);
//   // }

//   // void onNextClick() async {
//   //   if (currentDate == todayDate) return;
//   //   var dateObj = DateTime.parse(currentDate).toLocal();
//   //   var nextDate = dateObj.add(const Duration(days: 1)).toIso8601String();
//   //   String date = DateTimeUtils.apiFormattedDate(nextDate);
//   //   setState(() {
//   //     currentDate = date;
//   //   });
//   //   await getDateWiseActivity(date);
//   // }

//   void onPreviousClick() async {
//     var firstDisplayDateObj = DateTime.parse(displayDates[0]).toLocal();
//     var newFirstDisplayDateObj =
//         firstDisplayDateObj.subtract(const Duration(days: 3)).toIso8601String();
//     await updateNewDisplayDates(newFirstDisplayDateObj, 2);
//   }

//   void onNextClick() async {
//     var lastDisplayDateObj = DateTime.parse(displayDates[2]).toLocal();
//     var newFirstDisplayDateObj =
//         lastDisplayDateObj.add(const Duration(days: 1)).toIso8601String();
//     await updateNewDisplayDates(newFirstDisplayDateObj, 0);
//   }

//   updateNewDisplayDates(
//       String newFirstDisplayDateObj, int newSelectedDateIndex) async {
//     String newFirstDisplayDate =
//         DateTimeUtils.apiFormattedDate(newFirstDisplayDateObj);
//     List<String> newDisplayDates = getDisplayDates(newFirstDisplayDate);
//     await getDateWiseActivity(newDisplayDates[newSelectedDateIndex]);
//     setState(() {
//       currentDate = newDisplayDates[newSelectedDateIndex];
//       displayDates = newDisplayDates;
//     });
//   }

//   List<String> getDisplayDates(String date) {
//     var dateObject = DateTime.parse(date).toLocal();
//     String date1 = DateTimeUtils.apiFormattedDate(date);
//     final datePlus1 = dateObject.add(const Duration(days: 1)).toIso8601String();
//     String date2 = DateTimeUtils.apiFormattedDate(datePlus1);
//     final datePlus2 = dateObject.add(const Duration(days: 2)).toIso8601String();
//     String date3 = DateTimeUtils.apiFormattedDate(datePlus2);
//     return [date1, date2, date3];
//   }

//   void onClickActivityItem(
//       BuildContext context, ActivityItem activityItem) async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ActivityItemScreen(
//             currentUser: currentUser!,
//             activityItem: activityItem,
//             allowUpdate: currentDate ==
//                 DateTimeUtils.apiFormattedDate(DateTimeUtils.getUtcDateNow())
//             // activityItem.response != null
//             //     ? false
//             //     : currentDate ==
//             //         DateTimeUtils.apiFormattedDate(DateTimeUtils.getUtcDateNow()),
//             ),
//       ),
//     );
//     await getInitData();
//   }

//   getDateWiseActivity(date) async {
//     setState(() {
//       isLoadingActivities = true;
//     });
//     dayActivityList = await ActivityService.getActivitiesByUserIDandDate(
//         currentUser!.id.toString(), date);

//     //sorting the list of activities by activity type alphabetically
//     dayActivityList.sort((a, b) => a.activityType!.compareTo(b.activityType!));
//     setState(() {
//       isLoadingActivities = false;
//     });
//   }

//   getInitData() async {
//     setState(() {
//       isLoadingActivities = true;
//     });
//     currentUser = await BaseService.getCurrentUser();
//     await getDateWiseActivity(currentDate);
//     displayDates = getDisplayDates(currentDate);
//     setState(() {
//       isLoadingActivities = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                   margin: const EdgeInsets.only(top: 32),
//                   child: Text(
//                     "${widget.patient!.firstName}'s Activity Info",
//                     style: const TextStyle(
//                       fontSize: 24.0,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   )),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ActivityStats(
//                         patient: widget.patient!,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   height: 90,
//                   margin: const EdgeInsets.only(top: 32),
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xff5AC496),
//                         Color(0xffA4DEC5),
//                       ],
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                     ),
//                     borderRadius: BorderRadius.all(Radius.circular(16.0)),
//                   ),
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 24),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                         "See Activity Stats",
//                           style: TextStyle(
//                               fontSize: 24.0, color: Colors.white),
//                         ),
//                         Icon(
//                           Icons.chevron_right_rounded,
//                           size: 24.0,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                       margin: const EdgeInsets.only(top: 32),
//                       child: const Text(
//                         "Log Activity",
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       )),
//                   Container(
//                       margin: const EdgeInsets.only(top: 32),
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(
//                             height: 82, // fixed height
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   margin: const EdgeInsets.only(right: 8),
//                                   child: Ink(
//                                     width: 32,
//                                     height: double.infinity,
//                                     decoration: const ShapeDecoration(
//                                       color: Color(0xffF2F2F2),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(16.0)),
//                                       ),
//                                     ),
//                                     child: InkWell(
//                                       onTap: isDisplayDatesHasToday
//                                           ? null
//                                           : () => onPreviousClick(),
//                                       child: Icon(
//                                         Icons.arrow_back_ios_new_rounded,
//                                         color: isDisplayDatesHasToday
//                                             ? Colors.black26
//                                             : Colors.black87,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   shrinkWrap: true,
//                                   itemCount: displayDates.length,
//                                   itemBuilder: (context, index) {
//                                     String date = displayDates[index];
//                                     Color selectedItemColor =
//                                         currentDate == date
//                                             ? const Color(0xffFFD6DA)
//                                             : const Color(0xffF2F2F2);
//                                     return GestureDetector(
//                                         onTap: () async {
//                                           String date2 =
//                                               DateTimeUtils.apiFormattedDate(
//                                                   date);
//                                           setState(() {
//                                             currentDate = date2;
//                                           });
//                                           await getDateWiseActivity(
//                                               currentDate);
//                                         },
//                                         child: Container(
//                                           margin:
//                                               const EdgeInsets.only(right: 8),
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 16, vertical: 16),
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 const BorderRadius.all(
//                                               Radius.circular(16),
//                                             ),
//                                             color: selectedItemColor,
//                                           ),
//                                           child: Column(
//                                             children: [
//                                               Container(
//                                                 margin: const EdgeInsets.only(
//                                                     bottom: 6),
//                                                 child: Text(
//                                                   DateFormat(
//                                                     "EEE",
//                                                   ).format(
//                                                     DateTime.parse(date)
//                                                         .toLocal(),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Text(
//                                                 DateFormat("MMMd").format(
//                                                   DateTime.parse(date)
//                                                       .toLocal(),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ));
//                                   },
//                                 ),
//                                 Container(
//                                   margin: const EdgeInsets.only(right: 8),
//                                   child: Ink(
//                                     width: 32,
//                                     height: double.infinity,
//                                     decoration: const ShapeDecoration(
//                                       color: Color(0xffF2F2F2),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(16.0)),
//                                       ),
//                                     ),
//                                     child: InkWell(
//                                       onTap: () => onNextClick(),
//                                       child: const Icon(
//                                         Icons.arrow_forward_ios_rounded,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           isLoadingActivities
//                               ? const Center(
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 4.0,
//                                   ),
//                                 )
//                               : Container(
//                                   margin: const EdgeInsets.only(top: 36),
//                                   child: RefreshIndicator(
//                                     onRefresh: () async {
//                                       await getInitData();
//                                     },
//                                     child: ListView.builder(
//                                       scrollDirection: Axis.vertical,
//                                       shrinkWrap: true,
//                                       physics: const ClampingScrollPhysics(),
//                                       itemCount: dayActivityList.length,
//                                       itemBuilder: (context, index) {
//                                         return GestureDetector(
//                                           onTap: () => onClickActivityItem(
//                                             context,
//                                             dayActivityList[index],
//                                           ),
//                                           child: Container(
//                                             margin: const EdgeInsets.only(
//                                                 bottom: 16),
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 16, vertical: 16),
//                                             decoration: BoxDecoration(
//                                               // color: Colors.white,
//                                               color: dayActivityList[index]
//                                                           .response ==
//                                                       null
//                                                   ? Colors.white
//                                                   : getActivityItemColor(
//                                                       dayActivityList[index]
//                                                           .activityType!),
//                                               borderRadius:
//                                                   const BorderRadius.all(
//                                                       Radius.circular(16.0)),
//                                               border: Border.all(
//                                                 color: getActivityItemColor(
//                                                     dayActivityList[index]
//                                                         .activityType!),
//                                               ),
//                                             ),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Text(
//                                                   dayActivityList[index]
//                                                           .activityType![0]
//                                                           .toUpperCase() +
//                                                       dayActivityList[index]
//                                                           .activityType!
//                                                           .substring(1),
//                                                   style: TextStyle(
//                                                     fontSize: 20.0,
//                                                     fontWeight: FontWeight.w600,
//                                                     color:
//                                                         dayActivityList[index]
//                                                                     .response ==
//                                                                 null
//                                                             ? Colors.black87
//                                                             : Colors.white,
//                                                   ),
//                                                 ),
//                                                 dayActivityList[index]
//                                                             .response ==
//                                                         null
//                                                     ? Icon(
//                                                         Icons
//                                                             .arrow_forward_ios_rounded,
//                                                         color: getActivityItemColor(
//                                                             dayActivityList[
//                                                                     index]
//                                                                 .activityType!),
//                                                       )
//                                                     : SizedBox(
//                                                         width: 24,
//                                                         height: 24,
//                                                         child: Container(
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             color: Colors.white,
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         16),
//                                                             border: Border.all(
//                                                               color:
//                                                                   getActivityItemColor(
//                                                                 dayActivityList[
//                                                                         index]
//                                                                     .activityType!,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           child: Icon(
//                                                             Icons.done,
//                                                             color: getActivityItemColor(
//                                                                 dayActivityList[
//                                                                         index]
//                                                                     .activityType!),
//                                                             size: 14,
//                                                           ),
//                                                         ),
//                                                       )
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                         ],
//                       )),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
