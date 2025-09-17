import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/utils/app_colors.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/welcome_page.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HowItWorksPage extends StatefulWidget {
  const HowItWorksPage({super.key});

  @override
  State<HowItWorksPage> createState() => _HowItWorksPageState();
}

class _HowItWorksPageState extends State<HowItWorksPage> with BaseClass{
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/screenone.jpeg",
      "title": "Welcome to SuperInstaJobs!",
      "text":
      "*\"Your All-in-One Handyman Solution!\"*  \n\n"
          "Find skilled professionals or post your own handyman jobs in seconds." +
          " Whether it’s fixing a leak, assembling furniture, or renovating your space, " +
          "we’ve got you covered. Tap into a marketplace of trusted experts ready to help!\n\n" +
          "Get started today and make your to-do list disappear!",
    },
    {
      "image": "assets/images/screentwo.jpeg",
      "title": "Explore the Business Directory",
      "text":
      "*\"Connect with Local Pros in Your Area!\"*  \n\n" +
          "Discover a curated directory of businesses and independent contractors near you. " +
          "From plumbers to electricians, painters to landscapers, find the perfect match for your project. " +
          "Read reviews, compare prices, and book directly through the app.\n\n" +
          "Your next great service is just a tap away!",
    },
    {
      "image": "assets/images/screenthree.jpeg",
      "title": "Stay Inspired with Our Feed",
      "text":
      "*\"Get Inspired, Share Your Projects!\"*  \n\n" +
          "Scroll through our Instagram-style feed to see before-and-after transformations, " +
          "DIY tips, and success stories from our community. Share your own projects, connect with others," +
          " and get ideas for your next home improvement adventure.\n\n" +
          "Join the community and turn your ideas into reality!",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),

                      child: Image.asset(
                        onboardingData[index]["image"]!,
                        height: Get.height * 0.45,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        onboardingData[index]["title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        onboardingData[index]["text"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: RoundedEdgedButton(
                        onButtonClick: () {
                          pushReplaceAndClearStack(context: context, destination: WelcomePage());
                          // Navigate or perform action
                        },
                        borderRadius: 40,
                        leftMargin: 70,
                        rightMargin: 70,
                        height: 40,
                        buttonText: 'Get Started',
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SmoothPageIndicator(
            controller: _controller,
            count: onboardingData.length,
            effect: WormEffect(
              activeDotColor: AppColors.primaryColor,
              dotHeight: 10,
              dotWidth: 10,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
