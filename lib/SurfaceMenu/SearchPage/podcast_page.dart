import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:podtastic/podcast.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({
    Key key,
    @required this.rss,
    @required this.backButtonPressed,
  }) : super(key: key);

  final RssFeed rss;
  final backButtonPressed;
  @override
  _PodcastPageState createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {

  bool podcastPageOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.maxFinite,
      height: double.maxFinite,
      duration: Duration(milliseconds: 300),
      transform: Matrix4.translationValues(podcastPageOpen?0:MediaQuery.of(context).size.width, 0, 0),
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          color: Theme.of(context).primaryColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                        size: 30.0,
                      ),
                      onPressed: widget.backButtonPressed,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
                child: Container(
                  height: 160.0,
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 160.0,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                            width: 160.0,
                            height: 160.0,
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
    );
  }
}