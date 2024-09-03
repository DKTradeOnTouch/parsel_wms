enum ImageType { png, lottie }

///On boarding data class
class OnBoardingDataModel {
  ///Constructor On boarding data class

  OnBoardingDataModel(
      {required this.title,
      required this.subTitle,
      required this.image,
      required this.imageType,
      required this.titleImage});

  ///Onboarding title
  final String title;

  ///Onboarding title image
  final String titleImage;

  ///Onboarding sub title
  final String subTitle;

  ///Onboarding image
  final String image;

  ///Onboarding image type
  final ImageType imageType;
}
