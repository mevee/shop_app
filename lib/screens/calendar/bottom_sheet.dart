// // ignore_for_file: use_build_context_synchronously

// import 'package:digilawyer/app/core/common_extension.dart';
// import 'package:digilawyer/app/core/dialog_helper.dart';
// import 'package:digilawyer/app/core/localization_extension.dart';
// import 'package:digilawyer/app/core/utils/helper.dart';
// import 'package:digilawyer/app/manager/assets_manager/app_images.dart';
// import 'package:digilawyer/app/modules/profile/views/archived_bottom_sheet.dart';
// import 'package:digilawyer/app/modules/profile/views/shared_bottom_sheet.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// import '../../../core/managers/app_state_manager.dart';
// import '../../../manager/assets_manager/app_colors.dart';
// import '../../../routes/app_pages.dart';
// import '../controllers/profile_controller.dart';

// class BottomSheetContent extends StatelessWidget {
//   BottomSheetContent({super.key});

//   final ProfileController controller = Get.put(ProfileController());

//   Widget displayWidget(BuildContext context) {
//     if (controller.widgetType.value == context.localized.general) {
//       return const GeneralSection();
//     } else if (controller.widgetType.value == context.localized.dataControl) {
//       return const DataControlSection();
//     } else if (controller.widgetType.value == context.localized.security) {
//       return SecuritySection();
//     } else {
//       return const GeneralSection();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Container(
//         height: 60.h(context),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(25.0),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                   top: 24, bottom: 24, left: 16, right: 16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       context.localized.settings,
//                       style: GoogleFonts.inter(
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     child: Icon(color: AppColors.neutral400, Icons.close),
//                     onTap: () {
//                       Get.back();
//                     },
//                   )
//                 ],
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
//               child: Divider(
//                 color: AppColors.lightGrey,
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 16, right: 16),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: AppColors.lightGrey100),
//                           borderRadius: BorderRadius.circular(4.0),
//                         ),
//                         child: IntrinsicHeight(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Expanded(
//                                 child: TextButton(
//                                   style: TextButton.styleFrom(
//                                     backgroundColor:
//                                         controller.widgetType.value ==
//                                                 context.localized.general
//                                             ? Colors.black
//                                             : Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(4.0),
//                                     ), // Set the shape
//                                   ),
//                                   onPressed: () {
//                                     controller.widgetType.value =
//                                         context.localized.general;
//                                   },
//                                   child: Text(
//                                     context.localized.general,
//                                     style: GoogleFonts.inter(
//                                         fontWeight: FontWeight.w600,
//                                         color: controller.widgetType.value ==
//                                                 context.localized.general
//                                             ? Colors.white
//                                             : AppColors.grey),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: TextButton(
//                                   style: TextButton.styleFrom(
//                                     backgroundColor:
//                                         controller.widgetType.value ==
//                                                 context.localized.dataControl
//                                             ? Colors.black
//                                             : Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(4.0),
//                                     ), // Set the shape
//                                   ),
//                                   onPressed: () {
//                                     controller.widgetType.value =
//                                         context.localized.dataControl;
//                                   },
//                                   child: Text(
//                                     context.localized.dataControl,
//                                     style: GoogleFonts.inter(
//                                         fontWeight: FontWeight.w600,
//                                         color: controller.widgetType.value ==
//                                                 context.localized.dataControl
//                                             ? Colors.white
//                                             : AppColors.grey),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: TextButton(
//                                   style: TextButton.styleFrom(
//                                     backgroundColor:
//                                         controller.widgetType.value ==
//                                                 context.localized.security
//                                             ? Colors.black
//                                             : Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(4.0),
//                                     ), // Set the shape
//                                   ),
//                                   onPressed: () {
//                                     controller.widgetType.value =
//                                         context.localized.security;
//                                   },
//                                   child: Text(
//                                     context.localized.security,
//                                     style: GoogleFonts.sora(
//                                         fontWeight: FontWeight.w600,
//                                         color: controller.widgetType.value ==
//                                                 context.localized.security
//                                             ? Colors.white
//                                             : AppColors.grey),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 16.0),
//                       child: displayWidget(context),
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GeneralSection extends GetView<ProfileController> {
//   const GeneralSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Column(children: [
//         CustomListItem(
//           text: context.localized.archivedChats,
//           text2: context.localized.manage,
//           icon: const Image(
//             image: AppImages.archive,
//           ),
//           onTap: () {
//             if (controller.isArchivedBottomSheetVisible.value) return;

//             controller.isArchivedBottomSheetVisible.value = true;
//             controller.archivedBottomSheet.call(() async {
//               controller.allArchivedChats.clear();
//               controller.scrollTimesArchived.value = 0;
//               controller.isLoadingArchived.value = true;
//               await controller.getAllArchivedChats();
//               if (controller.allArchivedChats.isEmpty) {
//                 controller.showToast(message: 'Nothing to see here');
//                 controller.isArchivedBottomSheetVisible.value = false;
//               } else {
//                 showModalBottomSheet(
//                   isScrollControlled: true,
//                   context: context,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(25.0),
//                     ),
//                   ),
//                   builder: (context) => ArchivedBottomSheet(),
//                 ).whenComplete(() {
//                   controller.isArchivedBottomSheetVisible.value = false;
//                 });
//               }
//             });
//           },
//           paddingLeft: 15,
//           paddingRight: 19,
//           color: AppColors.headingGrey,
//         ),
//         const Padding(
//           padding: EdgeInsets.only(left: 16, right: 16),
//           child: Divider(
//             color: AppColors.lightGrey100,
//           ),
//         ),
//         CustomListItem(
//             text: context.localized.acheiveAllChats,
//             text2: context.localized.achieve,
//             onTap: () {
//               controller.isLoading.value = true;
//               controller.updateChats(false, true);
//             },
//             isLoading: controller.isLoading.value,
//             icon: const Image(
//               image: AppImages.archive,
//             ),
//             paddingLeft: 15,
//             paddingRight: 19,
//             color: AppColors.headingGrey),
//         const Padding(
//             padding: EdgeInsets.only(left: 16, right: 16),
//             child: Divider(
//               color: AppColors.lightGrey100,
//             )),
//         CustomListItem(
//             text: context.localized.deleteAllChats,
//             text2: context.localized.delete,
//             onTap: () {
//               DialogHelper.commonConfirmationDialog(
//                   context: context,
//                   title: context.localized.deleteChatsTitle,
//                   content: "",
//                   isErrorDialog: true,
//                   secondButtonText: context.localized.delete,
//                   secondButtonImage: AppImages.delete,
//                   onClick: () =>
//                       {controller.updateChats(true, false), Get.back()});
//             },
//             icon: const Image(
//               image: AppImages.delete,
//             ),
//             paddingLeft: 19,
//             paddingRight: 23,
//             color: AppColors.red01),
//         const Padding(
//             padding: EdgeInsets.only(left: 16, right: 16),
//             child: Divider(
//               color: AppColors.lightGrey100,
//             )),
//         Padding(
//           padding: const EdgeInsets.only(left: 16, right: 16),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(context.localized.alwaysShowLegalCases,
//                     style: GoogleFonts.inter(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                         color: AppColors.grey)),
//               ),
//               Transform.scale(
//                 scale: 0.6,
//                 child: CupertinoSwitch(
//                     trackColor: AppColors.lightGrey200,
//                     value: controller.switchValue.value,
//                     onChanged: (value) {
//                       controller.switchValue.value = value;
//                     }),
//               ),
//             ],
//           ),
//         ),
//         const Padding(
//             padding: EdgeInsets.only(left: 16, right: 16),
//             child: Divider(
//               color: AppColors.lightGrey100,
//             )),
//         Padding(
//           padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Text(context.localized.languages,
//                     style: GoogleFonts.inter(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                         color: AppColors.grey)),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 4),
//                 child: dropdown(context: context, options: Languages.values),
//               )
//             ],
//           ),
//         ),
//       ]),
//     );
//   }

//   Widget dropdown({
//     required BuildContext context,
//     required List<Languages>? options, // List of UserType enum options
//   }) {
//     return Obx(
//       () => Container(
//         height: 32,
//         width: 104,
//         decoration: const BoxDecoration(
//           color: AppColors.darkWhite1,
//           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton2(
//             // customButton: ,
//             isExpanded: true,
//             menuItemStyleData: MenuItemStyleData(
//               customHeights: controller.menuHeights(options?.length ?? 0),
//               padding: const EdgeInsets.all(0.0),
//             ),
//             style: GoogleFonts.inter(
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//               color: AppColors.textGrey,
//             ),
//             items:
//                 getLanguagesList(context: context, languageList: options ?? []),
//             onChanged: (Languages? newValue) {
//               if (newValue != null) {
//                 controller.changeDropDownLanguageOption(
//                     newValue.displayName); // Update with enum display name
//               }
//             },
//             customButton: Row(
//               children: [
//                 Expanded(
//                   child: Text(controller.dropDownLanguageValue.value,
//                       style: GoogleFonts.inter(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                         color: AppColors.black2,
//                       )),
//                 ),
//                 horizontalSpacing(8),
//                 const Image(width: 15, image: AppImages.downArrow)
//               ],
//             ).paddingSymmetric(horizontal: 19.5),
//             dropdownStyleData: DropdownStyleData(
//                 padding: const EdgeInsets.all(0),
//                 maxHeight: 200,
//                 offset: Offset(0, -0.1.h(context)),
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8))),
//           ),
//         ),
//       ),
//     );
//   }

