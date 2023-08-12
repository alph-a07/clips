import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Define a StatefulWidget for the VideoPlayerItem
class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

// State class for VideoPlayerItem
class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();

    // Initialize the VideoPlayerController with the provided video URL
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((value) {
        // Once initialized, play the video and set volume to max
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose of the VideoPlayerController when the widget is disposed
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      // Display the VideoPlayer using the initialized controller
      child: VideoPlayer(videoPlayerController),
    );
  }
}
