
import 'package:flutter/material.dart';
import 'package:podtastic/SurfaceMenu/MyPodcastsPage/my_podcasts_page.dart';
import 'package:podtastic/SurfaceMenu/SearchPage/search_page.dart';
import 'package:podtastic/SurfaceMenu/menu_item.dart';

class PodcastMenu extends StatefulWidget {
  PodcastMenu({
    Key key,
    @required this.context,
    @required this.surfaceDrawerPage,
    @required this.setSurfaceDrawerPage,
    @required this.onNowPlayingTap,
    @required this.onMenuTap,
  }) : super(key: key);

  final BuildContext context;
  final void Function(Widget) setSurfaceDrawerPage;
  final Widget surfaceDrawerPage;
  final void Function() onNowPlayingTap;
  final void Function() onMenuTap;

  @override
  _PodcastMenuState createState() => _PodcastMenuState();
}

class _PodcastMenuState extends State<PodcastMenu> {

  @override
  Widget build(BuildContext context) {
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
                        onPressed: widget.onMenuTap,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: 'Search',
                          style: Theme.of(context).primaryTextTheme.title
                            .copyWith(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'PlayFairDisplay',
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
                          onPressed: widget.onNowPlayingTap
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
                    selected: widget.surfaceDrawerPage is SearchPage,
                    onPressed: (){
                      widget.setSurfaceDrawerPage(SearchPage());
                      widget.onMenuTap();
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
                    selected: widget.surfaceDrawerPage is MyPodcastsPage,
                    onPressed: (){
                      widget.setSurfaceDrawerPage(MyPodcastsPage());
                      widget.onMenuTap();
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