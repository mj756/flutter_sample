import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class VideoController extends ChangeNotifier{
  late VideoPlayerController controller;
  bool isLoading=true;
  bool showButton=false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  VideoController(){
    initialVideo('https://www.appsloveworld.com/wp-content/uploads/2018/10/640.mp4');
  }

  void changeButtonStatus(bool status){
    showButton=status;
    notifyListeners();
  }

  Future<void> initialVideo(String url)async{
    try{
      isLoading=true;
      notifyListeners();
      controller=VideoPlayerController.network(
          url,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true)
      );
      await controller.initialize().then((value) {
        isLoading=false;
        notifyListeners();
        controller.setLooping(false);
        controller.play();
      });
    }catch(e){
      isLoading=false;
      notifyListeners();
    }

  }
}