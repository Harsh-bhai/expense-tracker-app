import 'package:expense_tracker/models/onboarding_page_model.dart';
import 'package:expense_tracker/provider/bank_notifier.dart';
import 'package:expense_tracker/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;
  bool smsReqPage = false;
  bool notificationReqPage = false; // NEW FLAG
  

  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      imageAsset: 'assets/images/logo.png',
      lottieAsset: "assets/lottie/gear.json",
      title: 'Track Expenses Automatically',
      description:
          'Skip the manual entry! We read your transaction SMS securely and auto-create draft expenses, so you never miss a spend.',
    ),
    OnboardingPageModel(
      imageAsset: 'assets/images/logo.png',
      lottieAsset: "assets/lottie/read.json",
      title: 'Read Only What Matters',
      description:
          'We only read transactional messages—nothing personal. This helps create draft expenses quickly and privately.',
    ),
    OnboardingPageModel(
      imageAsset: 'assets/images/logo.png',
      lottieAsset: "assets/lottie/analysis.json",
      title: 'Customize Your Spending',
      description:
          'Assign categories to expenses, so you can organize your finances your way. Set Budget Limits for each category.',
    ),
    OnboardingPageModel(
      imageAsset: 'assets/images/logo.png',
      lottieAsset: "assets/lottie/bank.json",
      title: 'Select Your Bank',
      description: 'Select a bank to get started.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == pages.length - 1;
                    smsReqPage = index == 1;
                    notificationReqPage = index == 2; // PAGE 3
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      page.lottieAsset != null
                          ? SizedBox(
                              height: 250,
                              child: Lottie.asset(page.lottieAsset ?? ''),
                            )
                          : Image.asset(page.imageAsset ?? '', height: 250),
                      const SizedBox(height: 40),
                      Text(
                        page.title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      Text(page.description, textAlign: TextAlign.center),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            SmoothPageIndicator(
              controller: _controller,
              count: pages.length,
              effect: const WormEffect(dotHeight: 10, dotWidth: 10),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // last page
                if (isLastPage) {
                  await Provider.of<BankNotifier>(context, listen: false)
                      .showBankSelectionDialog(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LandingPage()),
                  );
                }

                // sms page
                else if (smsReqPage) {
                  PermissionStatus status = await Permission.sms.status;

                  while (!status.isGranted) {
                    status = await Permission.sms.request();

                    if (status.isGranted) {
                      break;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Please grant SMS permission to continue."),
                      ),
                    );

                    if (status.isPermanentlyDenied) {
                      openAppSettings();
                      return;
                    }
                  }

                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }

                // notification page
                else if (notificationReqPage) {
                  final status = await Permission.notification.request();

                  if (status.isGranted) {
                    // Proceed to next page if granted
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Notification permission denied. You can enable it later in settings."),
                      ),
                    );

                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                }
                 else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: Text(isLastPage ? 'Get Started' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }
}
