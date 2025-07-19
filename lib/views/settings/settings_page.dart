import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_images.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/settings/change_password_page.dart';
import 'package:instajobs/controllers/profile_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:get/get.dart';
import '../../storage_services/local_stoage_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../welcome_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with BaseClass {
  final ProfileController _profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Settings',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  getTile(
                    title: 'Change Password',
                    image: AppImages.icHelp,
                    onTap: () {
                      pushToNextScreen(
                        context: context,
                        destination: ChangePasswordPage(),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  getTile(title: 'Help', image: AppImages.icHelp, onTap: () {}),
                  SizedBox(height: 16),
                  getTile(
                    title: 'About',
                    image: AppImages.icAbout,
                    onTap: () async {
                      const url = 'https://superinstajobs.com';

                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        showError(
                          title: 'Error',
                          message: 'Could not launch URL',
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  getTile(
                    title: 'Logout',
                    image: AppImages.icLogout,
                    onTap: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Logout'),
                              content: Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );

                      if (shouldLogout == true) {
                        try {
                          await _profileController.logoutApi();
                          StorageService().clearData();
                          pushReplaceAndClearStack(
                            context: context,
                            destination: WelcomePage(),
                          );
                        } catch (e) {
                          showError(
                            title: 'Logout Failed',
                            message: e.toString(),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to delete account?'),
                  actions: [
                    TextButton(
                      onPressed:
                          () => Navigator.of(context).pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed:
                          () => Navigator.of(context).pop(true),
                      child: Text(
                        'Delete Account',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                try {
                  await _profileController.deleteAccountApi();
                  StorageService().clearData();
                  pushReplaceAndClearStack(
                    context: context,
                    destination: WelcomePage(),
                  );
                } catch (e) {
                  showError(
                    title: 'Logout Failed',
                    message: e.toString(),
                  );
                }
              }
            },

            child: Text(
              'Delete Account',

              style: AppStyles.font700_18().copyWith(
                color: Color(0xFFFF6464),
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFFFF6464),
              ),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget getTile({
    required String title,
    required String image,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFECECEC)), // updated color
        ),
        child: Row(
          children: [
            Image.asset(image, height: 24, width: 24),
            SizedBox(width: 12),
            Text(
              title,
              style: AppStyles.font500_14().copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
