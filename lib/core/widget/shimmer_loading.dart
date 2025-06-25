// lib/core/widget/shimmer_loading.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// هذا هو الويدجت الرئيسي لتأثير Shimmer
class ShimmerLoading extends StatelessWidget {
  final Widget child;

  const ShimmerLoading({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }
}

// --- الويدجت المساعد الجديد ---
// سنستخدمه لبناء الصناديق الرمادية في واجهة التحميل
class ShimmerContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final ShapeBorder shapeBorder;

  const ShimmerContainer({
    super.key,
    this.width,
    this.height,
    this.shapeBorder = const RoundedRectangleBorder(),
    int borderRadius = 24,
  });

  const ShimmerContainer.circular({super.key, required double size})
    : width = size,
      height = size,
      shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(color: Colors.grey[300]!, shape: shapeBorder),
    );
  }
}
