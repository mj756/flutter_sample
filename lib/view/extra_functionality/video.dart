import 'package:flutter/material.dart';
import 'package:flutter_sample/controller/extra_functionality/video_controller.dart';
import 'package:flutter_sample/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../utils/constants.dart';

class VideoPlayerView extends StatelessWidget {
  VideoPlayerView({super.key});
  final TextEditingController _urlController = TextEditingController(
      text: 'https://www.appsloveworld.com/wp-content/uploads/2018/10/640.mp4');
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => VideoController(),
        lazy: false,
        builder: (context, child) {
          return Scaffold(
              appBar: AppBar(
                title: TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Enter video url',
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await Provider.of<VideoController>(context,
                                listen: false)
                            .initialVideo(_urlController.text);
                      },
                      child: Text(
                        'Play',
                        style: CustomStyles.customTextStyle(
                            isLargeFont: true,
                            defaultColor: AppConstants.whiteColor),
                      ))
                ],
              ),
              body: (context.watch<VideoController>().isInitializedOnce ==
                      false)
                  ? Center(child: Text('click on play button'))
                  : context.watch<VideoController>().isLoading == true
                      ? const Center(child: CircularProgressIndicator())
                      : Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Provider.of<VideoController>(context,
                                        listen: false)
                                    .changeButtonStatus(true);
                              },
                              /* child: AspectRatio(
                      aspectRatio: context
                          .watch<VideoController>()
                          .controller
                          .value
                          .aspectRatio,
                      child: VideoPlayer(
                          context.watch<VideoController>().controller),
                    ),*/
                              child: VideoPlayer(
                                  context.watch<VideoController>().controller),
                            ),
                            Positioned(
                                bottom: 10,
                                left: 0,
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: VideoProgressIndicator(
                                        context
                                            .watch<VideoController>()
                                            .controller,
                                        allowScrubbing: true))),
                            context.watch<VideoController>().showButton == true
                                ? Center(
                                    child: IconButton(
                                    icon: Icon(
                                      context
                                              .read<VideoController>()
                                              .controller
                                              .value
                                              .isPlaying
                                          ? Icons.pause
                                          : Icons.play_circle,
                                      size: 32,
                                    ),
                                    onPressed: () {
                                      Provider.of<VideoController>(context,
                                                  listen: false)
                                              .controller
                                              .value
                                              .isPlaying
                                          ? Provider.of<VideoController>(
                                                  context,
                                                  listen: false)
                                              .controller
                                              .pause()
                                          : Provider.of<VideoController>(
                                                  context,
                                                  listen: false)
                                              .controller
                                              .play();
                                      Provider.of<VideoController>(context,
                                              listen: false)
                                          .changeButtonStatus(false);
                                    },
                                  ))
                                : const SizedBox.shrink()
                          ],
                        ));
        });
  }
}
