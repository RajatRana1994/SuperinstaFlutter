import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../../controllers/my_wallet/my_wallet_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'package:get/get.dart';

import 'bottom_sheets/payment_verify_otp.dart';

class PayCoinsPage extends StatefulWidget {
  final String coins;
  final String bookId;
  final String walletId;
  final String? offerId;
  final String? offerTime;
  final String? adOns;

  const PayCoinsPage({
    super.key,
    required this.coins,
    required this.walletId,
    required this.bookId,
    this.offerId,
    this.offerTime,
    this.adOns
  });

  @override
  State<PayCoinsPage> createState() => _PayCoinsPageState();
}

class _PayCoinsPageState extends State<PayCoinsPage> with BaseClass {
  final _cardCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _verifyCoupon = TextEditingController();
  final MyWalletController _myWalletController = Get.put(MyWalletController());

  @override
  void dispose() {
    _cardCtrl.dispose();
    _expCtrl.dispose();
    _cvvCtrl.dispose();
    _pinCtrl.dispose();
    _verifyCoupon.dispose();
    super.dispose();
  }

  /// ─── quick & dirty validation ──────────────────────────────────────────
  bool _allValid() {
    final card = _cardCtrl.text.replaceAll('-', '');
    final exp = _expCtrl.text;
    final cvv = _cvvCtrl.text;
    final pin = _pinCtrl.text;

    final expOk = RegExp(r'^\d{2}/\d{2}$').hasMatch(exp);
    return card.length == 16 && expOk && cvv.length == 3 && pin.length == 4;
  }

  ({String monthStr, String yearStr, int month, int year}) parseExpiry(
      String raw,
      ) {
    // Expecting "MM/YY"
    final parts = raw.split('/');
    if (parts.length != 2) {
      throw FormatException('Expiry must be MM/YY');
    }

    // ― Strings with leading zeros kept intact ―
    final String monthStr = parts[0].padLeft(2, '0'); // "05"
    final String yearStr = parts[1].padLeft(2, '0'); // "28"

    // ― Numeric versions if you want them ―
    final int month = int.parse(monthStr); // 5
    final int year = 2000 + int.parse(yearStr); // 2028 (prepend century)

    return (monthStr: monthStr, yearStr: yearStr, month: month, year: year);
  }

  void _onPay() async {
    if (!_allValid()) {
      // TODO: send data to backend

      showError(
        title: 'Card Details',
        message: 'Please fill in all card details correctly.',
      );
    } else if (!_accepted) {
      showError(
        title: 'Terms and Conditions',
        message: 'Please accept the terms and conditions to proceed.',
      );
    } else {
      final String raw = _expCtrl.text;

      final parts = parseExpiry(raw);
      String month = parts.monthStr;
      String year = parts.yearStr;
      try {
        showGetXCircularDialog();
        if (widget.bookId != '') {
          print('one');
          await _myWalletController.doBookingPaymentApi(
            expiryMonth: month.toString(),
            cardPin: _pinCtrl.text.trim(),
            amount: (int.parse(widget.coins)).toString(),
            cardCvv: _cvvCtrl.text.trim(),
            expiryYear: year.toString(),
            cardNumber: _cardCtrl.text.trim().replaceAll('-', ''),
          );
        } else if ((widget.offerId ?? '') != '') {


          print('Check this open');
          await _myWalletController.doBookingPaymentApi(
            expiryMonth: month.toString(),
            cardPin: _pinCtrl.text.trim(),
            amount: (int.parse(widget.coins)).toString(),
            cardCvv: _cvvCtrl.text.trim(),
            expiryYear: year.toString(),
            cardNumber: _cardCtrl.text.trim().replaceAll('-', ''),
          );
        } else {
          print('three');
          await _myWalletController.doPaymentApi(
            walletId: widget.walletId,
            expiryMonth: month.toString(),
            cardPin: _pinCtrl.text.trim(),
            amount: (int.parse(widget.coins) / 1000).toString(),
            cardCvv: _cvvCtrl.text.trim(),
            coinValue: widget.coins,
            expiryYear: year.toString(),
            cardNumber: _cardCtrl.text.trim().replaceAll('-', ''),
          );
        }

        popToPreviousScreen(context: context);
        PaymentVerifyOtpBottomSheet.showPaymentVerifyOtpBottomSheet(
          context: context,
          paymentResponseModel: _myWalletController.paymentResponseModel,
          bookingId: widget.bookId ?? '',
          offerTime: widget.offerTime ?? '',
          offerId: widget.offerId ?? '',
          adOns: widget.adOns ?? '',
          amount: widget.coins ?? '',
          onCancel: () {},
          onDone: () {
            popToPreviousScreen(context: context);
            _showPaymentSuccessDialog(context);
          },
        );
      } catch (e) {
        showError(title: 'Payment', message: e.toString());
      }
    }
  }

