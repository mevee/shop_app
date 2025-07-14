import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {
  final double iconSize;
  final double titleSize;
  final Color? iconColor;
  final Color? assetColor;
  final Color? titleColor;
  final String? subtitle;
  final Color? subtitleColor;
  final bool showBackground;
  final String? assetPath;

  const AppLogo({
    super.key,
    this.iconSize = 80,
    this.titleSize = 32,
    this.iconColor,
    this.assetColor,
    this.titleColor,
    this.subtitle,
    this.subtitleColor,
    this.showBackground = true,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    Widget logoContent = Column(
      children: [
        if (assetPath != null)
          Image.asset(
            assetPath!,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
            color: assetColor,
          )
        else
          Icon(
            Icons.shopping_cart,
            size: iconSize,
            color: iconColor ?? Colors.white,
          ),
        const SizedBox(height: 16),
        Text(
          'Shop App',
          style: GoogleFonts.poppins(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: titleColor ?? Colors.white,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: subtitleColor ?? Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ],
    );

    if (showBackground) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: logoContent,
      );
    }

    return logoContent;
  }
} 