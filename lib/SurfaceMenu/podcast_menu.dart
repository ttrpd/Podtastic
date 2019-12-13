
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

  String menuTitle = "Search";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(Icons.menu, color: Theme.of(context).primaryColor,),
                        color: Colors.transparent,
                        onPressed: widget.onMenuTap,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      alignment: Alignment.center,
                      child: RichText(
                        maxLines: 1,
                        text: TextSpan(
                          text: menuTitle,
                          style: Theme.of(context).primaryTextTheme.title
                            .copyWith(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'PlayFairDisplay',
                            ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.headset, color: Theme.of(context).primaryColor,), 
                        color: Colors.transparent,
                        onPressed: widget.onNowPlayingTap
                      ),
                    )
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
                      setState(() {
                        menuTitle = 'Search';
                      });
                    },
                  ),
                  MenuItem(
                    text: 'Downloads',
                    enabled: false,
                    selected: false,
                    onPressed: () {
                      setState(() {
                        menuTitle = 'Downloads';
                      });
                    },
                  ),
                  MenuItem(
                    text: 'My Podcasts',
                    enabled: true,
                    selected: widget.surfaceDrawerPage is MyPodcastsPage,
                    onPressed: (){
                      widget.setSurfaceDrawerPage(MyPodcastsPage());
                      widget.onMenuTap();
                      setState(() {
                        menuTitle = 'My Podcasts';
                      });
                    },
                  ),
                  MenuItem(
                    text: 'Settings',
                    enabled: false,
                    selected: false,
                    onPressed: () {
                      setState(() {
                        menuTitle = 'Settings';
                      });
                    },
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