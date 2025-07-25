import 'package:flutter/material.dart';
import '../models/page_data.dart';

class PageViewController extends ChangeNotifier {
  int _currentPage = 0;
  final List<PageData> pages = [
    PageData(title: 'Page 1', color: Colors.blue),
    PageData(title: 'Page 2', color: Colors.green),
    PageData(title: 'Page 3', color: Colors.red),
  ];
  final PageController pageController = PageController();

  int get currentPage => _currentPage;

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void jumpToPage(int page) {
    pageController.jumpToPage(page);
    setCurrentPage(page);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
