// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:podtastic/podcast.dart';
import 'package:podtastic/podcast_db.dart';
import 'package:podtastic/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Podcasts', () {
    test('Episode equality operator', (){
      Episode ep1 = Episode(
        'https://weak.com/',
        'Episode name',
        'Episode description',
        'episode subtitle',
        1,
        false,
        Duration(seconds: 120),
        '03/08/2019'
      );

      Episode ep2 = Episode(
        'https://triforce.com/',
        'Other episode name',
        'Other episode description',
        'Other episode subtitle',
        1,
        false,
        Duration(seconds: 120),
        '02/07/2017'
      );

      expect(ep1==ep1, true);
      expect(ep1==ep2, false);
    });

    test('DB Podcast insertion', () async {
      Podcast pod = new Podcast(
        "Podcast title",
        "Podcast feedLink",
        "Podcast artistName",
        "Podcast description",
        "Podcast artLink",
        "Podcast artistLink",
        new List<Episode>()
      );
      
      PodcastDB myDB = new PodcastDB();
      await myDB.insertPodcast(pod);
      Podcast recoveredPod = (await myDB.getPodcast(pod.title))?.first;
      print(pod==recoveredPod);
      expect(pod == recoveredPod, true);
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
