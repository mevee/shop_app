import 'package:flutter/material.dart';

class CustomButtonWithIcon extends StatelessWidget {
  const CustomButtonWithIcon({
    Key? key,
    required this.buttonText,
    this.icon,
    this.isIconButton = false,
    required this.buttonWidth,
    this.onClick,
    this.height,
    this.width,
    this.decoration,
    this.diabeldColor,
    this.overlayColor,
    required this.disabled,
  }) : super(key: key);
  final Text buttonText;
  final AssetImage? icon;
  final double buttonWidth;
  final bool isIconButton;
  final void Function()? onClick;
  final double? height;
  final double? width;
  final BoxDecoration? decoration;
  final Gradient? diabeldColor;
  final bool disabled;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        backgroundColor: const WidgetStatePropertyAll(Colors.black),
      ),
      onPressed: disabled ? null : onClick,
      child: SizedBox(
        width: width ?? size.width * buttonWidth,
        height: height ?? size.height * 0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buttonText,
            (isIconButton)
                ? Row(
                    children: [
                      const SizedBox(
                        width: 6,
                      ),
                      Image(
                        height: 17,
                        width: 17,
                        image: icon as ImageProvider,
                      )
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
