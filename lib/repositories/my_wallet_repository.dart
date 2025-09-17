import 'package:instajobs/models/forgot_pass.dart';
import 'package:instajobs/models/link_bank_account_model.dart';
import 'package:instajobs/models/my_wallet_model.dart';
import 'package:instajobs/models/payment_response_model.dart';
import 'package:instajobs/models/payment_verification_model.dart';
import 'package:instajobs/models/wallet_details_model.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';

import '../network/network_service.dart';

class MyWalletRepository {
  final NetworkService _networkService = NetworkService();

  Future<ApiResponse<MyWalletModel>> getWalletApi({
    required bool isPendingSelected,
    required bool isDebitedSelected,
    required bool isCreditedSelected,
  }) async {
    late String url;
    if (isPendingSelected) {
      url = 'get-transaction?type=debit&status=pending';
    } else if (isDebitedSelected) {
      url = 'get-transaction?type=debit&status=successful';
    } else if (isCreditedSelected) {
      url = 'get-transaction?type=credit&status=successful';
    }
    return await _networkService.get<MyWalletModel>(
      path: url,
      converter: (data) {
        // The converter is only called for successful responses now
        return MyWalletModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<WalletDetailsModel>> getWalletDetails({
    required String id,
  }) async {
    return await _networkService.get<WalletDetailsModel>(
      path: 'get-wallet/$id',
      converter: (data) {
        // The converter is only called for successful responses now
        return WalletDetailsModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<PaymentVerificationResponseModel>>
  verifyPaymentTransaction({required String refId, required String otp}) async {
    return await _networkService.post<PaymentVerificationResponseModel>(
      path: 'verifyTransaction',
      data: {'flw_ref': refId, 'otp': otp},
      converter: (data) {
        // The converter is only called for successful responses now
        return PaymentVerificationResponseModel.fromJson(data);
      },
    );
  }


  Future<ApiResponse<PaymentVerificationResponseModel>>
  verifyBookingPaymentTransaction({required String refId, required String otp, required String bookid}) async {
    return await _networkService.put<PaymentVerificationResponseModel>(
      path: 'booking-payment/verify/$bookid',
      data: {'flw_ref': refId, 'otp': otp},
      converter: (data) {
        // The converter is only called for successful responses now
        return PaymentVerificationResponseModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<PaymentVerificationResponseModel>>
  verifyOfferPaymentTransaction({required String refId, required String otp, required String bookid}) async {
    return await _networkService.put<PaymentVerificationResponseModel>(
      path: 'offer-payment/verify/$bookid',
      data: {'flw_ref': refId, 'otp': otp},
      converter: (data) {
        // The converter is only called for successful responses now
        return PaymentVerificationResponseModel.fromJson(data);
      },
    );
  }


  Future<ApiResponse<OfferPurchaseResponse>>
  buyOfferApi({required String amount, required String offerTime, required String adOns, required String offerId}) async {
    return await _networkService.post<OfferPurchaseResponse>(
      path: 'offer/purchase/$offerId',
      data: {'amount': amount, 'offerTime': offerTime, "adOns": adOns},
      converter: (data) {
        // The converter is only called for successful responses now
        return OfferPurchaseResponse.fromJson(data);
      },
    );
  }

  Future<ApiResponse<LinkBankAccountModel>> linkBankAccount({
    required String accountNumber,
    required String bankName,
  }) async {
    return await _networkService.post<LinkBankAccountModel>(
      path: 'link-bank-account',
      data: {
        'userId': StorageService().getUserId(),
        'account_bank': bankName,
        'account_number': accountNumber,
      },
      converter: (data) {
        // The converter is only called for successful responses now
        return LinkBankAccountModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<PaymentReponseModel>> paymentApi({
    required String walletId,
    required String expiryMonth,
    required String cardPin,
    required String amount,
    required String cardCvv,
    required String coinValue,
    required String expiryYear,
    required String cardNumber,
  }) async {
    return await _networkService.post<PaymentReponseModel>(
      path: 'initiatePayment',
      data: {
        'walletId': walletId,
        'expiry_month': expiryMonth,
        'card_pin': cardPin,
        'amount': amount,
        'card_cvv': cardCvv,
        'card_number': cardNumber,
        'coinValue': coinValue,
        'userId': StorageService().getUserId(),
        'expiry_year': expiryYear,
      },
      converter: (data) {
        // The converter is only called for successful responses now
        return PaymentReponseModel.fromJson(data);
      },
    );
  }

  Future<ApiResponse<PaymentReponseModel>> bookingpaymentApi({
    required String expiryMonth,
    required String cardPin,
    required String amount,
    required String cardCvv,
    required String expiryYear,
    required String cardNumber,
  }) async {
    return await _networkService.post<PaymentReponseModel>(
      path: 'card-payment',
      data: {
        'expiry_month': expiryMonth,
        'card_pin': cardPin,
        'amount': amount,
        'card_cvv': cardCvv,
        'card_number': cardNumber,
        'expiry_year': expiryYear,
      },
      converter: (data) {
        // The converter is only called for successful responses now
        return PaymentReponseModel.fromJson(data);
      },
    );
  }
}
