import 'package:flutter/cupertino.dart';
class HomeController extends ChangeNotifier{
  int currentPage=0;

  void changePageIndex(int index){
    currentPage=index;
    notifyListeners();
  }

}