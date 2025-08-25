// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shop_app/data/network/app_colors.dart';
// import 'package:shop_app/modules/manager/controller/manager_controller.dart';
// import 'package:shop_app/widgets/common_extension.dart';
// import 'package:shop_app/widgets/helper.dart';
// import 'package:shop_app/widgets/tap_anim_button.dart';

// import '../../../models/schedule_list_response.dart';

// class ManagerActionScheduleView extends GetView<ManagerController> {
//   final ScheduleDateTimeModel schedule;
//   const ManagerActionScheduleView(this.schedule, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         height: 40.h(context),
//         padding: const EdgeInsets.all(16.0),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//         ),
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(top: 16, bottom: 8),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       "Authorize Booking",
//                       style: GoogleFonts.inter(fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   InkWell(
//                     child: Icon(color: AppColors.neutral400, Icons.close),
//                     onTap: () {
//                       Get.back();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
//               child: Divider(color: AppColors.lightGrey),
//             ),
//             Row(
//               children: [
//                 buttonWithLoader(
//                   disable: false,
//                   isLoading: false,
//                   context: context,
//                   label: "Reject",
//                   color: AppColors.primaryAccent,
//                   onPressed: () {
//                     Get.back(closeOverlays: true);
//                     controller.submitForm(schedule, "Reject");
//                   },
//                 ),
//                 horizontalSpacing(16),
//                 buttonWithLoader(
//                   disable: false,
//                   isLoading: false,
//                   context: context,
//                   label: "Approve",
//                   color: AppColors.primary,
//                   onPressed: () {
//                     Get.back(closeOverlays: true);
//                     controller.submitForm(schedule, "ok");
//                   },
//                 ),
//               ],
//             ),
//             // Expanded(child: ,),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//       // ),
//     );
//   }
// }
