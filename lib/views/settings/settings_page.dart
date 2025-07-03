import 'package:flutter/material.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/settings/change_password_page.dart';

import '../../storage_services/local_stoage_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../welcome_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with BaseClass{
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
                  getTile(title: 'Change Password', onTap: () {
                    pushToNextScreen(context: context, destination: ChangePasswordPage());
                  }),
                  SizedBox(height: 16,),
                  getTile(title: 'Help', onTap: () {}),
                  SizedBox(height: 16,),
                  getTile(title: 'About', onTap: () {}),
                  SizedBox(height: 16,),
                  getTile(title: 'Logout', onTap: () {
                    StorageService().clearData();
                    pushReplaceAndClearStack(
                      context: context,
                      destination: WelcomePage(),
                    );
                  }),
                  SizedBox(height: 16,),
                ],
              ),
            ),
          ),
          TextButton(onPressed: (){}, child: Text('Delete Account',style: AppStyles.font500_16().copyWith(color: Colors.red),)),
          SizedBox(height: 50,),
        ],
      ),
    );
  }

  Widget getTile({required String title, required Function onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade500),
        ),
        child: Text(
          title,
          style: AppStyles.font700_16().copyWith(color: Colors.black),
        ),
      ),
    );
  }
}
