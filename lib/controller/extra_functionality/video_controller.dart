import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class VideoController extends ChangeNotifier {
  late VideoPlayerController controller;
  bool isLoading = true;
  bool isInitializedOnce = false;
  bool showButton = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  VideoController() {}

  void changeButtonStatus(bool status) {
    showButton = status;
    notifyListeners();
  }

  Future<void> initialVideo(String url) async {
    try {
      if (isInitializedOnce == true) {
        await controller.dispose();
      }
      isLoading = true;
      notifyListeners();
      controller = VideoPlayerController.network(url,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
      await controller.initialize().then((value) {
        isLoading = false;
        isInitializedOnce = true;
        notifyListeners();
        controller.setLooping(false);
        controller.play();
      });
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }
}
