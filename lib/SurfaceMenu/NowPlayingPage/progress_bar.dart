import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget
{

  final double trackThickness;
  final Color trackColor;
  final double progressThickness;
  final Color progressColor;
  final double progressPercent;
  final double thumbHeight;
  final double thumbWidth;
  final Color thumbColor;

  ProgressBar({
    Key key,
    this.trackThickness = 2.0,
    @required this.trackColor,
    this.progressThickness = 2.0,
    @required this.progressColor,
    this.progressPercent = 0.0,
    this.thumbHeight = -10.0,
    this.thumbWidth = 3.0,
    @required this.thumbColor,
  }) : super(key: key);

  @override
  ProgressBarState createState() {
    return new ProgressBarState();
  }
}

class ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context)
  {
    return CustomPaint(
      painter: ProgressBarPainter(
        trackThickness: widget.trackThickness,
        trackColor: widget.trackColor,
        progressThickness: widget.progressThickness,
        progressColor: widget.progressColor,
        progressPercent: widget.progressPercent,
        thumbHeight: widget.thumbHeight,
        thumbWidth: widget.thumbWidth,
        thumbColor: widget.thumbColor
      ),
    );
  }
}

class ProgressBarPainter extends CustomPainter
{

  double trackThickness;
  Paint trackPaint;
  double progressThickness;
  double progressPercent;
  Paint progressPaint;
  double thumbHeight;
  double thumbWidth;
  Paint thumbPaint;

  ProgressBarPainter({
    @required this.trackThickness,
    @required trackColor,
    @required this.progressThickness,
    @required progressColor,
    @required this.progressPercent,
    @required this.thumbHeight,
    @required this.thumbWidth,
    @required thumbColor,
  }) : trackPaint = Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackThickness , // dependent on trackPaint.style
       progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke // dependent on trackPaint.style
        ..strokeWidth = progressThickness
        ..strokeCap = StrokeCap.square ,
       thumbPaint = Paint()
        ..color = thumbColor
        ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Paint track
    canvas.drawRect(
      Rect.fromLTWH(0.0, size.height / 2.0, size.width, trackThickness),
      trackPaint
    );

    // Paint progress
    canvas.drawRect(
      Rect.fromLTWH(0.0, size.height / 2.0, (size.width * progressPercent) + (thumbWidth / 2.0), progressThickness),
      progressPaint
    );

    // Paint thumb
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * progressPercent,
        (size.height / progressThickness) + (progressThickness * 1.5),
        thumbWidth,
        thumbHeight,
      ),
      thumbPaint
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}