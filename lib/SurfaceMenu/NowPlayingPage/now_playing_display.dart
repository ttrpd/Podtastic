import 'package:flutter/material.dart';
import 'package:podtastic/SurfaceMenu/NowPlayingPage/seek_bar.dart';

class NowPlayingDisplay extends StatefulWidget {
  const NowPlayingDisplay({
    Key key,
    @required this.onBackArrowTap,
  }) : super(key: key);

  final void Function() onBackArrowTap;
  @override
  _NowPlayingDisplayState createState() => _NowPlayingDisplayState();
}

class _NowPlayingDisplayState extends State<NowPlayingDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                          onPressed: widget.onBackArrowTap,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.settings, color: Theme.of(context).backgroundColor,),
                          color: Colors.transparent,
                          onPressed: widget.onBackArrowTap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
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
                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
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
                      Container(
                        height: MediaQuery.of(context).size.height/7,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                          child: SeekBar(
                            trackProgressPercent: 0.0,
                            onSeekRequested: (d){},
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
    );
  }
}