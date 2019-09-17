import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:podtastic/SurfaceMenu/MyPodcastsPage/my_podcasts_page.dart';
import 'package:podtastic/SurfaceMenu/menu_item.dart';
import 'package:podtastic/SurfaceMenu/SearchPage/search_page.dart';

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
          buildMenu(),
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
                topPage: buildNowPlayingInfo(context, showNowPlaying),
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget buildNowPlayingInfo(BuildContext context, bool showNowPlaying) {
    return AnimatedOpacity(
      opacity: showNowPlaying ? 1.0 : 0.0,
      duration: Duration(milliseconds: 170),
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height/2.6)),
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).backgroundColor,),
                            color: Colors.transparent,
                            onPressed: onNowPlayingTap,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.settings, color: Theme.of(context).backgroundColor,),
                            color: Colors.transparent,
                            onPressed: onNowPlayingTap,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: PageView(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 25.0, right: 8.0),
                              child: Container(
                                alignment: Alignment.center,
                                width: double.maxFinite,
                                child: RichText(
                                  text: TextSpan(
                                    text: "Test Title",
                                    style: Theme.of(context).primaryTextTheme.title
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: Theme.of(context).primaryTextTheme.title.color,
                              indent: 100.0,
                              endIndent: 100.0,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 30.0, top: 25.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Dolor sed viverra ipsum nunc aliquet bibendum enim. In massa tempor nec feugiat. Nunc aliquet bibendum enim facilisis gravida. Nisl nunc mi ipsum faucibus vitae aliquet nec ullamcorper. Amet luctus venenatis lectus magna fringilla. Volutpat maecenas volutpat blandit aliquam etiam erat velit scelerisque in. Egestas egestas fringilla phasellus faucibus scelerisque eleifend. Sagittis orci a scelerisque purus semper eget duis. Nulla pharetra diam sit amet nisl suscipit. Sed adipiscing",
                                    style: Theme.of(context).primaryTextTheme.body1
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.blueAccent,
                              height: MediaQuery.of(context).size.height/7,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(60.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: MediaQuery.of(context).size.width / 1.5,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SafeArea buildMenu() {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.menu, color: Theme.of(context).primaryColor,),
                        color: Colors.transparent,
                        onPressed: onMenuTap,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: 'Search',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(Icons.headset, color: Theme.of(context).primaryColor,), 
                          color: Colors.transparent,
                          onPressed: onNowPlayingTap
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MenuItem(
                    text: 'Search',
                    enabled: true,
                    selected: surfaceDrawerPage is SearchPage,
                    onPressed: (){
                      surfaceDrawerPage = SearchPage();
                      onMenuTap();
                    },
                  ),
                  MenuItem(
                    text: 'Downloads',
                    enabled: false,
                    selected: false,
                    onPressed: (){},
                  ),
                  MenuItem(
                    text: 'My Podcasts',
                    enabled: true,
                    selected: surfaceDrawerPage is MyPodcastsPage,
                    onPressed: (){
                      surfaceDrawerPage = MyPodcastsPage();
                      onMenuTap();
                    },
                  ),
                  MenuItem(
                    text: 'Settings',
                    enabled: false,
                    selected: false,
                    onPressed: (){},
                  ),
                  Container(//for spacing purposes
                    height: 100.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurfaceDrawer extends StatefulWidget {
  const SurfaceDrawer({
    Key key,
    @required this.bottomPage,
    @required this.topPage,
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