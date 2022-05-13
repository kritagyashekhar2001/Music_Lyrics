// ignore_for_file: non_constant_identifier_names

import 'package:music_lyrics/constantts/colors.dart';
import 'package:music_lyrics/controller/bloc.dart';
import 'package:music_lyrics/model/hive.dart';
import 'package:music_lyrics/view/desc.dart';
import 'package:hive/hive.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bloc = Bloc();
  late Box box;

  @override
  void initState() {
    super.initState();
    bloc.eventsink.add(MusicAction.get);

    openBox();
  }

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('storage');
  }

  void putdata(String Name, String Id) {
    box.put(Name, Id);
  }

  void getdata() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const hive()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: appbarcolor,
        title: const Text(
          'Music App',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  getdata();
                },
                child: const Icon(
                  Icons.bookmark_outline_rounded,
                  color: textcolor,
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Builder(builder: (BuildContext context) {
          return StreamBuilder(
            stream: bloc.musicstream,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var music = snapshot.data![index];
                      return Column(
                        children: [
                          InkWell(
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.concave,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(12)),
                                    depth: 8,
                                    lightSource: LightSource.topLeft,
                                    color: backgroundcolor),
                                child: ListTile(
                                  leading: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.music_note,
                                      color: textcolor,
                                    ),
                                  ),
                                  title: Text(
                                    music[0],
                                    style: const TextStyle(
                                        color: textcolor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    music[1],
                                  ),
                                  trailing: InkWell(
                                      onTap: () {
                                        putdata(music[00], music[02]);
                                      },
                                      child: const Icon(
                                        Icons.favorite,
                                      )),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Description(
                                            id: music[02],
                                          )),
                                );
                              }),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      );
                    });
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                ));
              }
            },
          );
        }),
      ),
    );
  }
}
