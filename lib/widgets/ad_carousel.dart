import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../theme/app_theme.dart';

class AdCarousel extends StatefulWidget {
  final List<String> banners;

  const AdCarousel({super.key, required this.banners});

  @override
  State<AdCarousel> createState() => _AdCarouselState();
}

class _AdCarouselState extends State<AdCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 100,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            viewportFraction: 0.92,
            onPageChanged: (i, _) => setState(() => _current = i),
          ),
          items: widget.banners.map((banner) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent.withValues(alpha: 0.2), AppColors.surfaceElevated],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 0.5),
            ),
            child: Center(
              child: Text(
                banner,
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 10),
        AnimatedSmoothIndicator(
          activeIndex: _current,
          count: widget.banners.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppColors.accent,
            dotColor: AppColors.textTertiary.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }
}
