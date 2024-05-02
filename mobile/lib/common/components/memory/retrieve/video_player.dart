import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    super.key,
    required this.fromNetwork,
    required this.uri,
    required this.file,
  });

  final bool fromNetwork;
  final String? uri;
  final XFile? file;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();

    if (widget.fromNetwork && widget.uri != null) {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.uri!),
      );
    } else if (widget.file != null) {
      videoPlayerController = VideoPlayerController.file(
        File(widget.file!.path),
      );
    }

    videoPlayerController.initialize().then((_) {
      setState(() {
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          aspectRatio: videoPlayerController.value.aspectRatio,
          autoPlay: true,
          looping: true,
          allowMuting: true,
          allowPlaybackSpeedChanging: false,
        );
      });
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (chewieController == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Chewie(
      controller: chewieController!,
    );
  }
}
