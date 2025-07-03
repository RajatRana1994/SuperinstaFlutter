import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_colors.dart';
import 'package:instajobs/views/my_wallet/bottom_sheets/payment_verify_otp_bottom_sheet.dart';

import '../../../models/payment_response_model.dart';

class PaymentVerifyOtpBottomSheet {
  static void showPaymentVerifyOtpBottomSheet({
    required BuildContext context,
    required Function onCancel,
    required Function onDone,
    required PaymentReponseModelData? paymentResponseModel
  }) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      backgroundColor: AppColors.bgColor,
      builder: (context) {

        return DraggableScrollableSheet(
          initialChildSize:  0.81,
          minChildSize:  0.7,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: PaymentVerifyOtpBottomSheetWidget(
                  scrollController: scrollController,
                  paymentResponseModel: paymentResponseModel,
                  onNextTap: () {onDone();},
                ),
              ),
            );
          },
        );
      },
    );
  }
}