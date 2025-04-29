import 'package:get/get.dart';
import '../models/loan_model.dart';
import '../../../core/network/api_client.dart';

class LoanProvider extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<LoanModel> getLoanDetails(String loanId) async {
    try {
      final response = await _apiClient.get('/loans/$loanId');
      return LoanModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load loan details: $e');
    }
  }

  Future<void> makeRepayment(String loanId, double amount) async {
    try {
      await _apiClient.post('/loans/$loanId/repayment', data: {
        'amount': amount,
      });
    } catch (e) {
      throw Exception('Failed to make repayment: $e');
    }
  }

  Future<void> requestUpdate(String loanId, String updateType) async {
    try {
      await _apiClient.post('/loans/$loanId/updates', data: {
        'type': updateType,
      });
    } catch (e) {
      throw Exception('Failed to request update: $e');
    }
  }
}
