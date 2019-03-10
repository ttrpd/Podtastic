// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podtastic/WebPodcasts/podcast.dart';
import 'package:podtastic/main.dart';

void main() {
  group('Podcasts', () {
    test('Episode equality operator', (){
      Episode ep1 = Episode(
        'https://weak.com/',
        'First Episode',
        'It\'s the first one',
        'red october',
        1,
        Duration(seconds: 120),
        '03/08/2019'
      );

      Episode ep2 = Episode(
        'https://weaker.com/',
        'Second Episode',
        'It\'s not the first one',
        'It\'s the second one',
        2,
        Duration(seconds: 120),
        '03/09/2019'
      );

      expect(ep1==ep1, true);
      expect(ep1==ep2, false);
    });
    test('Podcast fromId Constructor', () async {//success depends on feed being processed fast enough at the moment
      Podcast podcast = Podcast.fromId('811377230');
      podcast.feed.whenComplete((){
        expect(podcast.id, '811377230');
        expect(podcast.title, 'Hello Internet');
        expect(podcast.link, 'https://itunes.apple.com/search?term=811377230&media=podcast');
        expect(podcast.played, false);
        expect(podcast.description, 'CGP Grey and Brady Haran talk about YouTube, life, work, whatever.');
        expect(podcast.artLink, 'https://is2-ssl.mzstatic.com/image/thumb/Music/v4/c0/9b/2d/c09b2da8-d805-b19e-6937-915c2d9aae60/source/600x600bb.jpg');
      });
    });

    test('Podcast Constructor', () async {//success depends on feed being processed fast enough at the moment
      Podcast podcast = Podcast.fromId(
        '811377230'
        // 'Hello Internet',
        // 'https://itunes.apple.com/search?term=811377230&media=podcast',
        // 'CGP Grey and Brady Haran talk about YouTube, life, work, whatever.',
        // false,
        // 'https://is2-ssl.mzstatic.com/image/thumb/Music/v4/c0/9b/2d/c09b2da8-d805-b19e-6937-915c2d9aae60/source/600x600bb.jpg'
      );
      podcast.feed.whenComplete((){
        expect(podcast.id, '811377230');
        expect(podcast.title, 'Hello Internet');
        expect(podcast.link, 'https://itunes.apple.com/search?term=811377230&media=podcast');
        expect(podcast.played, false);
        expect(podcast.description, 'CGP Grey and Brady Haran talk about YouTube, life, work, whatever.');
        expect(podcast.artLink, 'https://is2-ssl.mzstatic.com/image/thumb/Music/v4/c0/9b/2d/c09b2da8-d805-b19e-6937-915c2d9aae60/source/600x600bb.jpg');
      });
      
    });
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
  });
}
