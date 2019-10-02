import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:podtastic/SurfaceMenu/NowPlayingPage/now_playing_display.dart';
import 'package:podtastic/SurfaceMenu/SearchPage/search_page.dart';
import 'package:podtastic/SurfaceMenu/podcast_menu.dart';
import 'package:podtastic/SurfaceMenu/surface_drawer.dart';

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
    FocusScope.of(context).requestFocus(FocusNode());
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
    FocusScope.of(context).requestFocus(FocusNode());
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
                bottomPage: NowPlayingControls(),
                elevation: 0.0,
              ),
              SurfaceDrawer(
                surfaceDrawerHeight: MediaQuery.of(context).size.height,
                slidePercent: slidePercent,
                bottomPage: surfaceDrawerPage,
                topPage: NowPlayingDisplay(
                  onBackArrowTap: onNowPlayingTap,
                ),
                showTopPage: showNowPlaying,
                elevation: 30.0,
              ),
            ],
          ),
        ],
      )
    );
  }
}

class NowPlayingControls extends StatefulWidget {
  const NowPlayingControls({
    Key key,
  }) : super(key: key);

  @override
  _NowPlayingControlsState createState() => _NowPlayingControlsState();
}

class _NowPlayingControlsState extends State<NowPlayingControls> {
  double dividerIndent = 100.0;
  @override
  Widget build(BuildContext context) {
    dividerIndent = (MediaQuery.of(context).size.width/3.75);
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
          ),
          Expanded(child: buildPlayerControls(context)),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.star_border),
                      color: Theme.of(context).primaryColor,
                      iconSize: 30.0,
                      onPressed: (){},
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.launch),
                      color: Theme.of(context).primaryColor,
                      iconSize: 30.0,
                      onPressed: (){},
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.menu),
                      color: Theme.of(context).primaryColor,
                      iconSize: 30.0,
                      onPressed: (){},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPlayerControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: Container(),),
          IconButton(
            icon: Material(
              borderRadius: BorderRadius.circular(30.0),
              child: Icon(Icons.replay_30),
              elevation: 30.0,
              color: Colors.transparent,
            ),
            color: Theme.of(context).primaryColor,
            iconSize: MediaQuery.of(context).size.width / 6.5,
            onPressed: (){},
          ),
          Expanded(child: Container(),),
          IconButton(
            icon: Material(
              borderRadius: BorderRadius.circular(30.0),
              child: Icon(Icons.play_circle_filled),
              elevation: 30.0,
              color: Colors.transparent,
            ),
            color: Theme.of(context).primaryColor,
            iconSize: MediaQuery.of(context).size.width / 6,
            onPressed: (){},
          ),
          Expanded(child: Container(),),
          IconButton(
            icon: Material(
              borderRadius: BorderRadius.circular(30.0),
              child: Icon(Icons.forward_30),
              elevation: 30.0,
              color: Colors.transparent,
            ),
            color: Theme.of(context).primaryColor,
            iconSize: MediaQuery.of(context).size.width / 6.5,
            onPressed: (){},
          ),
          Expanded(child: Container(),),
        ],
      ),
    );
  }
}