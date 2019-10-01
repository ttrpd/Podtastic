import 'package:flutter/material.dart';

class SurfaceDrawer extends StatefulWidget {
  const SurfaceDrawer({
    Key key,
    @required this.bottomPage,
    this.topPage,
    this.showTopPage = true,
    @required this.surfaceDrawerHeight,
    @required this.slidePercent,
    this.initialDisplacement = 100.0,
    this.elevation = 10.0,
  }) : super(key: key);

  final Widget bottomPage;
  final Widget topPage;

  final double surfaceDrawerHeight;
  final double initialDisplacement;
  final double elevation;
  final double slidePercent;
  final bool showTopPage;

  @override
  _SurfaceDrawerState createState() => _SurfaceDrawerState();
}

class _SurfaceDrawerState extends State<SurfaceDrawer> {

  List<Widget> buildChildPages(bool showTopPage)
  {
    List<Widget> pages = [
      Container(
        width: double.maxFinite,
        height: widget.surfaceDrawerHeight,
        child: widget.bottomPage
      ),
    ];
    if(showTopPage)
    {
      pages.add(
        IgnorePointer(
          ignoring: !widget.showTopPage,
          child: AnimatedOpacity(
            opacity: widget.showTopPage ? 1.0 : 0.0,
            duration: Duration(milliseconds: 170),
            child: Container(
              color: Colors.transparent,
              width: double.maxFinite,
              height: widget.surfaceDrawerHeight,
              child: widget.topPage,
            ),
          ),
        )
      );
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Transform(
        alignment: Alignment.centerLeft,
        transform: Matrix4.translationValues(
          0.0,
          (widget.surfaceDrawerHeight * widget.slidePercent) + widget.initialDisplacement,
          0.0
        ),
        child: Material(
          color: Colors.transparent,
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
              height: widget.surfaceDrawerHeight,
              width: double.maxFinite,
              color: Colors.transparent,
              alignment: Alignment.topCenter,
              child: Stack(
                children: buildChildPages(widget.topPage != null),
              ),
            ),
          ),
        ),
      ),
    );
  }
}