// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:connectivity/connectivity.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:music_lyrics/controller/bloc_desc.dart';
import 'package:music_lyrics/controller/bloc_lyrics.dart';

import '../constantts/colors.dart';

class Description extends StatefulWidget {
  const Description({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  final description = Desc();
  final lyrics = Lyrics();
  @override
  void initState() {
    description.lyriceventsink.add(DescAction.get);
    description.ID = widget.id;
    lyrics.lyriceventsink.add(LyricAction.get);
    lyrics.ID = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: appbarcolor,
        title: const Text(
          'Description',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
          return snapshot.data == ConnectivityResult.mobile ||
                  snapshot.data == ConnectivityResult.wifi
              ? Text("No.Internet Connection")
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.2,
                        width: MediaQuery.of(context).size.width,
                        child: StreamBuilder<List<List<String>>>(
                          stream: description.lyricstream,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var music = snapshot.data![index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Name:',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(music[00],
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                          const SizedBox(height: 20),
                                          const Text(
                                            'Artist:',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(music[01],
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                          const SizedBox(height: 20),
                                          const Text(
                                            'Rating:',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(music[03],
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 40,
                                            child: Text(
                                              "Lyrics",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: textcolor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: Neumorphic(
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(12)),
                              depth: 8,
                              lightSource: LightSource.topLeft,
                              color: backgroundcolor),
                          child: StreamBuilder<String>(
                              stream: lyrics.lyricstream,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasData) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      var lyrics = snapshot.data!;
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SingleChildScrollView(
                                            child: Container(
                                                child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            lyrics,
                                            style: TextStyle(fontSize: 24),
                                          ),
                                        ))),
                                      );
                                    },
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
