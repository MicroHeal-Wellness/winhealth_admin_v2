import 'package:flutter/material.dart';
import 'package:winhealth_admin_v2/components/subscription_enrollment.dart';
import 'package:winhealth_admin_v2/models/user_model.dart';
import 'package:winhealth_admin_v2/services/partner_group_service.dart';
import 'package:winhealth_admin_v2/services/partner_service.dart';
import 'package:winhealth_admin_v2/services/patient_service.dart';
import 'package:winhealth_admin_v2/utils/date_time_utils.dart';

class PartnerGroupSummary extends StatefulWidget {
  final UserModel currentUser;
  const PartnerGroupSummary({super.key, required this.currentUser});

  @override
  State<PartnerGroupSummary> createState() => _PartnerGroupSummaryState();
}

class _PartnerGroupSummaryState extends State<PartnerGroupSummary> {
  bool isLoading = true;
  int totalPatients = 0;
  int totalPatientsGlobal = 0;
  int paidSubscriptionPatients = 0;
  int clinicalTrialPatients = 0;
  int noSubscriptionPatients = 0;
  List<SubscriptionEnrollment> subscriptionHistory = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Update with actual data fetching logic
    totalPatientsGlobal = await PatientService.getTotalPatientCount();
    totalPatients = await PartnerGroupService.fetchPartnerGrroupPatientCount(
        widget.currentUser.patientGroup!.id);

    paidSubscriptionPatients =
        await PartnerGroupService.fetchPartnerGrroupPatientPaidSubscribedCount(
            widget.currentUser.patientGroup!.id);
    clinicalTrialPatients =
        await PartnerGroupService.fetchPartnerGrroupPatientTrailSubscribedCount(
            widget.currentUser.patientGroup!.id);
    subscriptionHistory =
        await PartnerGroupService.fetchPartnerGrroupPatientSubcription(
            widget.currentUser.patientGroup!.id);
    setState(() {
      noSubscriptionPatients =
          totalPatients - paidSubscriptionPatients - clinicalTrialPatients;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  buildSummaryCard(
                      'Total Patients (Global)', totalPatientsGlobal),
                  buildSummaryCard('Your Patients', totalPatients),
                  buildSummaryCard('Your Paid Subscription Patients',
                      paidSubscriptionPatients),
                  buildSummaryCard('Your Trial Subscription Patients',
                      clinicalTrialPatients),
                  buildSummaryCard(
                      'Your No Subscription Patients', noSubscriptionPatients),
                  const SizedBox(height: 32),
                  const Text(
                    'Subscription Purchase History',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  buildSubscriptionHistoryList(subscriptionHistory),
                ],
              ),
            ),
    );
  }

  Widget buildSummaryCard(String title, int count) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSubscriptionHistoryList(List<SubscriptionEnrollment> history) {
    if (history.isEmpty) {
      return const Text("No Subscription Yet");
    }
    return ListView.builder(
      shrinkWrap:
          true, // This is important to make ListView work inside a SingleChildScrollView
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling of the ListView
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            title: Text(
                "${item.userCreated!.firstName} ${item.userCreated!.lastName!}"),
            subtitle: Text(DateTimeUtils.apiFormattedDate(
                item.dateCreated!.toLocal().toString())),
            trailing: Text(item.plan!.title ?? "Free"),
          ),
        );
      },
    );
  }
}
