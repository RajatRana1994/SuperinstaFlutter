import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class InlineVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const InlineVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _showPlayer = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
  }

  Future<void> _initializeAndPlay() async {
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
    );
    setState(() {
      _showPlayer = true;
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _initializeAndPlay,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _showPlayer && _chewieController != null
            ? Chewie(controller: _chewieController!)
            : Stack(
          alignment: Alignment.center,
          children: [
            Container(color: Colors.black), // placeholder
            const Icon(Icons.play_circle, size: 60, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
