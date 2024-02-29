import 'package:flutter/material.dart';

const primaryColor = Color(0xFFFF8692);

const accessSpecifiers = {
  "appointment": "Appointment",
  "slots": "Slots",
  "doctors": "Doctors",
  "changerole": "Change Role",
  "patients": "Patients",
  "activityinfo": "Activity Info",
  "editactivityinfo": "Edit Activity Info",
  "activitystats": "Activity Stats",
  "dietplan": "Diet Plan",
  "notes": "Notes",
  "team_notes": "Team Notes",
  "formbuilder": "Forms",
  "patientform": "Patient Form",
  "uploads": "Uploads",
  "taskview": "Task View",
  "accessmangement": "Access Mangement",
  "user_directory": "User Directory"
};

String getDoctorAvatarPath(String gender) {
  return gender == 'm'
      ? 'assets/images/missing-avatar-male.jpeg'
      : 'assets/images/missing-avatar-female.jpeg';
}

jobLabel(String val) {
  switch (val) {
    case "Nutritionist":
      return "Nutritionist";
    case "Behavioural":
      return "Behavioural";
    case "Care manager":
      return "Care manager";
    default:
      return val;
  }
}
// data.forEach((element: { user: any; }) => {
//         let tp: any = {
//           ...element,
//           ...element.user
//         };
//         delete tp.user;
//         p.push(tp);
//       });