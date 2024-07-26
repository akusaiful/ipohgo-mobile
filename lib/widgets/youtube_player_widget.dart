import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  const YoutubePlayerWidget({Key? key, required this.videoUrl})
      : super(key: key);
  final String videoUrl;

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late final PodPlayerController controller;
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    String? videoId;
    // videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    // print(widget.videoUrl);
    // const string = 'www.youtube.com/embed/nsRh6ZN99gc';
    final splitted = widget.videoUrl.split('/');
    videoId = splitted[4];
    print(widget.videoUrl);
    print('Video ID ' + videoId.toString());
    _controller = YoutubePlayerController(
      initialVideoId: videoId.toString(),
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),
    );
    super.initState();
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      //  videoProgressIndicatorColor: Colors.amber,
      progressColors: ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),

      onReady: () {
        // print('Player is ready.');
        // _controller.addListener(listener);
      },
    );
  }
}
