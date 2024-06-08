import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/models/weekly_patient_report_model.dart';

class ViewReportResponse extends StatelessWidget {
  final WeeklyPatientReportModel weeklyReportResponse;
  const ViewReportResponse({super.key, required this.weeklyReportResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const BackButton(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${weeklyReportResponse.patient!.firstName}'s Weekly Reports",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Name: ${weeklyReportResponse.week}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Stomach Pain: ${weeklyReportResponse.stomachPain}, Weekly Frequency: ${weeklyReportResponse.stomachPainNos}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              "Acid Reflux: ${weeklyReportResponse.acidReflux}, Weekly Frequency: ${weeklyReportResponse.acidRefluxNos}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              "Acidity: ${weeklyReportResponse.acidity}, Weekly Frequency: ${weeklyReportResponse.acidityNos}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              "Stomach Pain: ${weeklyReportResponse.stomachPain}, Weekly Frequency: ${weeklyReportResponse.stomachPainNos}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              "Heart Burn: ${weeklyReportResponse.heartBurn}, Weekly Frequency: ${weeklyReportResponse.heartBurnNos}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              "Bloating: ${weeklyReportResponse.bloating}, Weekly Frequency: ${weeklyReportResponse.bloatingNos}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              "Burping: ${weeklyReportResponse.burping}, Weekly Frequency: ${weeklyReportResponse.burpingNos}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              "Farting: ${weeklyReportResponse.farting}, Weekly Frequency: ${weeklyReportResponse.fartingNos}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              "Constipation: ${weeklyReportResponse.constipation}, Weekly Frequency: ${weeklyReportResponse.constipationNos}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              "Diarrhoea: ${weeklyReportResponse.diarrhoea}, Weekly Frequency: ${weeklyReportResponse.diarrhoeaNos}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
