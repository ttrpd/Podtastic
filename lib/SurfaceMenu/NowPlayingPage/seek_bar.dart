import 'package:flutter/material.dart';
import 'package:podtastic/SurfaceMenu/NowPlayingPage/progress_bar.dart';

class SeekBar extends StatefulWidget
{
  final double trackProgressPercent;
  final double barWidth;
  final Function(double) onSeekRequested;

  SeekBar({
    Key key,
    @required this.barWidth,
    this.trackProgressPercent = 0.0,
    this.onSeekRequested,
  }) : super(key: key);

  @override
  SeekBarState createState() {
    return new SeekBarState();
  }
}

class SeekBarState extends State<SeekBar> {
  double _thumbWidth = 3.0;
  double _thumbHeight = -10.0;
  double _seekProgressPercent = 0.0;
  bool _seeking = false;

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(// seekbar
      onHorizontalDragStart: (DragStartDetails details)
      {
        setState(() {
          _seekProgressPercent = (details.localPosition.dx) / widget.barWidth;
          _thumbHeight *= 2.0;
          _thumbWidth *= 2.0;
          _seeking = true;
        });
      },
      onHorizontalDragUpdate: (DragUpdateDetails details)
      {
        setState(() {
          if(details.localPosition.dx <= widget.barWidth)
            _seekProgressPercent = (details.localPosition.dx) / widget.barWidth;
          else
            _seekProgressPercent = 1.0;
          
        });
      },
      onHorizontalDragEnd: (DragEndDetails details)
      {
        if(widget.onSeekRequested != null) {
          widget.onSeekRequested(_seekProgressPercent);
        }
        setState(() {
          _seeking = false;
          _thumbHeight /= 2.0;
          _thumbWidth /= 2.0;
        });
      },
      child: Container(// Seek bar
          width: MediaQuery.of(context).size.width,
          height: 30.0,
          color: Colors.transparent,
          child: ProgressBar(
            progressPercent: _seeking?_seekProgressPercent:widget.trackProgressPercent,
            thumbWidth: _thumbWidth,
            thumbHeight: _thumbHeight,
            progressColor: Theme.of(context).accentColor,
            trackColor: Theme.of(context).backgroundColor.withAlpha(30),
            thumbColor: Theme.of(context).backgroundColor,
          )
      ),
    );
  }
}