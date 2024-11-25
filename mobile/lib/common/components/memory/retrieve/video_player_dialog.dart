import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerDialog extends StatefulWidget {
  const VideoPlayerDialog({super.key, required this.uris});

  final List<String> uris;

  @override
  State<VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  final videoPlayerControllerList = [];
  final chewieControllerList = [];

  @override
  void initState() {
    super.initState();

    for (final uri in widget.uris) {
      final videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(uri),
      );
      videoPlayerControllerList.add(videoPlayerController);
      chewieControllerList.add(null);
    }

    for (final videoPlayerController in videoPlayerControllerList) {
      videoPlayerController.initialize().then((_) {
        setState(() {
          final index = videoPlayerControllerList.indexOf(videoPlayerController);
          chewieControllerList[index] = ChewieController(
            videoPlayerController: videoPlayerController,
            aspectRatio: videoPlayerController.value.aspectRatio,
            autoPlay: true,
            looping: true,
            allowMuting: false,
            allowPlaybackSpeedChanging: false,
          );
        });
      });
    }
  }

  @override
  void dispose() {
    for (final videoPlayerController in videoPlayerControllerList) {
      videoPlayerController.dispose();
    }

    for (final chewieController in chewieControllerList) {
      chewieController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorsToken.black,
      elevation: 0,
      child: PageView.builder(
        itemCount: widget.uris.length,
        itemBuilder: (context, index) {
          if (chewieControllerList[index] == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Chewie(
              controller: chewieControllerList[index]!,
            ),
          );
        },
      ),
    );
  }
}
