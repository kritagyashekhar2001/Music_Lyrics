// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:connectivity/connectivity.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constantts/colors.dart';
import '../view/desc.dart';

class hive extends StatefulWidget {
  const hive({Key? key}) : super(key: key);

  @override
  State<hive> createState() => _hiveState();
}

class _hiveState extends State<hive> {
  late Box box;
  @override
  void initState() {
    super.initState();
    Hive.openBox('storage');
    box = Hive.box('storage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: appbarcolor,
        foregroundColor: Colors.black,
        title: const Text("Saved Songs"),
      ),
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
          return snapshot.data == ConnectivityResult.mobile ||
                  snapshot.data == ConnectivityResult.wifi
              ? Text("No.Internet Connection")
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder(
                    valueListenable: box.listenable(),
                    builder: (BuildContext context, Box box, Widget? child) {
                      if (box.isEmpty) {
                        return const Center(
                          child: Text(
                            'Empty',
                            style: TextStyle(fontSize: 30, color: textcolor),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: box.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Description(
                                              id: box.getAt(index),
                                            )),
                                  );
                                },
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.concave,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(12)),
                                      depth: 8,
                                      lightSource: LightSource.topLeft,
                                      color: backgroundcolor),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.music_note,
                                      color: textcolor,
                                    ),
                                    title: Row(
                                      children: [
                                        const Text(
                                          "Track Id:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(box.getAt(index)),
                                      ],
                                    ),
                                    // subtitle: Text(box.),
                                    trailing: IconButton(
                                      onPressed: () => box.deleteAt(index),
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                  ),
                );
        },
      ),
    );
  }
}
