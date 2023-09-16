import 'package:flutter/material.dart';

enum IconPosition { left, right }

class CustomButton extends StatelessWidget {
  final Text text;
  final Widget? icon;
  final double? height;
  final double? width;
  final bool isLoading;
  final Widget? prefixIcon;
  final IconPosition iconPosition;
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
    this.iconPosition = IconPosition.left,
    this.decoration,
    this.isLoading = false,
    this.prefixIcon,
  });

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
              onPressed: () {
                if (!isLoading && onPressed != null) {
                  onPressed?.call();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null && iconPosition == IconPosition.left) ...[
                    icon!,
                    const SizedBox(width: 5)
                  ],
                  FittedBox(child: text),
                  if (icon != null && iconPosition == IconPosition.right) ...[
                    const SizedBox(width: 5),
                    icon!
                  ],
                ],
              ),
            ),
    );
  }
}
