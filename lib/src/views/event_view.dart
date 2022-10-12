import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/table_event.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';
import 'package:flutter_timetable_view/src/utils/utils.dart';

class EventView extends StatelessWidget {
  final TableEvent event;
  final TimetableStyle timetableStyle;

  const EventView({
    Key? key,
    required this.event,
    required this.timetableStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top(),
      height: height(),
      left: 0,
      width: timetableStyle.laneWidth,
      child: GestureDetector(
        onTap: event.onTap,
        child: Container(
          decoration:
              event.decoration ?? (BoxDecoration(color: event.backgroundColor)),
          margin: event.margin,
          padding: event.padding,
          child: Align(
            alignment:
                timetableStyle.eventContainerAlignment ?? Alignment.topLeft,
            child: (Utils.eventText)(
              event,
              context,
              math.max(
                  0.0, height() - (event.padding.top) - (event.padding.bottom)),
              math.max(
                  0.0,
                  timetableStyle.laneWidth -
                      (event.padding.left) -
                      (event.padding.right)),
              timetableStyle.visibleEventTime,
              timetableStyle.eventTextAlign,
            ),
          ),
        ),
      ),
    );
  }

  double top() {
    return calculateTopOffset(event.start.hour, event.start.minute,
            timetableStyle.timeItemHeight) -
        timetableStyle.startHour * timetableStyle.timeItemHeight;
  }

  double height() {
    return calculateTopOffset(0, event.end.difference(event.start).inMinutes,
            timetableStyle.timeItemHeight) +
        1;
  }

  double calculateTopOffset(
    int hour, [
    int minute = 0,
    double? hourRowHeight,
  ]) {
    return (hour + (minute / 60)) * (hourRowHeight ?? 60);
  }
}
