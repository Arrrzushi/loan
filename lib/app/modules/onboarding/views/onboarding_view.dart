import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content with PageView
            PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndex,
              itemCount: controller.onboardingPages.length,
              itemBuilder: (context, index) {
                return OnboardingPage(
                  page: controller.onboardingPages[index],
                );
              },
            ),

            // Skip button
            Positioned(
              top: 20,
              right: 20,
              child: Obx(() => controller.isLastPage
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: controller.skipToLastPage,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFFFF7E1D),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    )),
            ),

            // Bottom navigation
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dot indicators
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.onboardingPages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: controller.selectedPageIndex.value == index
                                  ? 20
                                  : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color:
                                    controller.selectedPageIndex.value == index
                                        ? const Color(0xFFFF7E1D)
                                        : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(height: 40),

                    // Next/Get Started button
                    Obx(() => SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: controller.nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7E1D),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              controller.isLastPage ? 'Get Started' : 'Next',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData page;

  const OnboardingPage({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App logo at the top
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFF7E1D),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'LB',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'LoanBee',
            style: TextStyle(
              color: Color(0xFFFF7E1D),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),

          // Image
          Expanded(
            flex: 3,
            child: SvgPicture.asset(
              page.imageAsset,
              height: 240,
            ),
          ),

          // Text content
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  page.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  page.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
