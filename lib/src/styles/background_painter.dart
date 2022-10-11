import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';

class BackgroundPainter extends CustomPainter {
  final TimetableStyle timetableStyle;
  final int laneIndex;

  BackgroundPainter({
    required this.timetableStyle,
    required this.laneIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = timetableStyle.mainBackgroundColor,
    );
    if (timetableStyle.visibleTimeBorder) {
      for (int hour = timetableStyle.timelineBorderStart;
          hour < 24;
          hour += timetableStyle.timelineBorderPerHours) {
        double topOffset = calculateTopOffset(hour);
        canvas.drawLine(
          Offset(0, topOffset),
          Offset(size.width, topOffset),
          Paint()
            ..color = timetableStyle.timelineBorderColor
            ..strokeWidth = timetableStyle.borderStrokeWidth,
        );
      }
    }

    if (timetableStyle.visibleDecorationBorder) {
      final drawLimit = size.height / timetableStyle.decorationLineHeight;
      for (double count = 0; count < drawLimit; count += 1) {
        double topOffset = calculateDecorationLineOffset(count);
        final paint = Paint()..color = timetableStyle.decorationLineBorderColor;
        final dashWidth = timetableStyle.decorationLineDashWidth;
        final dashSpace = timetableStyle.decorationLineDashSpaceWidth;
        var startX = 0.0;
        while (startX < size.width) {
          canvas.drawLine(
            Offset(startX, topOffset),
            Offset(startX + timetableStyle.decorationLineDashWidth, topOffset),
            paint,
          );
          startX += dashWidth + dashSpace;
        }
      }
    }

    List<Color>? laneBorderColors = timetableStyle.laneBorderColors;
    if (laneBorderColors != null) {
      double topOffset = 0.0;
      double bottomOffset =
          (timetableStyle.endHour - timetableStyle.startHour) *
              timetableStyle.timeItemHeight;
      double x = 0.5;
      canvas.drawLine(
        Offset(x, topOffset),
        Offset(x, bottomOffset),
        Paint()
          ..color = laneBorderColors[laneIndex]
          ..strokeWidth = timetableStyle.borderStrokeWidth,
      );

      if (laneIndex == laneBorderColors.length - 2) {
        double x = timetableStyle.laneWidth - 0.5;
        canvas.drawLine(
          Offset(x, topOffset),
          Offset(x, bottomOffset),
          Paint()
            ..color = laneBorderColors[laneIndex + 1]
            ..strokeWidth = timetableStyle.borderStrokeWidth,
        );
      }
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDayViewBackgroundPainter) {
    return (timetableStyle.mainBackgroundColor !=
            oldDayViewBackgroundPainter.timetableStyle.mainBackgroundColor ||
        timetableStyle.timelineBorderColor !=
            oldDayViewBackgroundPainter.timetableStyle.timelineBorderColor);
  }

  double calculateTopOffset(int hour) => hour * timetableStyle.timeItemHeight;

  double calculateDecorationLineOffset(double count) =>
      count * timetableStyle.decorationLineHeight;
}
