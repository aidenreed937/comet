import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A shimmer loading effect widget for skeleton screens
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    required this.child,
    super.key,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.enabled = true,
  });

  /// The child widget to apply shimmer effect on
  final Widget child;

  /// Base color of the shimmer
  final Color? baseColor;

  /// Highlight color of the shimmer
  final Color? highlightColor;

  /// Duration of one shimmer cycle
  final Duration duration;

  /// Whether shimmer effect is enabled
  final bool enabled;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final isDark = context.isDarkMode;
    final baseColor =
        widget.baseColor ?? (isDark ? AppColors.gray800 : AppColors.gray200);
    final highlightColor =
        widget.highlightColor ??
        (isDark ? AppColors.gray700 : AppColors.gray100);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlidingGradientTransform(
                slidePercent: _animation.value,
              ),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

/// Predefined shimmer skeleton shapes
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key, this.width, this.height, this.borderRadius});

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final color = isDark ? AppColors.gray800 : AppColors.gray200;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? AppSpacing.borderRadiusSm,
      ),
    );
  }
}

/// Circle shaped shimmer placeholder
class ShimmerCircle extends StatelessWidget {
  const ShimmerCircle({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final color = isDark ? AppColors.gray800 : AppColors.gray200;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// A common list item skeleton
class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.titleWidth = 0.6,
    this.subtitleWidth = 0.4,
    this.leadingSize = 48,
  });

  final bool hasLeading;
  final bool hasTrailing;
  final double titleWidth;
  final double subtitleWidth;
  final double leadingSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingMd,
      child: Row(
        children: [
          if (hasLeading) ...[
            ShimmerCircle(size: leadingSize),
            AppSpacing.horizontalGapMd,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
                  widthFactor: titleWidth,
                  child: const ShimmerBox(height: 16),
                ),
                AppSpacing.verticalGapSm,
                FractionallySizedBox(
                  widthFactor: subtitleWidth,
                  child: const ShimmerBox(height: 12),
                ),
              ],
            ),
          ),
          if (hasTrailing) ...[
            AppSpacing.horizontalGapMd,
            const ShimmerBox(width: 24, height: 24),
          ],
        ],
      ),
    );
  }
}

/// A card skeleton
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.height = 120,
    this.hasImage = true,
    this.imageHeight = 80,
  });

  final double height;
  final bool hasImage;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color:
              context.isDarkMode
                  ? AppColors.dark.border
                  : AppColors.light.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage) ...[
            ShimmerBox(
              height: imageHeight,
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            AppSpacing.verticalGapSm,
          ],
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: ShimmerBox(height: 16),
                ),
                SizedBox(height: 8),
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: ShimmerBox(height: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
