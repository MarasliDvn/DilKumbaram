import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

late VideoPlayerController videoPlayerController;
late ChewieController chewieController;

class VideoplayerTest extends StatefulWidget {
  final String videUrl;
  final bool boole;
  const VideoplayerTest({Key? key, required this.videUrl,required this.boole}) : super(key: key);

  @override
  _VideoplayerTestState createState() => _VideoplayerTestState();
}

class _VideoplayerTestState extends State<VideoplayerTest> {
  @override
  void initState() {
    super.initState();
     if(widget.boole==false)
    {
      
      videoPlayerController.dispose();
      chewieController.dispose();
      
    }
    
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    videoPlayerController = VideoPlayerController.network(widget.videUrl);
    videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
    );
    
    return Chewie(
      controller: chewieController,
    );
    
  }
}
