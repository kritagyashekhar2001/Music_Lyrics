// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum MusicAction { get }

class Bloc {
  // final _stateStreamcontroller = StreamController<List<TrackList>>();
  // StreamSink<List<TrackList>> get musicsink => _stateStreamcontroller.sink;
  // Stream<List<TrackList>> get musicstream => _stateStreamcontroller.stream;

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
          // musicsink.add(music.trackList);
          musicsink.add(music);
        } on Exception catch (e) {
          musicsink.addError(e);
        }
      }
    });
  }

  // Future<Body> getMusic() async {
  //   var client = http.Client();
  //   var musicModel;

  //   try {
  //     var response = await client.get(Uri.parse(
  //         'https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=603001481f8e1358965205049c716363'));
  //     if (response.statusCode == 200) {
  //       var jsonString = response.body;
  //       var jsonMap = json.decode(jsonString);

  //       musicModel = Body.fromJson(jsonMap);
  //     }
  //   } on Exception {
  //     return musicModel;
  //   }

  //   return musicModel;
  // }
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

  // Future<List<List<String>>> getlyrics(Id) async {
  //   var client = http.Client();
  //   String Name;
  //   String Rating;
  //   String Ids;
  //   String Artist;
  //   List<List<String>> temp = [];

  //   try {
  //     var response = await client.get(Uri.parse(
  //         'https://api.musixmatch.com/ws/1.1/track.get?track_id=$Id&apikey=603001481f8e1358965205049c716363'));
  //     if (response.statusCode == 200) {
  //       var jsonString = response.body;
  //       var jsonMap = json.decode(jsonString);
  //       Name = jsonMap['message']['body']['track']['track_name'];
  //       Artist = jsonMap['message']['body']['track']['artist_name'];
  //       Ids = jsonMap['message']['body']['track']['track_id'].toString();
  //       Rating = jsonMap['message']['body']['track']['track_rating'].toString();

  //       var list = [Name, Artist, Ids, Rating];
  //       temp.add(list);
  //     }
  //   } on Exception {
  //     return temp;
  //   }

  //   return temp;
  // }
}
