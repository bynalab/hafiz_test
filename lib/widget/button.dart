import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white.withOpacity(0.4),
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

class GradientBorderButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback? onTap;

  const GradientBorderButton({
    super.key,
    required this.text,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFF5BE),
              Color(0xFFD0F7EA),
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 5),
              ],
              Text(
                text,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF004B40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
