import 'package:flutter/material.dart';
import 'package:movie_app/pages/front_page.dart';
import 'package:movie_app/pages/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueGrey,
        secondaryHeaderColor: Colors.blueGrey[600],
        backgroundColor: Colors.grey[200],
        textTheme: Theme.of(context).textTheme,
      ),
      home: FrontPage(),
    );
  }
}
