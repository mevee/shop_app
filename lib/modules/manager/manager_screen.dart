import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/common/dialog_util.dart';
import 'package:shop_app/common/drop_down.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/models/agent_list_response.dart';
import 'package:shop_app/models/schedule_list_response.dart';
import 'package:shop_app/navigation/app_pages.dart';
import 'package:shop_app/widgets/helper.dart';
import 'package:shop_app/widgets/tap_anim_button.dart';

import 'controller/manager_controller.dart';

class ManagerScreen extends GetView<ManagerController> {
  const ManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Approve schedules'),
        centerTitle: true,
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 8,
                left: 16,
                right: 16,
              ),
              child: Obx(
                () => SizedBox(
                  width: double.maxFinite,
                  child: GenericDropdown<AgentModel>(
                    options: controller.agentList.value,
                    selectedOption: controller.agent,
                    hintText: "Select User",
                    onChanged: (value) {
                      controller.agent = value;
                      controller.selectedAgent.value = value?.userName ?? "";
                      controller.getTodaysScheduleList();
                    },
                  ),
                ),
              ),
            ),
            Obx(() => progressAndNoDatFound(controller.isLoading.value)),
            Obx(
              () => Visibility(
                visible: controller.isActionLoading.value,
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.scheduleList.length,
                  itemBuilder: (context, index) {
                    final model = controller.scheduleList[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8.0),

                      child: Container(
                        margin: const EdgeInsets.all(6.0),
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 5.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.neutral200,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.book_online_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                                horizontalSpacing(8),
                                Expanded(
                                  child: Text(
                                    "SHOP: ${model.shopName ?? 'Unknown Schedule'}\nScheduled Date: ${model.scheduleDateTime}\nStatus: ${model.status}\nIs Authorize: ${model.isAuthorized}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            actionBtns(model, context),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Expanded(child: ,),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget actionBtns(ScheduleDateTimeModel model, BuildContext context) {
    if (model.isVisitDone == 0 && model.isAuthorized == "Request to Cancel") {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            buttonWithLoader(
              disable: false,
              isLoading: false,
              context: context,
              label: "Cancel Reject",
              textColor: AppColors.blackText,
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              onPressed: () {
                showInputDialog(
                  context: context,
                  placeholder: "Pleaase enter remark",
                  errorText: "Remark required",
                  title: "Remark",
                  submitLabel: "Reject",
                  onSubmit: (input) {
                    controller.submitForm(model, input, false);
                  },
                );
              },
            ),
            horizontalSpacing(16),
            buttonWithLoader(
              disable: false,
              isLoading: false,
              context: context,
              label: "Cancel Approve",
              textColor: AppColors.white,
              color: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              onPressed: () {
                showInputDialog(
                  context: context,
                  placeholder: "Pleaase enter remark",
                  errorText: "Remark required",
                  title: "Remark Required",
                  submitLabel: "Approve",
                  onSubmit: (input) {
                    controller.submitForm(model, input, true);
                  },
                );
              },
            ),
          ],
        ),
      );
    }
    //  else if (model.isAuthorized == "Pending" && model.isVisitDone == 1) {
    //   //view only completed by agent
    //   return viewScheduleButton(model, context);
    // } else if (model.isAuthorized == "Pending" && model.isVisitDone == 2) {
    //   //view only canceled by agent
    //   return viewScheduleButton(model, context);
    // } else if (model.isAuthorized == "Authorized" && model.isVisitDone == 0) {
    //   //view only completed by agent
    //   return viewScheduleButton(model, context);
    // } else if (model.isAuthorized == "Authorized" && model.isVisitDone == 1) {
    //   //view only canceled by agent
    //   return viewScheduleButton(model, context);
    // } else if (model.isAuthorized == "Authorized" && model.isVisitDone == 2) {
    //   //view only completed by agent
    //   return viewScheduleButton(model, context);
    // } else if (model.isAuthorized == "Reject" && model.isVisitDone == 0) {
    //   //view only canceled by agent
    //   return viewScheduleButton(model, context);
    // } else if (model.isAuthorized == "Reject" && model.isVisitDone == 1) {
    //   //view only canceled by agent
    //   return viewScheduleButton(model, context);
    // } 
    else if (model.isVisitDone == 2) {
      //view only canceled by agent
      return viewScheduleButton(model, context);
    }
    else {
      return SizedBox.shrink();
    }
  }

  Widget viewScheduleButton(ScheduleDateTimeModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buttonWithLoader(
            disable: false,
            isLoading: false,
            context: context,
            label: "View",
            textColor: AppColors.blackText,
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onPressed: () {
              final payoad = {"id": model};
              Get.toNamed(Routes.scheduleDetail, arguments: payoad);
            },
          ),
        ],
      ),
    );
  }

  Widget progressAndNoDatFound(bool value) {
    if (controller.scheduleList.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "No Schedule",
            style: TextStyle(color: AppColors.neutral400),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
