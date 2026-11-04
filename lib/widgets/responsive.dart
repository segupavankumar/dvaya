import 'package:flutter/material.dart';

class Responsive {
  static const double mobileMax = 600;
  static const double tabletMax = 900;
  static const double contentMaxWidth = 480;
  static const double wideContentMaxWidth = 600;

  static bool isWide(BuildContext context) =>
      MediaQuery.of(context).size.width > mobileMax;
}

class ResponsiveCenter extends StatelessWidget {
  final double maxWidth;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ResponsiveCenter({
    super.key,
    this.maxWidth = 480,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}

int responsiveGridCount(BuildContext context, {int mobile = 2, int tablet = 3, int desktop = 4}) {
  final width = MediaQuery.of(context).size.width;
  if (width > 900) return desktop;
  if (width > 600) return tablet;
  return mobile;
}
