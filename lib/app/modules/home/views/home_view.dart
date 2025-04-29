import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/loan_model.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  Widget _buildIconTextButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.black, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String rightTitle,
    required String rightSubtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              rightTitle,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            Text(
              rightSubtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPortfolioCard(LoanModel? loan, bool isUserId) {
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      locale: 'en_IN',
      decimalDigits: 0,
    );

    String title = isUserId
        ? 'User ID: ${loan?.userId ?? 'N/A'}'
        : 'Loan ID: ${loan?.id ?? 'N/A'}';
    String bottomRight = isUserId
        ? currencyFormat.format(loan?.remainingAmount ?? 0)
        : currencyFormat.format(loan?.amount ?? 0);

    // Use local chart images or network images
    String imageUrl = isUserId
        ? 'https://storage.googleapis.com/a1aa/image/d040aa0c-7c1d-4ed5-43f6-dffc4a6c96b3.jpg'
        : 'https://storage.googleapis.com/a1aa/image/4743567f-712f-4ed3-4241-19ad08109554.jpg';

    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Image.network(
            imageUrl,
            height: 56,
            width: double.infinity,
            fit: BoxFit.contain,
            semanticLabel: 'Chart visualization',
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 56,
                color: Colors.grey[800],
                child: const Center(
                  child: Icon(Icons.error_outline, color: Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.lock, color: Colors.white, size: 12),
              Text(
                bottomRight,
                style: const TextStyle(color: Colors.white, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepaymentCard(LoanModel? loan, bool isAgreement) {
    String title = isAgreement ? 'Loan Agreement' : 'Loan Tracker';
    String subtitle = isAgreement ? 'by Legal Team' : 'by Loan Manager';
    String altText =
        isAgreement ? 'Loan Agreement document' : 'Loan Tracker smartphone';

    String imageUrl = isAgreement
        ? 'https://storage.googleapis.com/a1aa/image/4af0af69-b8e8-41a6-74e6-30ae2ff37389.jpg'
        : 'https://storage.googleapis.com/a1aa/image/097e1500-5538-49d2-4072-474bd5c90f20.jpg';

    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 96,
              width: double.infinity,
              fit: BoxFit.cover,
              semanticLabel: altText,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: 96,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 96,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.error_outline),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 9, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              : Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header black top
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top row with avatar and wallet icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: NetworkImage(
                                        'https://storage.googleapis.com/a1aa/image/7322811a-271d-4b00-a342-f229043c489f.jpg',
                                      ),
                                      child: controller.userName.isEmpty
                                          ? const Icon(Icons.person,
                                              color: Colors.grey)
                                          : null,
                                    )),
                                IconButton(
                                  icon: const Icon(Icons.account_balance_wallet,
                                      color: Colors.white),
                                  onPressed: () {},
                                  tooltip: 'Wallet',
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Loan Overview',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: const [
                                      Text(
                                        'Add',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.arrow_upward,
                                          size: 14, color: Colors.white),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Interest Rate Details',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Tracking buttons
                            Row(
                              children: [
                                _buildTrackingButton('Track'),
                                const SizedBox(width: 8),
                                _buildTrackingButton('Top Repayments'),
                                const SizedBox(width: 8),
                                _buildTrackingButton('Overdue'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Loan Status Overview white background
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  _buildStatusItem(
                                    icon: Icons.lock,
                                    title: 'Personal Loan',
                                    subtitle: 'PL',
                                    rightTitle: 'Late Fee',
                                    rightSubtitle: 'Amount Paid',
                                  ),
                                  const SizedBox(height: 12),
                                  _buildStatusItem(
                                    icon: Icons.business,
                                    title: 'Business Loan',
                                    subtitle: 'BL',
                                    rightTitle: 'Repayment',
                                    rightSubtitle: 'Remaining Amount',
                                  ),
                                  const SizedBox(height: 12),
                                  _buildStatusItem(
                                    icon: Icons.home,
                                    title: 'Mortgage Loan',
                                    subtitle: 'ML',
                                    rightTitle: 'Interest Rate',
                                    rightSubtitle: 'Loan Balance',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Buttons row
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        color: const Color(0xFFF0F2F5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildIconTextButton(Icons.add, 'Add'),
                            _buildIconTextButton(Icons.remove, 'Repay'),
                            _buildIconTextButton(Icons.send, 'Send'),
                            _buildIconTextButton(
                                Icons.arrow_downward, 'Receive'),
                          ],
                        ),
                      ),
                      // My Loans Portfolio
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and view all
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'My Loans Portfolio',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('View all',
                                        style: TextStyle(fontSize: 10)),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(40, 20),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildPortfolioCard(
                                    controller.hasActiveLoans()
                                        ? controller.getNextPaymentLoan()
                                        : null,
                                    false,
                                  ),
                                  _buildPortfolioCard(
                                    controller.hasActiveLoans()
                                        ? controller.getNextPaymentLoan()
                                        : null,
                                    true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // My Loan Repayments
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'My Loan Repayments',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('View all',
                                        style: TextStyle(fontSize: 10)),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(40, 20),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildRepaymentCard(
                                    controller.hasActiveLoans()
                                        ? controller.getNextPaymentLoan()
                                        : null,
                                    true,
                                  ),
                                  _buildRepaymentCard(
                                    controller.hasActiveLoans()
                                        ? controller.getNextPaymentLoan()
                                        : null,
                                    false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Bottom nav
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(24)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.home, color: Colors.black),
                              onPressed: () {},
                              tooltip: 'Home',
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.search, color: Colors.grey),
                              onPressed: () {},
                              tooltip: 'Search',
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings,
                                  color: Colors.grey),
                              onPressed: controller.signOut,
                              tooltip: 'Settings',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
