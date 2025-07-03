import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:instajobs/models/my_wallet_model.dart';
import 'package:instajobs/models/wallet_details_model.dart';
import 'package:instajobs/repositories/my_wallet_repository.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';

import '../../models/payment_response_model.dart';

class MyWalletController extends GetxController {
  bool isPending = true;
  bool isDebited = false;
  bool isCredited = false;

  updateTab({
    required bool isPendingSelected,
    required bool isDebitedSelected,
    required bool isCreditedSelected,
  }) {
    isPending = isPendingSelected;
    isDebited = isDebitedSelected;
    isCredited = isCreditedSelected;
    update();
  }

  final MyWalletRepository _myWalletRepository = MyWalletRepository();
  List<MyWalletModelDataData?>? pendingWallet;
  List<MyWalletModelDataData?>? debitedWallet;
  List<MyWalletModelDataData?>? creditedWallet;
  WalletDetailsModelData? walletDetailsData;
  PaymentReponseModelData? paymentResponseModel;

  Future<void> getWalletDetails() async {
    walletDetailsData = null;
    final response = await _myWalletRepository.getWalletDetails(
      id: StorageService().getUserId(),
    );
    if (response.isSuccess) {
      walletDetailsData = response.data?.data;
    } else {
      throw Exception('Failed to load wallet details');
    }
    update();
  }

  Future<void> linkBankAccount({
    required String accountNumber,
    required String bankName,
  }) async {
    //  paymentResponseModel = null;
    final response = await _myWalletRepository.linkBankAccount(
      accountNumber: accountNumber,
      bankName: bankName,
    );
    if (response.isSuccess) {
      //  paymentResponseModel = response.data?.data;
    } else {
      throw Exception('Failed to link account');
    }
    update();
  }

  Future<void> doPaymentApi({
    required String walletId,
    required String expiryMonth,
    required String cardPin,
    required String amount,
    required String cardCvv,
    required String coinValue,
    required String expiryYear,
    required String cardNumber,
  }) async {
    paymentResponseModel = null;
    final response = await _myWalletRepository.paymentApi(
      walletId: walletId,
      expiryMonth: expiryMonth,
      cardPin: cardPin,
      amount: amount,
      cardCvv: cardCvv,
      coinValue: coinValue,
      expiryYear: expiryYear,
      cardNumber: cardNumber,
    );
    if (response.isSuccess) {
      paymentResponseModel = response.data?.data;
    } else {
      throw Exception('Failed to load wallet details');
    }
    update();
  }

  Future<void> verifyPaymentTransaction({
    required String refId,
    required String otp,
  }) async {
    if (kDebugMode) {
      print(refId);
    }

    //  paymentResponseModel = null;
    final response = await _myWalletRepository.verifyPaymentTransaction(
      refId: refId,
      otp: otp,
    );
    if (response.isSuccess) {
      //  paymentResponseModel = response.data?.data;
    } else {
      throw Exception('Failed to load wallet details');
    }
    update();
  }

  Future<void> getWalletData() async {
    if (isPending) {
      pendingWallet = null;
    } else if (isDebited) {
      debitedWallet = null;
    } else if (isCredited) {
      creditedWallet = null;
    }
    final response = await _myWalletRepository.getWalletApi(
      isPendingSelected: isPending,
      isDebitedSelected: isDebited,
      isCreditedSelected: isCredited,
    );
    if (response.isSuccess) {
      if (isPending) {
        pendingWallet = response.data?.data?.data ?? [];
      } else if (isDebited) {
        debitedWallet = response.data?.data?.data ?? [];
      } else if (isCredited) {
        creditedWallet = response.data?.data?.data ?? [];
      }
    } else {
      if (isPending) {
        pendingWallet = [];
      } else if (isDebited) {
        debitedWallet = [];
      } else if (isCredited) {
        creditedWallet = [];
      }
    }
    update();
  }
}
