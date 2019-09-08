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
        primaryColor: Colors.white,
        backgroundColor: Color.fromARGB(255,168, 137, 255),
        primaryTextTheme: TextTheme(
          body1: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
          ),
          body2: TextStyle(
            color: Colors.grey,
            fontSize: 10.0,
          )
        ),
      ),
      
      home: PodcastDB(child: MainSurfaceMenu()),
    );
  }

}