  bool _accepted = false;

  /// Call this anywhere   →   _showPaymentSuccessDialog(context);
  Future<void> _showPaymentSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // ⟵ no tap-outside dismissal
      builder:
          (context) => WillPopScope(
        // ⟵ blocks Android back button
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Payment Success\nThank you on your payment submission',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'The receipt will now be reviewed by admin for approval.\n'
                'Please give admin 2–6 hours to review payments.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            RoundedEdgedButton(
              buttonText: 'Great',
              leftMargin: 30,
              rightMargin: 30,
              onButtonClick: () {
                _myWalletController.getWalletDetails();
                Get.back();
                Get.back();
                Get.back();
              },
            ),
            /*ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(90, 40),
              ),
              onPressed: () {
                _myWalletController.getWalletDetails();
              Get.back();
              Get.back();
              Get.back();
              },

              child: const Text('Great'),
            ),*/
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder kBlackBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.black),
    );
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Pay now . ${widget.coins}',
          style: AppStyles.font700_20().copyWith(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.walletId != "") ... [
              Text(
                'Do you have any coupon to use',
                style: AppStyles.font700_16().copyWith(color: Colors.black),
              ),
              SizedBox(height: 20),
              FormInputWithHint(
                label: 'Coupon Code',
                hintText: 'Enter coupon code',
                controller: _verifyCoupon,
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    if (_verifyCoupon.text.trim().isEmpty) {
                      showError(
                        title: 'Coupon',
                        message: 'Please add coupon code',
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      'Verify Coupon',
                      style: AppStyles.font500_16().copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Pay amount after converting coins into Naira ₦ ${int.parse(widget.coins) / 1000}',
                style: AppStyles.font700_16().copyWith(color: Colors.green),
              ),
            ],


            RadioListTile<bool>(
              value: true,
              // this tile’s value
              groupValue: true,
              // same value ⇒ always selected
              onChanged: (_) {},
              // enabled; do nothing on tap
              activeColor: Colors.orange,
              // << selected dot turns orange
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Debit card / Credit Card',
                style: AppStyles.font500_16().copyWith(color: Colors.black),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _cardCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      MaskedInputFormatter('0000-0000-0000-0000'),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      hintText: '0000-0000-0000-0000',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)), // default color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)), // focus color
                      ),
                      errorBorder: kBlackBorder,
                      focusedErrorBorder: kBlackBorder,

                      filled: true, // enables background
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Expiry + CVV in one row ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            CreditCardExpirationDateFormatter(),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Expiry (MM/YY)',
                            hintText: 'MM/YY',
                            labelStyle: const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black.withOpacity(0.2)), // default color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black.withOpacity(0.2)), // focus color
                            ),
                            errorBorder: kBlackBorder,
                            focusedErrorBorder: kBlackBorder,

                            filled: true, // enables background
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _cvvCtrl,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            hintText: '123',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black.withOpacity(0.2)), // default color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black.withOpacity(0.2)), // focus color
                            ),
                            errorBorder: kBlackBorder,
                            focusedErrorBorder: kBlackBorder,

                            filled: true, // enables background
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Card PIN ─────────────────────────────────────────────────
                  TextField(
                    controller: _pinCtrl,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Card PIN',
                      hintText: '1234',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)), // default color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)), // focus color
                      ),
                      errorBorder: kBlackBorder,
                      focusedErrorBorder: kBlackBorder,

                      filled: true, // enables background
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                // ── Checkbox ───────────────────────────────────────────────
                Checkbox(
                  value: _accepted,
                  activeColor: Colors.deepOrange, // orange when checked
                  onChanged: (val) => setState(() => _accepted = val ?? false),
                ),

                // ── Rich label (tap toggles, too) ─────────────────────────
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _accepted = !_accepted),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                        children: const [
                          TextSpan(text: 'I accept '),
                          TextSpan(
                            text: 'Terms and conditions',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            RoundedEdgedButton(
              buttonText: 'Pay Securely',
              onButtonClick: () {
                _onPay();
              },
            ),
          ],
        ),
      ),
    );
  }
}
