import 'package:flutter/material.dart';
import 'package:instajobs/views/my_wallet/widgets/wallet_widget.dart';

import '../../../controllers/my_wallet/my_wallet_controller.dart';
import 'package:get/get.dart';

import '../../../utils/app_styles.dart';

class PendingWalletWidget extends StatefulWidget {
  const PendingWalletWidget({super.key});

  @override
  State<PendingWalletWidget> createState() => _PendingWalletWidgetState();
}

class _PendingWalletWidgetState extends State<PendingWalletWidget> {
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
        return _myWalletController.pendingWallet == null
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        )
            : _myWalletController.pendingWallet!.isEmpty
            ? Center(
          child: Text('No Pending Wallet', style: AppStyles.font700_16()),
        )
            : Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            itemCount: _myWalletController.pendingWallet?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return WalletWidget(
                title: 'Sent to',
                status:
                _myWalletController.pendingWallet
                    ?.elementAt(index)
                    ?.status ??
                    '',
                dateTime:
                _myWalletController.pendingWallet
                    ?.elementAt(index)
                    ?.created ??
                    0,
                amount:
                _myWalletController.pendingWallet
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
