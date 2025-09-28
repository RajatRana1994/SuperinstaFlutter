import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/controllers/my_wallet/my_wallet_controller.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/my_wallet/buy_coins_page.dart';
import 'package:instajobs/views/my_wallet/link_bank_account_page.dart';
import 'package:instajobs/views/my_wallet/widgets/credited_wallet_widget.dart';
import 'package:instajobs/views/my_wallet/widgets/debited_wallet_widget.dart';
import 'package:instajobs/views/my_wallet/widgets/pending_wallet_widget.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../../dialogs/ask_dialog.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class MyWalletPage extends StatefulWidget {
  const MyWalletPage({super.key});

  @override
  State<MyWalletPage> createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> with BaseClass {
  final MyWalletController _myWalletController = Get.put(MyWalletController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myWalletController.updateTab(
      isPendingSelected: true,
      isDebitedSelected: false,
      isCreditedSelected: false,
    );

    _myWalletController.getWalletDetails();
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
          'My Wallet',
          style: AppStyles.fontInkika().copyWith(fontSize: 20),
        ),
      ),
      body: GetBuilder<MyWalletController>(
        init: _myWalletController,
        builder: (snapshot) {
          return Column(
            children: [
              SizedBox(height: 20),
              _myWalletController.walletDetailsData == null
                  ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              )
                  : Column(
                children: [
                  Text(
                    _myWalletController.walletDetailsData?.balance
                        .toString() ??
                        '0',
                    style: AppStyles.font700_20().copyWith(
                      color: AppColors.orange,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Coin value in Naira ₦ is ${((_myWalletController.walletDetailsData?.balance ?? 0) / 1000)}',
                    style: AppStyles.font500_14().copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedEdgedButton(
                          buttonText: 'Cash Out',
                          onButtonClick: () async {
                            final result = await showCupertinoConfirmDialog(
                              context: context,
                              yesLabel: 'Link Now',
                              noLabel: 'Later',
                              title: 'Link Back Account',
                              description:
                              'Please link your bank account to cash out',
                            );
                            if (result == true) {
                              pushToNextScreen(
                                context: context,
                                destination: LinkBankAccountPage(),
                              );
                            } else if (result == false) {
                              // user pressed No
                            } else {
                              // dialog dismissed
                            }
                          },
                          backgroundColor: Colors.white,
                          borderColor: AppColors.textGreen,
                          textColor: AppColors.textGreen,
                          height: 44,
                          leftMargin: 20,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: RoundedEdgedButton(
                          buttonText: 'Buy Coins',
                          height: 44,
                          rightMargin: 20,
                          onButtonClick: () {
                            pushToNextScreen(
                              context: context,
                              destination: BuyCoinsPage(
                                walletId:
                                snapshot.walletDetailsData?.id
                                    .toString() ??
                                    '',
                              ),
                            );
                          },
                          backgroundColor: Colors.white,
                          borderColor: AppColors.orange,
                          textColor: AppColors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: RoundedEdgedButton(
                      buttonText: 'Pending',
                      height: 44,
                      fontWeight: FontWeight.w500,
                      leftMargin: 12,
                      onButtonClick: () {
                        _myWalletController.updateTab(
                          isPendingSelected: true,
                          isDebitedSelected: false,
                          isCreditedSelected: false,
                        );
                      },
                      backgroundColor:
                      snapshot.isPending
                          ? AppColors.btncolor
                          : AppColors.primaryColor.withOpacity(0.1),
                      textColor:
                      snapshot.isPending ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: RoundedEdgedButton(
                      buttonText: 'Debited',
                      fontWeight: FontWeight.w500,
                      height: 44,
                      leftMargin: 6,
                      rightMargin: 6,
                      onButtonClick: () {
                        _myWalletController.updateTab(
                          isPendingSelected: false,
                          isDebitedSelected: true,
                          isCreditedSelected: false,
                        );
                      },
                      backgroundColor:
                      snapshot.isDebited
                          ? AppColors.btncolor
                          : AppColors.primaryColor.withOpacity(0.1),
                      textColor:
                      snapshot.isDebited ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: RoundedEdgedButton(
                      buttonText: 'Credited',
                      fontWeight: FontWeight.w500,
                      height: 44,

                      rightMargin: 12,
                      onButtonClick: () {
                        _myWalletController.updateTab(
                          isPendingSelected: false,
                          isDebitedSelected: false,
                          isCreditedSelected: true,
                        );
                      },
                      backgroundColor:
                      snapshot.isCredited
                          ? AppColors.btncolor
                          : AppColors.primaryColor.withOpacity(0.1),
                      textColor:
                      snapshot.isCredited ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              snapshot.isPending
                  ? PendingWalletWidget()
                  : snapshot.isDebited
                  ? DebitedWalletWidget()
                  : CreditedWalletWidget(),
            ],
          );
        },
      ),
    );
  }
}
