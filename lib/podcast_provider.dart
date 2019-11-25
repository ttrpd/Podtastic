import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:podtastic/podcast.dart';

class PodcastProvider extends InheritedWidget
{

  bool playing = false;
  Duration currentTime = Duration(milliseconds: 0);
  Duration endTime = Duration(milliseconds: 1);
  double trackProgressPercent = 0.0;
  AudioPlayer audioPlayer = AudioPlayer();

  PodcastProvider({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  Episode playingEpisode;

  Future<void> setEpisode(Episode ep) async {
    ep.link = ep.link.replaceRange(0, ep.link.indexOf(':'), "https");
    playingEpisode = ep;
    audioPlayer.setUrl(ep.link);
    audioPlayer.resume();
    playing = true;
    endTime = Duration(milliseconds: await audioPlayer.getDuration());
  }

  void skip(Duration skipAmount) async
  {
    int pos = await audioPlayer.getCurrentPosition();
    audioPlayer.seek(Duration(milliseconds: pos+skipAmount.inMilliseconds));
  }

  void playPause()
  {
    if(playing)
      audioPlayer.pause();
    else
      audioPlayer.resume();

    playing = !playing;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PodcastProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PodcastProvider) as PodcastProvider);
  }
}