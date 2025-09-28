import 'package:flutter/material.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/my_wallet/pay_coins_page.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class BuyCoinsPage extends StatefulWidget {
  final String walletId;
  const BuyCoinsPage({super.key, required this.walletId});

  @override
  State<BuyCoinsPage> createState() => _BuyCoinsPageState();
}

class _BuyCoinsPageState extends State<BuyCoinsPage> with BaseClass {
  final List<int> values = const [5000, 10000, 15000, 20000, 25000, 30000];
  TextEditingController coinsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Buy Coins',
          style: AppStyles.fontInkika().copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          //  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          width: double.infinity,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16), // inner padding if needed
            color: Colors.orange.withOpacity(0.15),
            child: Column(
              children: [
                // SizedBox(height: 20),
                FormInputWithHint(
                  label: 'Coins',
                  hintText: 'Min 100',
                  controller: coinsController,
                  isDigitsOnly: true,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: values.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    // ← 3 columns
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                    mainAxisExtent: 40, // square tiles
                  ),
                  itemBuilder: (context, index) {
                    final value = values[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        // TODO: replace with real action
                        coinsController.text = value.toString();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.green.withOpacity(0.2), // green background
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$value',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  '1 Naria ₦ = 1000 Coin',
                  style: AppStyles.font500_14().copyWith(color: Colors.black),
                ),
                SizedBox(height: 20),
                RoundedEdgedButton(
                  buttonText: 'Buy',
                  height: 44,
                  onButtonClick: () {
                    String coins = coinsController.text.trim();
                    if (coins.isEmpty || int.tryParse(coins) == null) {
                      showError(title: 'Coins', message: 'Please add coins');
                    } else if (int.parse(coins) < 100) {
                      showError(
                        title: 'Coins',
                        message: 'Coins should be more than 100',
                      );
                    } else {
                      pushToNextScreen(
                        context: context,
                        destination: PayCoinsPage(
                          coins: coins,
                          walletId: widget.walletId,
                          bookId: '',
                        ),
                      );
                    }
                  },
                  leftMargin: 60,
                  rightMargin: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
