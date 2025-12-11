import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height = 48,
  });

  factory PrimaryButton.text({
    required VoidCallback? onPressed,
    required String text,
    Key? key,
    bool isLoading = false,
    bool isEnabled = true,
    double? width,
    double height = 48,
  }) {
    return PrimaryButton(
      key: key,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      width: width,
      height: height,
      child: Text(text),
    );
  }

  factory PrimaryButton.icon({
    required VoidCallback? onPressed,
    required IconData icon,
    required String text,
    Key? key,
    bool isLoading = false,
    bool isEnabled = true,
    double? width,
    double height = 48,
  }) {
    return PrimaryButton(
      key: key,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      width: width,
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(text)],
      ),
    );
  }

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        child:
            isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
                : child,
      ),
    );
  }
}
