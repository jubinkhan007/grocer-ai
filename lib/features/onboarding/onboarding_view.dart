import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'onboarding_controller.dart';
import 'widgets/progress_dots.dart';
import 'widgets/skip_button.dart';

const _topTeal = Color(0xFF0C3E3D);
const _pageBg = Color(0xFFF1F4F6);

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    // teal status bar as in Figma
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        //statusBarColor: _topTeal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top strip (teal) with SKIP
            Container(
              height: 44,
              color: Colors.transparent,
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: SkipButton(),
              ),
            ),
            // Content
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: controller.onChanged,
                itemCount: controller.pages.length,
                itemBuilder: (_, i) => _OnbSlide(page: controller.pages[i]),
              ),
            ),
            // Bottom area with dots + Next
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => ProgressDots(
                      length: controller.pages.length,
                      index: controller.current.value,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: controller.next,
                    icon: Image.asset(
                      'assets/icons/chevron_double_right.png', // use your icon
                      width: 18,
                      height: 18,
                      color: Colors.white,
                    ),
                    label: const Text('Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnbSlide extends StatelessWidget {
  final OnbPage page;
  const _OnbSlide({required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, c) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: c.maxHeight - 24),
              child: Column(
                children: [
                  // Big illustration on curved pale circle background (as in Figma)
                  const SizedBox(height: 24),
                  AspectRatio(
                    aspectRatio: 1, // tall illustration area
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // big pale circle “arc”
                        Positioned(
                          bottom: 0,
                          left: -60,
                          right: -60,
                          child: Container(
                            height: 220,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.55),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(300),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Image.asset(page.image, fit: BoxFit.contain),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    page.subtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
