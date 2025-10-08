import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double height;
  final bool disabled;
  final bool isLoading;
  final Color? color;
  final Color? highlightColor;
  final Color? splashColor;
  final Gradient? gradient;
  final BorderRadius radius;
  final VoidCallback? onPressed;
  final BoxBorder border;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const Button({
    super.key,
    required this.child,
    this.width,
    this.height = 44.0,
    this.disabled = false,
    this.isLoading = false,
    this.color,
    this.highlightColor,
    this.splashColor,
    this.gradient,
    this.radius = const BorderRadius.all(Radius.circular(8)),
    this.border = const Border.fromBorderSide(
      BorderSide(
        color: Color(0x00000000),
        width: 0,
        style: BorderStyle.solid,
      ),
    ),
    this.padding = const EdgeInsets.only(left: 6, right: 6),
    this.margin = const EdgeInsets.only(),
    required this.onPressed,
  });

  Color get _color {
    if (disabled) {
      return const Color(0xFF004B40).withValues(alpha: 0.5);
    }

    return color ?? const Color(0xFF004B40);
  }

  Widget? get _child {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      );
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _color,
        gradient: gradient,
        borderRadius: radius,
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          highlightColor: highlightColor ?? Theme.of(context).highlightColor,
          splashColor: splashColor ?? Theme.of(context).splashColor,
          onTap: () {
            if (disabled || isLoading) return;

            onPressed?.call();
          },
          child: Padding(
            padding: padding,
            child: Center(child: _child),
          ),
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
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
