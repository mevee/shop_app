import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/widgets/helper.dart';

class TapAnimationButton extends StatelessWidget {
  final RxBool buttonTapped = false.obs;
  final Widget child;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final Duration animationDuration;
  final BorderRadius? borderRadius;
  final GestureTapCallback onTap;
  final bool disabled;
  final bool showBackgroundColor;

  TapAnimationButton({
    super.key,
    required this.child,
    required this.onTap,
    this.backgroundColor = Colors.transparent,
    this.selectedBackgroundColor = Colors.grey,
    this.animationDuration = const Duration(milliseconds: 200),
    this.borderRadius,
    this.disabled = false,
    this.showBackgroundColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(0)),
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        child: GestureDetector(
          onTapUp: (details) {
            if (disabled) {
              return;
            }
            buttonTapped.value = true;
          },
          onTapCancel: () {
            if (disabled) {
              return;
            }
            buttonTapped.value = false;
          },
          onTapDown: (details) {
            if (disabled) {
              return;
            }
            buttonTapped.value = false;
          },
          onTap: () {
            if (disabled) {
              return;
            }
            Future.delayed(animationDuration, () {
              onTap();
              buttonTapped.value = false;
            });
          },
          onLongPressStart: (details) {
            if (disabled) {
              return;
            }
            buttonTapped.value = true;
          },
          onLongPressCancel: () {
            if (disabled) {
              return;
            }
            buttonTapped.value = false;
          },
          onLongPressDown: (details) {
            if (disabled) {
              return;
            }
            buttonTapped.value = false;
          },
          onLongPressEnd: (details) {
            if (disabled) {
              return;
            }
            buttonTapped.value = false;
          },
          onLongPressUp: () {
            if (disabled) {
              return;
            }
            buttonTapped.value = false;
          },
          child: Obx(
            () => InkWell(
              overlayColor: WidgetStateProperty.all(
                selectedBackgroundColor ?? Theme.of(context).primaryColorLight,
              ),
              highlightColor:
                  selectedBackgroundColor ??
                  Theme.of(context).primaryColorLight,
              splashColor:
                  selectedBackgroundColor ??
                  Theme.of(context).primaryColorLight,
              onFocusChange: (value) {
                buttonTapped.value = false;
              },
              child: Ink(
                color: showBackgroundColor && buttonTapped.value
                    ? selectedBackgroundColor
                    : backgroundColor,
                child: Opacity(
                  opacity: !showBackgroundColor && buttonTapped.value
                      ? 0.5
                      : 1.0,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buttonWithLoader({
  required bool disable,
  required bool isLoading,
  required BuildContext context,
  required String label,
  Color color = AppColors.lightGrey,
  Color textColor = AppColors.textGrey,
  Color progressColor = Colors.deepPurpleAccent,
  required Function() onPressed,
}) {
  return TapAnimationButton(
    disabled: disable,
    onTap: disable ? () {} : onPressed,
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: disable ? color.withValues(alpha: 0.3) : color,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: progressColor,
                strokeWidth: 2,
              ),
            ),
          if (isLoading) horizontalSpacing(16),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: disable ? Colors.white : textColor,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buttonWithImage({
  required bool disable,
  required BuildContext context,
  required String label,
  required Widget leftIcon,
  Color color = AppColors.lightGrey,
  Color textColor = AppColors.textGrey,
  Color progressColor = Colors.deepPurpleAccent,
  required Function() onPressed,
}) {
  return TapAnimationButton(
    disabled: disable,
    onTap: disable ? () {} : onPressed,
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: disable ? color.withValues(alpha: 0.3) : color,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
           leftIcon,
           Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: disable ? Colors.white : textColor,
            ),
          ),
        ],
      ),
    ),
  );
}
