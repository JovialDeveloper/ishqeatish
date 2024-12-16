import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  Rx<String> path = ''.obs;
  RxList<int> bookmarkedPages = <int>[].obs;

  RxBool isBannerAdLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPdfFromAssets();

    loadBookmarks();
  }

  Future<void> loadPdfFromAssets() async {
    final ByteData bytes =
        await rootBundle.load('assets/Ishq-e-Atish-by-Sadia-Rajpoot.pdf');
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/temp.pdf');
    await tempFile.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    path.value = tempFile.path;
  }

  Future<bool> loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedBookmarks = prefs.getStringList('bookmarkedPages');
    if (savedBookmarks != null) {
      bookmarkedPages.value = savedBookmarks.map(int.parse).toList();
      bookmarkedPages.sort();
      return true;
    }
    return false;
  }

  Future<void> toggleBookmark(int currentPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (bookmarkedPages.contains(currentPage)) {
      bookmarkedPages.remove(currentPage);
    } else {
      bookmarkedPages.add(currentPage);
    }
    await prefs.setStringList(
      'bookmarkedPages',
      bookmarkedPages.map((e) => e.toString()).toList(),
    );
  }

  bool isBookmarked(int currentPage) {
    return bookmarkedPages.contains(currentPage);
  }

  Future<void> saveCurrentPage(int currentPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'currentPage',
      currentPage,
    );
  }
}
