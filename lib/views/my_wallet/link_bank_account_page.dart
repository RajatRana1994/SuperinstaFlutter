import 'package:flutter/material.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../../controllers/my_wallet/my_wallet_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'package:get/get.dart';

class LinkBankAccountPage extends StatefulWidget {
  const LinkBankAccountPage({super.key});

  @override
  State<LinkBankAccountPage> createState() => _LinkBankAccountPageState();
}

class _LinkBankAccountPageState extends State<LinkBankAccountPage>
    with BaseClass {
  final MyWalletController _myWalletController = Get.put(MyWalletController());
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Add Bank',
          style: AppStyles.fontInkika().copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FormInputWithHint(
              label: 'Bank Name',
              hintText: 'Enter Bank Name',
              controller: bankNameController,
            ),
            SizedBox(height: 16),
            FormInputWithHint(
              label: 'Account Number',
              hintText: 'Enter account Name',
              controller: accountController,
            ),
            SizedBox(height: 16),
            RoundedEdgedButton(
              buttonText: 'Submit',
              onButtonClick: () async{
                if (bankNameController.text.trim().isEmpty) {
                  showError(
                    title: 'Bank Account',
                    message: 'Please enter Bank account',
                  );
                } else if (accountController.text.trim().isEmpty) {
                  showError(
                    title: 'Account Number',
                    message: 'Please enter account number',
                  );
                } else {
                  try {
                    showGetXCircularDialog();
                    await  _myWalletController.linkBankAccount(
                      accountNumber: accountController.text.trim(),
                      bankName: bankNameController.text.trim(),
                    );
                    Get.back();
                    showSuccess(
                      title: 'Link Account',
                      message: 'Bank account linked successfully',
                    );
                    bankNameController.clear();
                    accountController.clear();
                  }  catch (e) {
                    showError(title: 'Link Account', message: e.toString());
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
