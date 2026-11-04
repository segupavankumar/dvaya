import 'package:flutter/material.dart';

class Responsive {
  static const double mobileMax = 600;
  static const double tabletMax = 900;
  static const double contentMaxWidth = 480;
  static const double wideContentMaxWidth = 600;

  static bool isWide(BuildContext context) =>
      MediaQuery.of(context).size.width > mobileMax;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > tabletMax;
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

class DesktopAwareCenter extends StatelessWidget {
  final double mobileMaxWidth;
  final double tabletMaxWidth;
  final double desktopMaxWidth;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const DesktopAwareCenter({
    super.key,
    this.mobileMaxWidth = 480,
    this.tabletMaxWidth = 800,
    this.desktopMaxWidth = 1200,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double maxWidth;
    if (width > Responsive.tabletMax) {
      maxWidth = desktopMaxWidth;
    } else if (width > Responsive.mobileMax) {
      maxWidth = tabletMaxWidth;
    } else {
      maxWidth = mobileMaxWidth;
    }
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
