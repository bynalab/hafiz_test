import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TestMenuCard extends StatelessWidget {
  final String title;
  final String? image;
  final Color? color;
  final VoidCallback? onTap;

  const TestMenuCard({
    super.key,
    required this.title,
    this.image,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 160,
        child: Stack(
          children: [
            Container(
              width: 163,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color?.withOpacity(0.05),
                borderRadius: BorderRadius.circular(23),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF004B40),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset('assets/img/$image.png', height: 70),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(23),
                  right: Radius.circular(23),
                ),
                child: SvgPicture.asset(
                  'assets/img/card_bottom_vector.svg',
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
