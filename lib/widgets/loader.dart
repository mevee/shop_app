import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/utils/image_constants.dart';

class RotatingImageView extends StatefulWidget {
  const RotatingImageView({super.key});

  @override
  State<RotatingImageView> createState() => _RotatingImageViewState();
}

class _RotatingImageViewState extends State<RotatingImageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 10.0 * 3.14159,
            child: child,
          );
        },
        child: SvgPicture.asset(
          AppImages.premier,
          width: 20, // Adjust the size as needed
        ),
      ),
    );
  }
}
