import 'package:flutter/material.dart';
import 'package:podtastic/podcast.dart';

class PodcastProvider extends InheritedWidget
{
  PodcastProvider({
    Key key,
    Widget child,
  }) : super(key: key, child: child);
  
  Podcast nowPlaying = new Podcast();

  void setNowPlaying(Podcast pod)
  {
    nowPlaying = pod;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true; // may need to be optimized

  static PodcastProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PodcastProvider) as PodcastProvider);
  }

  
}