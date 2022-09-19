import 'package:flutter/cupertino.dart';
class HomeController with ChangeNotifier{
  int currentPage=0;
  @override
  void dispose() {
    super.dispose();
  }
  void changePageIndex(int index){
    currentPage=index;
    notifyListeners();
  }

}