// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum DescAction { get }

class Desc {
  String ID = '';
  final _stateStreamcontroller = StreamController<List<List<String>>>();
  StreamSink<List<List<String>>> get lyricsink => _stateStreamcontroller.sink;
  Stream<List<List<String>>> get lyricstream => _stateStreamcontroller.stream;

  final _eventStreamcontroller = StreamController<DescAction>();
  StreamSink<DescAction> get lyriceventsink => _eventStreamcontroller.sink;
  Stream<DescAction> get lyriceventstream => _eventStreamcontroller.stream;

  Desc() {
    lyriceventstream.listen((event) async {
      if (event == DescAction.get) {
        try {
          var music = await getdesc(ID);
          lyricsink.add(music);
        } on Exception catch (e) {
          lyricsink.addError(e);
        }
      }
    });
  }

  Future<List<List<String>>> getdesc(String track) async {
    var client = http.Client();
    String Name;
    String Rating;
    String Id;
    String Artist;
    List<List<String>> temp = [];

    try {
      var response = await client.get(Uri.parse(
          'https://api.musixmatch.com/ws/1.1/track.get?track_id=$track&apikey=603001481f8e1358965205049c716363'));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        Name = jsonMap['message']['body']['track']['track_name'];
        Artist = jsonMap['message']['body']['track']['artist_name'];
        Id = jsonMap['message']['body']['track']['track_id'].toString();
        Rating = jsonMap['message']['body']['track']['track_rating'].toString();

        var list = [Name, Artist, Id, Rating];
        temp.add(list);
      }
    } on Exception {
      return temp;
    }

    return temp;
  }
}
