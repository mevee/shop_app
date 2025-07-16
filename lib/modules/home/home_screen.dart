import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/models/login_response.dart';
import 'package:shop_app/modules/home/controller/dashboard_controller.dart';
import 'package:shop_app/utils/app_images.dart';
import 'package:shop_app/widgets/comon_widgets.dart';

class HomeScreen extends GetView<DashboardController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      //   centerTitle: true,
      //   backgroundColor: Colors.deepPurple,
      //   foregroundColor: Colors.white,
      // ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.getEmployeeAttandance,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Shop App',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Obx(
                  () => CommonWidgets.button(
                    lable: 'Log OUT',
                    color: controller.punchIn.value ? Colors.red : Colors.green,
                    onPressed: () {
                      controller.logout();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => userInfoWidget(controller.userData.value.login)),
                verticalSpace(16.0),
                Row(
                  children: [
                    Image(
                      image: AssetImages.timeline,
                      width: 24,
                      height: 24,
                    ),
                    Text(
                      "Distance Travelled Today: ${controller.distance.value}",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CommonWidgets.button(
                        lable: 'Clock IN',
                        onPressed: () {},
                      ),
                    ),
                    horizontalSpace(16),
                    Expanded(
                      child: CommonWidgets.button(
                        lable: 'Clock OUT',
                        color: Colors.red,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                verticalSpace(16.0),
                Text(
                  "Todays Logs",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpace(8.0),
                ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Text(
                            DateTime.now()
                                .toLocal()
                                .toString()
                                .split(' ')[1]
                                .substring(0, 5),
                          ),
                          Spacer(),
                          Transform(
                            // angle: index % 2 == 0 ? 90 : 125,
                            alignment: FractionalOffset.center,
                            transform: Matrix4.identity()
                              ..rotateZ(
                                (index % 2 == 0 ? 140 : 315) * 3.1415927 / 180,
                              ),
                            child: Icon(
                              Icons.arrow_back,
                              color: index % 2 == 0 ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container userInfoWidget([UserData? data]) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Hello, ",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                ),
              ),
              Text(
                data?.fullName ?? "",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    "Working Staus",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Obx(
                ()=> Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Icon(Icons.circle, color:controller.punchIn.value? Colors.green:Colors.red, size: 16),
                ),
              ),
            ],
          ),
          verticalSpace(8.0),

          lableValue(label: "Email:", value: data?.emailId ?? ""),
          verticalSpace(4.0),
          lableValue(label: "Mobile:", value: data?.contactNo ?? ""),
          verticalSpace(4.0),
          lableValue(
            label: "Date:",
            value: DateTime.now().toLocal().toString().split(' ')[0],
          ),
          verticalSpace(4.0),
          lableValue(
            label: "Time:",
            value: DateTime.now()
                .toLocal()
                .toString()
                .split(' ')[1]
                .substring(0, 5),
          ),
          verticalSpace(4.0),
          lableValue(label: "Location:", value: data?.address ?? ""),
        ],
      ),
    );
  }

  Row lableValue({required String label, String? value}) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black54,
          ),
        ),
        horizontalSpace(8.0),
        Text(
          value ?? '',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget horizontalSpace(double i) {
    return SizedBox(width: i, height: 0);
  }

  Widget verticalSpace(double i) {
    return SizedBox(height: i, width: 0);
  }
}
