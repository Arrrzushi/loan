import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  bool get isLastPage => selectedPageIndex.value == onboardingPages.length - 1;
  var pageController = PageController();

  final List<OnboardingPageData> onboardingPages = [
    OnboardingPageData(
      title: "Quick Loans",
      description: "Get instant loans with minimal documentation",
      imageAsset: "assets/images/onboarding_1.svg",
    ),
    OnboardingPageData(
      title: "Low Interest Rates",
      description: "Enjoy competitive interest rates on all our loan products",
      imageAsset: "assets/images/onboarding_2.svg",
    ),
    OnboardingPageData(
      title: "Easy Repayment",
      description: "Flexible repayment options that fit your budget",
      imageAsset: "assets/images/onboarding_3.svg",
    ),
  ];

  void nextPage() {
    if (isLastPage) {
      completeOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void skipToLastPage() {
    pageController.animateToPage(
      onboardingPages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void updatePageIndex(int index) {
    selectedPageIndex.value = index;
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    await prefs.setBool('isFirstRun', false);

    // Make sure we specifically navigate to the login route
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingPageData {
  final String title;
  final String description;
  final String imageAsset;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.imageAsset,
  });
}
