import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/models/schedule_list_response.dart';

Widget scheduleItemView({
  required ScheduleDateTimeModel model,
  required Function() onClick,
}) {
  return InkWell(
    onTap: onClick,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: model.isVisitDone == 2
            ? AppColors.yellow
            : model.isVisitDone == 1
            ? AppColors.green
            : AppColors.red,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "${model.shopName} \nShceduled: ${model.scheduleDateTime}\nStatus: ${model.status}",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: AppColors.white,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                height: 50,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  padding: const EdgeInsets.symmetric(
                    vertical: 3.0,
                    horizontal: 10.0,
                  ),
                  decoration: BoxDecoration(
                    // color: AppColors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    _stausString(model),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

String _stausString(ScheduleDateTimeModel model) {
  if (model.isVisitDone == 0 && model.isAuthorized == "Authorized") {
    return "NOT VISITED";
  } else if (model.isVisitDone == 0 &&
      model.isAuthorized == "Request to Cancel") {
    return "PENDING";
  }
  // Cancel Rejected other wise Cancel Accepted
  else if (model.isVisitDone == 0 && model.isAuthorized == "Cancel Rejected") {
    // return "CANCEL NOT ALLOWED";
    return "NOT VISITED";
  } else if (model.isVisitDone == 0 &&
      model.isAuthorized == "Cancel Accepted") {
    return "CANCELLED";
  } else if (model.isVisitDone == 2) {
    return "CANCELLED";
  } else {
    return 'VISITED';
  }
}