//   List<DropdownMenuItem<Languages>>? getLanguagesList(
//       {required BuildContext context, required List<Languages> languageList}) {
//     final List<DropdownMenuItem<Languages>> items = [];
//     for (var i = 0; i < (languageList.length); i++) {
//       items.add(
//         DropdownMenuItem<Languages>(
//           value: languageList[i],
//           child: Obx(
//             () => Container(
//               height: double.maxFinite,
//               width: 100.w(context),
//               color: controller.dropDownLanguageValue.value ==
//                       languageList[i].displayName
//                   ? Colors.grey.withOpacity(0.5)
//                   : Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
//               child: Text(
//                 languageList[i].displayName,
//                 style: GoogleFonts.inter(fontWeight: FontWeight.w400),
//               ),
//             ),
//           ),
//         ),
//       );
//       if (i != ((languageList.length) - 1)) {
//         items.add(
//           DropdownMenuItem<Languages>(
//             enabled: false,
//             alignment: Alignment.center,
//             child: Divider(
//               height: 1.0,
//               color: Colors.black.withOpacity(0.15),
//             ),
//           ),
//         );
//       }
//     }
//     return items;
//   }
// }

// class DataControlSection extends GetView<ProfileController> {
//   const DataControlSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       CustomListItem(
//           text: context.localized.sharedLink,
//           text2: context.localized.manage,
//           icon: const Image(
//             image: AppImages.edit,
//           ),
//           paddingLeft: 15,
//           paddingRight: 19,
//           color: AppColors.grey,
//           onTap: () {
//             if (controller.isSharedBottomSheetVisible.value) return;

