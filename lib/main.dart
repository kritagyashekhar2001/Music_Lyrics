import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_lyrics/view/home_page.dart';
import 'package:music_lyrics/view/noconnection.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
          return snapshot.data == ConnectivityResult.mobile ||
                  snapshot.data == ConnectivityResult.wifi
              ? const HomePage()
              : const MyWidget();
        },
      ),
    );
  }
}
