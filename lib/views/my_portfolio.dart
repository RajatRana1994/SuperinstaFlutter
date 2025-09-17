import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/controllers/profile_controller.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/my_portfolio/portfolio_details.dart';

import '../dialogs/ask_dialog.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import 'my_portfolio/add_portfolio_page.dart';

class MyPortfolioPage extends StatefulWidget {
  const MyPortfolioPage({super.key});

  @override
  State<MyPortfolioPage> createState() => _MyPortfolioPageState();
}

class _MyPortfolioPageState extends State<MyPortfolioPage> with BaseClass {
  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getMyPortfolio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'My Portfolio',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
        actions: [
          IconButton(
            onPressed: () {
              pushToNextScreen(
                context: context,
                destination: AddPortfolioPage(),
              );
            },
            icon: Icon(Icons.add_circle),
            color: Colors.orange,
          ),
        ],
      ),
      body: GetBuilder<ProfileController>(
        init: controller,
        builder: (snapshot) {
          return controller.myPortfolioData == null
              ? Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
            ),
          )
              : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              itemCount: snapshot.myPortfolioData?.length ?? 0,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 10,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
              ),
              padding: EdgeInsets.all(0),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    pushToNextScreen(
                      context: context,
                      destination: PortfolioDetails(
                        portfolioModelDataData: snapshot.myPortfolioData
                            ?.elementAt(index),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white),
                      color: Colors.white,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 120,
                              width: 120,
                              child: Image.network(
                                snapshot.myPortfolioData
                                    ?.elementAt(index)
                                    ?.image ??
                                    '',
                                height: 120,
                                fit: BoxFit.cover,
                                width: 120,
                                // fit: BoxFit.cover,
                                // ⬇️ show a local fallback if the network image can’t load
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                    Image.asset(
                                      'assets/images/icon.png',
                                      // put the asset in pubspec.yaml
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                              ),
                            ),

                            SizedBox(height: 16),
                            Text(
                              snapshot.myPortfolioData
                                  ?.elementAt(index)
                                  ?.title ??
                                  '',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: AppStyles.font400_12().copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            onPressed: () async {
                              final result = await showCupertinoConfirmDialog(
                                context: context,
                                title: 'Delete Portfolio?',
                                description:
                                'Are you sure to delete your portfolio item, Please re-check and confirm',
                              );

                              if (result == true) {
                                await controller.deletePortfolio(
                                    snapshot.myPortfolioData
                                        ?.elementAt(index)
                                        ?.id
                                        .toString() ??
                                        '',index
                                );
                              } else if (result == false) {
                                // user pressed No
                              } else {
                                // dialog dismissed
                              }
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
