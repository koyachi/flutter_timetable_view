import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/table_event.dart';
import 'package:flutter_timetable_view/src/styles/background_painter.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';
import 'package:flutter_timetable_view/src/views/event_view.dart';

class LaneView extends StatelessWidget {
  final List<TableEvent> events;
  final TimetableStyle timetableStyle;
  final int laneIndex;

  const LaneView({
    Key? key,
    required this.events,
    required this.timetableStyle,
    required this.laneIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(),
      width: timetableStyle.laneWidth,
      child: Stack(
        children: [
          ...[
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPainter(
                  timetableStyle: timetableStyle,
                  laneIndex: laneIndex,
                ),
              ),
            )
          ],
          ...events.map((event) {
            return EventView(
              event: event,
              timetableStyle: timetableStyle,
            );
          }).toList(),
        ],
      ),
    );
  }

  double height() {
    return (timetableStyle.endHour - timetableStyle.startHour) *
        timetableStyle.timeItemHeight;
  }
}