//             controller.isSharedBottomSheetVisible.value = true;
//             controller.sharedBottomSheet.call(() async {
//               await controller.getSharedChats();
//               if (controller.allSharedChats.isEmpty) {
//                 controller.isSharedBottomSheetVisible.value = false;
//                 controller.showToast(message: 'Nothing to see here');
//               } else {
//                 showModalBottomSheet(
//                   isScrollControlled: true,
//                   context: context,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(25.0),
//                     ),
//                   ),
//                   builder: (context) => SharedBottomSheet(),
//                 ).whenComplete(() {
//                   controller.isSharedBottomSheetVisible.value = false;
//                 });
//               }
//             });
//           }),
//       const Padding(
//         padding: EdgeInsets.only(left: 16, right: 16),
//         child: Divider(
//           color: AppColors.lightGrey100,
//         ),
//       ),
//       CustomListItem(
//           text: context.localized.exportData,
//           text2: context.localized.export,
//           icon: const Image(
//             image: AppImages.export,
//           ),
//           paddingLeft: 15,
//           paddingRight: 19,
//           color: AppColors.grey),
//       const Padding(
//         padding: EdgeInsets.only(left: 16, right: 16),
//         child: Divider(
//           color: AppColors.lightGrey100,
//         ),
//       ),
//       CustomListItem(
//           text: context.localized.deleteAccount,
//           onTap: () {
//             DialogHelper.commonConfirmationDialog(
//                 context: context,
//                 title: context.localized.deleteAccountPopup,
//                 content: context.localized.deleteAccountDescription,
//                 isErrorDialog: true,
//                 secondButtonText: context.localized.delete,
//                 secondButtonImage: AppImages.delete,
//                 onClick: () => {
//                       controller.deleteAccount().then((value) {
//                         if (value == 200) {
//                           controller.userManager.logOut();
//                           ApplicationState().userLoggedOut();
//                           Get.offAllNamed(Routes.login);
//                         }
//                       }),
//                     });
//           },
//           text2: context.localized.delete,
//           icon: const Image(
//             image: AppImages.delete,
//           ),
//           paddingLeft: 19,
//           paddingRight: 23,
//           color: AppColors.red01),
//       const Padding(
//         padding: EdgeInsets.only(left: 16, right: 16),
//         child: Divider(
//           color: AppColors.lightGrey100,
//         ),
//       ),
//     ]);
//   }
// }

