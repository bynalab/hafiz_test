import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Text text;
  final Widget? icon;
  final double? height;
  final double? width;
  final bool isLoading;
  final Widget? prefixIcon;
  final Function()? onPressed;
  final Decoration? decoration;

  /// This button has a default [height] and [width] of 50 and 400 respectively.
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.icon,
    this.decoration,
    this.isLoading = false,
    this.prefixIcon,
  });

  void handlePress() {
    if (!isLoading) {
      if (onPressed != null) {
        onPressed!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 400,
      height: height ?? 50,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Colors.blueGrey,
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : TextButton(
              onPressed: handlePress,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 5)],
                  FittedBox(child: text),
                ],
              ),
            ),
    );
  }
}
