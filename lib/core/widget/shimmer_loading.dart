import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ويدجت أساسي لتأثير التحميل
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

// ويدجت مخصص لعرض حاوية تحميل (مثل صورة أو أيقونة)
class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerContainer({
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
