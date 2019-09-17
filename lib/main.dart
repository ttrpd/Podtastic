import 'package:flutter/material.dart';
import 'package:podtastic/SurfaceMenu/main_surface_menu.dart';
import 'package:podtastic/podcast_db.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Podtastic',
      theme: ThemeData(
        backgroundColor: Color.fromARGB(255, 255, 84, 107),//Color.fromARGB(255,168, 137, 255),
        primaryColor: Colors.white,
        primaryColorDark: Color.fromARGB(255, 242, 242, 242),
        accentColor: Color.fromARGB(255, 9, 0, 41),
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontSize: 26.0,
          ),
          body1: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            
          )
        ),
      ),
      
      home: PodcastDB(child: MainSurfaceMenu()),
    );
  }

}

