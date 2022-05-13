// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum MusicAction { get }

class Bloc {
  final _stateStreamcontroller =
      StreamController<List<List<String>>>.broadcast();
  StreamSink<List<List<String>>> get musicsink => _stateStreamcontroller.sink;
  Stream<List<List<String>>> get musicstream => _stateStreamcontroller.stream;

  final _eventStreamcontroller = StreamController<MusicAction>();
  StreamSink<MusicAction> get eventsink => _eventStreamcontroller.sink;
  Stream<MusicAction> get eventstream => _eventStreamcontroller.stream;

  Bloc() {
    eventstream.listen((event) async {
      if (event == MusicAction.get) {
        try {
          var music = await getMusic();
          musicsink.add(music);
        } on Exception catch (e) {
          musicsink.addError(e);
        }
      }
    });
  }

  Future<List<List<String>>> getMusic() async {
    var client = http.Client();
    String track;
    String Singer;
    String Id;
    List<List<String>> temp = [];

    try {
      var response = await client.get(Uri.parse(
          'https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=603001481f8e1358965205049c716363'));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        int k = jsonMap['message']['body']['track_list'].length;
        // print(k);
        for (int i = 0; i < k; i++) {
          track = jsonMap['message']['body']['track_list'][i]['track']
              ['track_name'];
          Singer = jsonMap['message']['body']['track_list'][i]['track']
              ['artist_name'];
          Id = jsonMap['message']['body']['track_list'][i]['track']['track_id']
              .toString();
          var list = [track, Singer, Id];
          temp.add(list);
        }
      }
    } on Exception {
      return temp;
    }

    return temp;
  }
}
