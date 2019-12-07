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
    const Color backgroundColor = Color.fromARGB(255, 255, 84, 107);
    const Color primarycolor = Colors.white;
    const Color scaffoldBackgroundColor = Color.fromARGB(255, 240, 70, 92);
    const Color primaryColorDark = Color.fromARGB(255, 242, 242, 242);
    const Color accentColor = Color.fromARGB(255, 9, 0, 41);
    const Color primaryTextColor = Colors.black;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Podtastic',
      theme: ThemeData(
        backgroundColor: backgroundColor,//Color.fromARGB(255,168, 137, 255),
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        primaryColor: primarycolor,
        primaryColorDark: primaryColorDark,
        accentColor: accentColor,
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: primaryTextColor,
            fontSize: 28.0,
            fontFamily: 'AbrilFatface',
          ),
          body1: TextStyle(
            color: primaryTextColor,
            fontSize: 22.0,
            fontFamily: 'Rubik',
          ),
          display1: TextStyle(
            color: primaryTextColor,
            fontSize: 12.0,
            fontFamily: 'Rubik'
          ),
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