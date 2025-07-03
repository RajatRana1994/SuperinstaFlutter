import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/views/my_wallet/widgets/wallet_widget.dart';

import '../../../controllers/my_wallet/my_wallet_controller.dart';
import 'package:get/get.dart';

class CreditedWalletWidget extends StatefulWidget {
  const CreditedWalletWidget({super.key});

  @override
  State<CreditedWalletWidget> createState() => _CreditedWalletWidgetState();
}

class _CreditedWalletWidgetState extends State<CreditedWalletWidget> {
  final MyWalletController _myWalletController = Get.put(MyWalletController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myWalletController.getWalletData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyWalletController>(
      init: _myWalletController,
      builder: (snapshot) {
        return _myWalletController.creditedWallet == null
            ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            )
            : _myWalletController.creditedWallet!.isEmpty
            ? Center(
              child: Text('No Credited Wallet', style: AppStyles.font700_16()),
            )
            : Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                shrinkWrap: true,
                itemCount: _myWalletController.creditedWallet?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return WalletWidget(
                    title: '',
                    status:
                        _myWalletController.creditedWallet
                            ?.elementAt(index)
                            ?.status ??
                        '',
                    dateTime:
                        _myWalletController.creditedWallet
                            ?.elementAt(index)
                            ?.created ??
                        0,
                    amount:
                        _myWalletController.creditedWallet
                            ?.elementAt(index)
                            ?.amount
                            .toString() ??
                        '0',
                  );
                },
              ),
            );
      },
    );
  }
}
