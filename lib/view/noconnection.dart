import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:music_lyrics/constantts/colors.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Not Connected"),
        backgroundColor: appbarcolor,
        foregroundColor: Colors.black,
      ),
      backgroundColor: backgroundcolor,
      body: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            depth: 8,
            lightSource: LightSource.topLeft,
            color: backgroundcolor),
        child: const Center(
            child: Text(
          "No Internet Connection",
          style: TextStyle(
              color: textcolor, fontSize: 30, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
