import 'package:flutter/material.dart';
import 'package:instajobs/views/my_wallet/widgets/wallet_widget.dart';

import '../../../controllers/my_wallet/my_wallet_controller.dart';
import 'package:get/get.dart';

import '../../../utils/app_styles.dart';

class DebitedWalletWidget extends StatefulWidget {
  const DebitedWalletWidget({super.key});

  @override
  State<DebitedWalletWidget> createState() => _DebitedWalletWidgetState();
}

class _DebitedWalletWidgetState extends State<DebitedWalletWidget> {
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
        return _myWalletController.debitedWallet == null
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        )
            : _myWalletController.debitedWallet!.isEmpty
            ? Center(
          child: Text('No Debit Wallet', style: AppStyles.font700_16()),
        )
            : Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _myWalletController.debitedWallet?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return WalletWidget(
                title: 'Sent to',
                status:
                _myWalletController.debitedWallet
                    ?.elementAt(index)
                    ?.status ??
                    '',
                dateTime:
                _myWalletController.debitedWallet
                    ?.elementAt(index)
                    ?.created ??
                    0,
                amount:
                _myWalletController.debitedWallet
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
