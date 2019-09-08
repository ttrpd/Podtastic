import 'dart:ui';

import 'package:flutter/material.dart';
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
          SurfaceDrawer(
            surfaceDrawerHeight: MediaQuery.of(context).size.height - 50.0,
            slidePercent: slidePercent,
            page: surfaceDrawerPage,
          ),
        ],
      )
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
                        icon: Icon(Icons.menu, color: Colors.white,),
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
                            color: Colors.white,
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
                        child: Icon(
                          Icons.headset, 
                          color: Colors.white,
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
    @required this.page,
    @required this.surfaceDrawerHeight,
    @required this.slidePercent,
  }) : super(key: key);

  final Widget page;
  final double surfaceDrawerHeight;
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
          (widget.surfaceDrawerHeight * widget.slidePercent) + 50.0,
          0.0
        ),
        child: Material(
          elevation: 10.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35.0),
            child: Container(
              height: widget.surfaceDrawerHeight,
              width: double.maxFinite,
              color: Colors.white,
              alignment: Alignment.topCenter,
              child: Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height - 100.0,
                child: widget.page
              ),
            ),
          ),
        ),
      ),
    );
  }
}