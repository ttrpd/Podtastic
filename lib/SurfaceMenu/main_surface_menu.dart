import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:podtastic/SurfaceMenu/NowPlayingPage/now_playing_info.dart';
import 'package:podtastic/SurfaceMenu/SearchPage/search_page.dart';
import 'package:podtastic/SurfaceMenu/podcast_menu.dart';

class MainSurfaceMenu extends StatefulWidget {

  @override
  _MainSurfaceMenuState createState() => _MainSurfaceMenuState();
}

class _MainSurfaceMenuState extends State<MainSurfaceMenu> with TickerProviderStateMixin{

  double slidePercent = 0.0;
  double maxSlidePercent = 1.0;
  double startDragPercentSlide = 0.0;
  double finishSlideStart = 0.0;
  double finishSlideEnd = 1.0;

  bool showNowPlaying = false;

  AnimationController finishSlideController;

  Widget surfaceDrawerPage = SearchPage();

  onMenuTap()
  {

    if(slidePercent == 0.0)
    {
      finishSlideStart = 0.0;
      finishSlideEnd = 1.0;
    }
    else
    {
      finishSlideStart = 1.0;
      finishSlideEnd = 0.0;

    }
    finishSlideController.forward(from: 0.0);
  }

  onNowPlayingTap()
  {

    if(slidePercent == 0.0)
    {
      finishSlideStart = slidePercent;
      finishSlideEnd = -0.5;
      finishSlideController.forward(from: 0.0);
      showNowPlaying = true;
      return;
    }
    else if(slidePercent < 0.0)
    {
      finishSlideStart = -0.5;
      finishSlideEnd = 0.0;
      showNowPlaying = false;
    }
    else
    {
      finishSlideStart = slidePercent;
      finishSlideEnd = -0.5;
      showNowPlaying = true;
    }
    finishSlideController.forward(from: 0.0);
  }

  @override
  void initState() {
    super.initState();
    finishSlideController = AnimationController(
      duration: Duration(milliseconds: 170),
      vsync: this,
    )
    ..addListener(() {
      setState(() {
        slidePercent = lerpDouble(finishSlideStart, finishSlideEnd, finishSlideController.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: <Widget>[
          PodcastMenu(
            context: context,
            surfaceDrawerPage: surfaceDrawerPage,
            onMenuTap: onMenuTap,
            onNowPlayingTap: onNowPlayingTap,
            setSurfaceDrawerPage: (w)=> surfaceDrawerPage = w,
          ),
          Stack(
            children: <Widget>[
              SurfaceDrawer(
                surfaceDrawerHeight: MediaQuery.of(context).size.height,
                slidePercent: (slidePercent<0.0)?0.0:slidePercent,
                bottomPage: Container(color: Theme.of(context).backgroundColor,),
                elevation: 0.0,
              ),
              SurfaceDrawer(
                surfaceDrawerHeight: MediaQuery.of(context).size.height,
                slidePercent: slidePercent,
                bottomPage: surfaceDrawerPage,
                topPage: NowPlayingInfo(
                  showNowPlaying: showNowPlaying,
                  onBackArrowTap: onNowPlayingTap,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}

class SurfaceDrawer extends StatefulWidget {
  const SurfaceDrawer({
    Key key,
    @required this.bottomPage,
    this.topPage,
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

  @override
  _SurfaceDrawerState createState() => _SurfaceDrawerState();
}

class _SurfaceDrawerState extends State<SurfaceDrawer> {

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
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height,
                    child: widget.bottomPage
                  ),
                  (widget.topPage!=null)?
                  Container(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height,
                    child: widget.topPage,
                  ):Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}