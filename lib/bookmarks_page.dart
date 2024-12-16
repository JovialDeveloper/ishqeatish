import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/app_controller.dart';
import 'package:novel/reading_page.dart';

class BookmarksPage extends StatefulWidget {
  final String path;
  const BookmarksPage({super.key, required this.path});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final AppController appController = Get.put(AppController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Marks'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: appController.bookmarkedPages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  tileColor: Colors.green.shade100,
                  onTap: () {
                    Get.to(
                      () => ReadingPage(
                        path: widget.path,
                        currentPage: appController.bookmarkedPages[index],
                      ),
                    );
                  },
                  title: Text(
                    'Page ${(appController.bookmarkedPages[index] + 1).toString()}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
