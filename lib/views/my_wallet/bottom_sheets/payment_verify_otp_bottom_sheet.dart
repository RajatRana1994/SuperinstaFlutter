import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_colors.dart';
import 'package:instajobs/utils/baseClass.dart';

import '../../../controllers/my_wallet/my_wallet_controller.dart';
import '../../../models/payment_response_model.dart';
import '../../../utils/app_styles.dart';
import '../../../widgets/rounded_edged_button.dart';
import 'package:get/get.dart';

class PaymentVerifyOtpBottomSheetWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Function onNextTap;
  final PaymentReponseModelData? paymentResponseModel;
  final String? bookingId;
  final String? offerId;
  final String? offerTime;
  final String? adOns;
  final String? price;

  const PaymentVerifyOtpBottomSheetWidget({
    super.key,
    required this.scrollController,
    required this.onNextTap,
    this.paymentResponseModel,
    this.offerId,
    this.offerTime,
    this.adOns,
    this.price,
    required this.bookingId,
  });

  @override
  State<PaymentVerifyOtpBottomSheetWidget> createState() =>
      _PaymentVerifyOtpBottomSheetWidgetState();
}

class _PaymentVerifyOtpBottomSheetWidgetState
    extends State<PaymentVerifyOtpBottomSheetWidget>
    with BaseClass {
  final MyWalletController _myWalletController = Get.put(MyWalletController());
  final int pinLength = 5;
  final List<FocusNode> _focusNodes = [];
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < pinLength; i++) {
      _focusNodes.add(FocusNode());
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var ctrl in _controllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _handleInput(String value, int index) {
    if (value.isNotEmpty) {
      if (index + 1 < pinLength) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus(); // Last field, dismiss keyboard
      }
    }
  }

  void _handleKey(RawKeyEvent event, int index) {
    if (event.logicalKey.keyLabel == 'Backspace' &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get pin => _controllers.map((controller) => controller.text).join();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(height: 16),
              Text(
                'Submit OTP',
                style: AppStyles.fontInkika().copyWith(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please type the verification code send to\nyour registered email id ',
                style: AppStyles.font400_12().copyWith(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pinLength, (index) {
                    return Flexible(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: RawKeyboardListener(
                          focusNode: FocusNode(), // for backspace support
                          onKey: (event) => _handleKey(event, index),
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 24),
                            decoration: const InputDecoration(
                              counterText: "",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            onChanged: (value) => _handleInput(value, index),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 50),
              RoundedEdgedButton(
                buttonText: 'Submit',
                onButtonClick: () async {
                  if (pin.isEmpty || pin.length < 5) {
                    showError(
                      title: 'Pin',
                      message: 'Please enter correct pin',
                    );
                  } else {
                    try {
                      showGetXCircularDialog();
                      if (widget.bookingId != '') {
                        await _myWalletController.verifyBookingPaymentTransaction(
                          otp: pin,
                          refId: widget.paymentResponseModel?.flwRef ?? '',
                          bookingId: widget.bookingId ?? '',
                        );
                      } else if (widget.offerId != '') {
                        await _myWalletController.buyOfferApi(amount: widget.price ?? '', offerTime: widget.offerTime ?? '', adOns: widget.adOns ?? '', offerId: widget.offerId ?? '');

                        await _myWalletController.verifyOfferPaymentTransaction(
                          otp: pin,
                          refId: widget.paymentResponseModel?.flwRef ?? '',
                          offerId: _myWalletController.purchasedOfferId.toString() ?? '',
                        );

                      } else {
                        await _myWalletController.verifyPaymentTransaction(
                          otp: pin,
                          refId: widget.paymentResponseModel?.flwRef ?? '',
                        );
                      }

                      popToPreviousScreen(context: context);
                      widget.onNextTap();
                      /*pushToNextScreen(
                        context: context,
                        destination: Verification(),
                      );*/
                    } catch (e) {
                      popToPreviousScreen(context: context);
                      showError(title: '', message: e.toString());
                    }
                  }
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
