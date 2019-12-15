import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:podtastic/podcast.dart';

class PodcastProvider extends InheritedWidget
{

  bool playing = false;
  Duration currentTime = Duration(milliseconds: 0);
  Duration endTime = Duration(milliseconds: 1);
  double trackProgressPercent = 0.0;
  AudioPlayer audioPlayer = AudioPlayer()..mode=PlayerMode.MEDIA_PLAYER;

  PodcastProvider({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  Episode playingEpisode;

  Future<void> setEpisode(Episode ep) async {


    // set currently playing episode
    ep.link = ep.link.replaceRange(0, ep.link.indexOf(':'), "https");
    playingEpisode = ep;
    // play currently playing episode
    audioPlayer.setUrl(ep.link);
    audioPlayer.onDurationChanged.listen((d) => endTime = d);
    audioPlayer.onAudioPositionChanged.listen((p) => currentTime = p);
    audioPlayer.resume();
    playing = true;
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

  Duration getTimeRemaining()
  {
    return Duration(milliseconds: endTime.inMilliseconds - currentTime.inMilliseconds);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PodcastProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PodcastProvider) as PodcastProvider);
  }
}
