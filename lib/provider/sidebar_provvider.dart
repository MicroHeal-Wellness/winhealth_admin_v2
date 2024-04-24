import 'package:flutter/material.dart';

class SideBarProvider with ChangeNotifier {
  int _page = -1;
  // int _page = 9;

  int get currentPage => _page;

  void changePage(int page) {
    _page = page;
    notifyListeners();
  }
}
