import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_workconnect/constants.dart';
import 'package:final_project_workconnect/controller/auth_controller.dart';
import 'package:final_project_workconnect/controller/theme_controller.dart';
import 'package:final_project_workconnect/model/FirebaseHelper.dart';
import 'package:final_project_workconnect/model/business.dart';
import 'package:final_project_workconnect/view/screens/business/auth/business_login_screen.dart';
import 'package:final_project_workconnect/view/screens/business/business_status_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessHomeScreen extends StatefulWidget {
  const BusinessHomeScreen({super.key});

  @override
  State<BusinessHomeScreen> createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  AuthController authController = Get.put(AuthController());
  ThemeController themeController = Get.put(ThemeController());
  User? currentBusiness;
  Business? thisBusinessModel;
  List values = [];

  int pendingCount = 0;
  int acceptCount = 0;
  int rejectCount = 0;

  getBusinessInfo() async {
    currentBusiness = FirebaseAuth.instance.currentUser;
    thisBusinessModel =
        await FirebaseHelper.getBusinessModelById(currentBusiness!.uid);
  }

  Future<List> getApplicantsDetail(String val) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .where("uid", isEqualTo: currentBusiness!.uid)
        .get();

    List<Map<String, dynamic>> pendingApplicants = [];
    for (var doc in snapshot.docs) {
      var jobData = doc.data();
      var applicants = jobData['applicants'];
      var jobId = jobData['jobId'];

      for (var applicant in applicants) {
        if (applicant['status'] == val) {
          applicant['jobId'] = jobId;
          pendingApplicants.add(applicant);
        }
      }
    }

    return pendingApplicants;
  }

  @override
  Widget build(BuildContext context) {
    getBusinessInfo();

    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('jobs')
                .where("uid", isEqualTo: currentBusiness!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading...");
              }
              var result = snapshot.data!.docs;

              // result.forEach((data) =>
              //     values.add((data.data() as dynamic)['applicants']).);
              for (int i = 0; i < result.length; i++) {
                var resultData = (result[i].data() as dynamic)['applicants'];

                if (resultData.length == 1) {
                  values.add(resultData[0]);
                }
                if (resultData.length == 2) {
                  values.add(resultData[0]);
                  values.add(resultData[1]);
                }
                if (resultData.length == 3) {
                  values.add(resultData[0]);
                  values.add(resultData[1]);
                  values.add(resultData[2]);
                }
                if (resultData.length == 4) {
                  values.add(resultData[0]);
                  values.add(resultData[1]);
                  values.add(resultData[2]);
                  values.add(resultData[3]);
                }
                if (resultData.length == 5) {
                  values.add(resultData[0]);
                  values.add(resultData[1]);
                  values.add(resultData[2]);
                  values.add(resultData[3]);
                  values.add(resultData[4]);
                }
              }

              for (int i = 0; i < values.length; i++) {
                if (values[i]['status'] == 'accepted') {
                  acceptCount = acceptCount + 1;
                }
                if (values[i]['status'] == 'rejected') {
                  rejectCount = rejectCount + 1;
                }
                if (values[i]['status'] == 'pending') {
                  pendingCount = pendingCount + 1;
                }
              }

              return Container(
                color: iconBool ? Colors.black : Colors.grey[200],
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "WorkConnectBusiness",
                            style: GoogleFonts.roboto(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: iconBool ? Colors.white : Colors.black,
                            ),
                          ),
                          // Column(children: [
                          //   IconButton(
                          //     color: iconBool ? Colors.white : kPrimaryColor,
                          //     onPressed: () {
                          //       themeController.changeTheme();
                          //       setState(() {
                          //         iconBool = !iconBool;
                          //       });
                          //       if (iconBool == true) {
                          //         Get.changeTheme(darkTheme);
                          //       } else {
                          //         Get.changeTheme(lightTheme);
                          //       }
                          //     },
                          //     icon: Icon(
                          //       iconBool ? iconDark : iconLight,
                          //     ),
                          //   ),
                          // ]),
                        ],
                      ),
                    ),
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: InkWell(
                            onTap: () async {
                              List data = await getApplicantsDetail('pending');

                              Get.to(() => BusinessStatusScreen(data: data));
                            },
                            child: Container(
                                height: 120,
                                width: 400,
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(16.0),
                                  color: Colors.yellow[900],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Pending Applicants",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    SizedBox(height: 20),
                                    Text(pendingCount.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 22)),
                                  ],
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () async {
                            List data = await getApplicantsDetail('accepted');

                            Get.to(() => BusinessStatusScreen(data: data));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Container(
                                height: 120,
                                width: 400,
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(16.0),
                                  color: Colors.green[900],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Accepted Applicants",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    SizedBox(height: 20),
                                    Text(acceptCount.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 22)),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        List data = await getApplicantsDetail('rejected');

                        Get.to(() => BusinessStatusScreen(data: data));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Container(
                            height: 120,
                            width: 400,
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(16.0),
                              color: Colors.red[900],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Rejected Applicants",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                SizedBox(height: 20),
                                Text(rejectCount.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22)),
                              ],
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              );
            }));
  }
}