// class SecuritySection extends StatelessWidget {
//   SecuritySection({super.key});
//   final ProfileController controller = Get.put(ProfileController());

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CustomListItem(
//             text: context.localized.multiFactorAuthentication,
//             text2: context.localized.enable,
//             icon: const Image(
//               image: AppImages.securitySafe,
//             ),
//             paddingLeft: 15,
//             paddingRight: 19,
//             color: AppColors.grey),
//         const Padding(
//           padding: EdgeInsets.only(left: 16, right: 16),
//           child: Divider(
//             color: AppColors.lightGrey100,
//           ),
//         ),
//         CustomListItem(
//             onTap: () {
//               DialogHelper.commonConfirmationDialog(
//                   context: context,
//                   title: context.localized.logoutDialoagTitle,
//                   content: context.localized.logoutDialogContent,
//                   isErrorDialog: true,
//                   secondButtonText: context.localized.logout,
//                   secondButtonImage: AppImages.logout,
//                   onClick: () async => {
//                         await GoogleSignIn().signOut(),
//                         controller.userManager.logOut(),
//                         ApplicationState().userLoggedOut(),
//                         Get.offAllNamed(Routes.login),
//                       });
//             },
//             text: context.localized.logoutOfAllDevices,
//             text2: context.localized.logout,
//             icon: const Image(
//               image: AppImages.logout,
//             ),
//             paddingLeft: 15,
//             paddingRight: 19,
//             color: AppColors.red01),
//         const Padding(
//           padding: EdgeInsets.only(left: 16, right: 16),
//           child: Divider(
//             color: AppColors.lightGrey100,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ignore: must_be_immutable
// class CustomListItem extends StatelessWidget {
//   CustomListItem(
//       {super.key,
//       required this.text,
//       required this.text2,
//       required this.icon,
//       required this.paddingLeft,
//       required this.paddingRight,
//       required this.color,
//       this.onTap,
//       this.isLoading});
//   final String text;
//   final Image icon;
//   final String text2;
//   final double paddingLeft;
//   final double paddingRight;
//   final Color color;
//   bool? isLoading;
//   final VoidCallback? onTap;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               text,
//               style: GoogleFonts.inter(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 14,
//                   color: AppColors.grey),
//             ),
//           ),
//           InkWell(
//             onTap: onTap,
//             child: Container(
//               height: 32,
//               width: 130,
//               decoration: BoxDecoration(
//                   border: Border.all(
//                     color: AppColors.lightGrey100,
//                   ),
//                   borderRadius: const BorderRadius.all(Radius.circular(3))),
//               child: Center(
//                 child: Visibility(
//                   visible: !(isLoading ?? false),
//                   replacement: const SizedBox(
//                     height: 18,
//                     width: 18,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 1,
//                       color: AppColors.brown,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                           padding: const EdgeInsets.only(left: 8),
//                           child: SizedBox(height: 18, width: 18, child: icon)),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             left: 8.0, right: 8, top: 6, bottom: 6),
//                         child: Text(
//                           text2,
//                           style: GoogleFonts.inter(
//                               fontWeight: FontWeight.w400,
//                               fontSize: 12,
//                               color: color),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
