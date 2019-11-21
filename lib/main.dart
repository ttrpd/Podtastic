import 'package:flutter/material.dart';
import 'package:podtastic/SurfaceMenu/main_surface_menu.dart';
import 'package:podtastic/podcast_db.dart';
import 'package:podtastic/podcast_provider.dart';

void main() 
{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Podtastic',
      theme: ThemeData(
        backgroundColor: Color.fromARGB(255, 255, 84, 107),//Color.fromARGB(255,168, 137, 255),
        scaffoldBackgroundColor: Color.fromARGB(255, 240, 70, 92),
        primaryColor: Colors.white,
        primaryColorDark: Color.fromARGB(255, 242, 242, 242),
        accentColor: Color.fromARGB(255, 9, 0, 41),
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            fontFamily: 'AbrilFatface',
          ),
          body1: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            fontFamily: 'Rubik',
          )
        ),
      ),
      
      home: PodcastDB(
        child: PodcastProvider(
          child: MainSurfaceMenu()
        ),
      ),
    );
  }
}