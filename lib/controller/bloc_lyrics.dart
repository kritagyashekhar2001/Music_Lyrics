// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum LyricAction { get }

class Lyrics {
  String ID = '';
  final _stateStreamcontroller = StreamController<String>();
  StreamSink<String> get lyricsink => _stateStreamcontroller.sink;
  Stream<String> get lyricstream => _stateStreamcontroller.stream;

  final _eventStreamcontroller = StreamController<LyricAction>();
  StreamSink<LyricAction> get lyriceventsink => _eventStreamcontroller.sink;
  Stream<LyricAction> get lyriceventstream => _eventStreamcontroller.stream;

  Lyrics() {
    lyriceventstream.listen((event) async {
      if (event == LyricAction.get) {
        try {
          var lyric = await getlyrics(ID);
          lyricsink.add(lyric);
        } on Exception catch (e) {
          lyricsink.addError(e);
        }
      }
    });
  }

  Future<String> getlyrics(String track) async {
    var client = http.Client();
    late String Lyrics = '';
    try {
      var response = await client.get(Uri.parse(
          'https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$track&apikey=603001481f8e1358965205049c716363'));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        Lyrics = jsonMap['message']['body']['lyrics']['lyrics_body'];
      }
    } catch (e) {
      return e.toString();
    }

    return Lyrics;
  }
}
