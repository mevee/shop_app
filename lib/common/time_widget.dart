import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/data/network/app_colors.dart';

class RunningClockWidget extends StatefulWidget {
  final String displayText;
  final IconData? clockIcon;
  final ValueChanged<DateTime>? onTick;
  final TextStyle? textStyle;
  final Color? subTxtColor;

  const RunningClockWidget({
    super.key,
    required this.displayText,
    this.clockIcon = Icons.access_time,
    this.onTick,
    this.textStyle,
    this.subTxtColor,
  });

  @override
  _RunningClockWidgetState createState() => _RunningClockWidgetState();
}

class _RunningClockWidgetState extends State<RunningClockWidget> {
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
        if (widget.onTick != null) {
          widget.onTick!(_currentTime);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.cherryRed.withOpacity(.2),
        borderRadius: BorderRadius.circular(8.0),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            widget.clockIcon ?? Icons.access_time,
            size: 20,
            color: AppColors.black01,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat('HH:mm:ss').format(_currentTime),
                  style:
                      widget.textStyle?.copyWith(fontWeight: FontWeight.bold) ??
                      Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColors.black01,
                      ),
                ),
                if (widget.displayText.isNotEmpty)
                Flexible(
                  child: Text(
                    widget.displayText,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.subTxtColor ?? AppColors.black01,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
