import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/widgets/comon_widgets.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
            const SizedBox(height: 20),
            Container(
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
                        "Rahul",
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
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(8.0),

                  lableValue(label: "Email:", value: "Rahul@gmail.com"),
                  verticalSpace(4.0),
                  lableValue(label: "Mobile:", value: "(+91)1234567890"),
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
                        .substring(0, 5)
                  ),
                  verticalSpace(4.0),
                  lableValue(
                    label: "Location:",
                    value: "Delhi, INDIA",
                  ),
                ],
              ),
            ),
            verticalSpace(16.0),

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
