import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/lane_events.dart';
import 'package:flutter_timetable_view/src/styles/timetable_style.dart';
import 'package:flutter_timetable_view/src/utils/utils.dart';
import 'package:flutter_timetable_view/src/views/controller/timetable_view_controller.dart';
import 'package:flutter_timetable_view/src/views/diagonal_scroll_view.dart';
import 'package:flutter_timetable_view/src/views/lane_view.dart';

class TimetableView extends StatefulWidget {
  final List<LaneEvents> laneEventsList;
  final TimetableStyle timetableStyle;

  TimetableView({
    Key? key,
    required this.laneEventsList,
    this.timetableStyle: const TimetableStyle(),
  }) : super(key: key);

  @override
  _TimetableViewState createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView>
    with TimetableViewController {
  @override
  void initState() {
    initController();
    super.initState();
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.timetableStyle.visibleLaneView) _buildCorner(),
        _buildMainContent(context),
        _buildTimelineList(context),
        if (widget.timetableStyle.visibleLaneView) _buildLaneList(context),
      ],
    );
  }

  Widget _buildCorner() {
    return Positioned(
      left: 0,
      top: 0,
      child: SizedBox(
        width: widget.timetableStyle.timeItemWidth,
        height: widget.timetableStyle.laneHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(color: widget.timetableStyle.cornerColor),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.timetableStyle.timeItemWidth,
        top: widget.timetableStyle.visibleLaneView
            ? widget.timetableStyle.laneHeight
            : 0,
      ),
      child: DiagonalScrollView(
        horizontalPixelsStreamController: horizontalPixelsStream,
        verticalPixelsStreamController: verticalPixelsStream,
        onScroll: onScroll,
        maxWidth:
            widget.laneEventsList.length * widget.timetableStyle.laneWidth,
        maxHeight:
            (widget.timetableStyle.endHour - widget.timetableStyle.startHour) *
                widget.timetableStyle.timeItemHeight,
        child: IntrinsicHeight(
          child: Row(
            children: widget.laneEventsList.asMap().entries.map((entry) {
              final index = entry.key;
              final laneEvents = entry.value;
              return LaneView(
                events: laneEvents.events,
                timetableStyle: widget.timetableStyle,
                laneIndex: index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineList(BuildContext context) {
    Widget listView = ListView(
      physics: const ClampingScrollPhysics(),
      controller: verticalScrollController,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        for (var i = widget.timetableStyle.startHour;
            i < widget.timetableStyle.endHour;
            i += widget.timetableStyle.timelineBorderPerHours)
          i
      ].map((hour) {
        BoxDecoration? decoration;
        if (widget.timetableStyle.visibleTimelineBorder) {
          decoration = BoxDecoration(
            border: Border(
              top: BorderSide(
                color: widget.timetableStyle.timelineBorderColor,
                width: 0,
              ),
            ),
            color: widget.timetableStyle.timelineItemColor,
          );
        }
        return Container(
          height: widget.timetableStyle.timeItemHeight *
              widget.timetableStyle.timelineBorderPerHours,
          decoration: decoration,
          child: Text(
            Utils.hourFormatter(hour, 0),
            style: TextStyle(color: widget.timetableStyle.timeItemTextColor),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
    return Container(
      alignment: Alignment.topLeft,
      width: widget.timetableStyle.timeItemWidth,
      padding: widget.timetableStyle.visibleLaneView
          ? EdgeInsets.only(top: widget.timetableStyle.laneHeight)
          : null,
      color: widget.timetableStyle.timelineColor,
      child: widget.timetableStyle.visibleTimelineBorder
          ? listView
          : Transform.translate(
              offset: Offset(0, -6),
              child: listView,
            ),
    );
  }

  Widget _buildLaneList(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      color: widget.timetableStyle.laneColor,
      height: widget.timetableStyle.laneHeight,
      padding: EdgeInsets.only(left: widget.timetableStyle.timeItemWidth),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        controller: horizontalScrollController,
        shrinkWrap: true,
        children: widget.laneEventsList.map((laneEvents) {
          return Container(
            width: laneEvents.lane.width,
            height: laneEvents.lane.height,
            color: laneEvents.lane.backgroundColor,
            child: Center(
              child: Text(
                laneEvents.lane.name,
                style: laneEvents.lane.textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
