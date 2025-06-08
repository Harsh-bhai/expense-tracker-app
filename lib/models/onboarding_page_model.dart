class OnboardingPageModel {
  final String title;
  final String description;
  final String? lottieAsset;
  final String? imageAsset;

  OnboardingPageModel({
    required this.title,
    required this.description,
    this.imageAsset,
    this.lottieAsset,
  });
}
