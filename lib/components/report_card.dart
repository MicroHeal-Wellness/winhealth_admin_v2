import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/weekly_patient_nutrient_report_model.dart';
import 'package:winhealth_admin_v2/models/weekly_patient_psyc_report_model.dart';
import 'package:winhealth_admin_v2/screens/patient_screens/view_report_response.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class ReportCard extends StatelessWidget {
  final WeeklyPatientNutrientReportModel weeklyPatientReport;
  final VoidCallback onEdit;
  final VoidCallback onView;
  const ReportCard({
    super.key,
    required this.weeklyPatientReport,
    required this.onEdit,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weeklyPatientReport.week!,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              "Last Filled/Update: ${weeklyPatientReport.dateUpdated == null ? weeklyPatientReport.dateCreated.toString().split(".").first.split("T").join(" ") : weeklyPatientReport.dateUpdated.toString().split(".").first.split("T").join(" ")}",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: onEdit,
                  color: Colors.white,
                  minWidth: 200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Edit Report",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                MaterialButton(
                  onPressed: onView,
                  color: primaryColor,
                  minWidth: 200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "View Report",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
