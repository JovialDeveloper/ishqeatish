import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel/app_controller.dart';
import 'package:novel/bookmarks_page.dart';
import 'package:novel/grid_item.dart';
import 'package:novel/reading_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppController appController = Get.put(AppController());
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final List<GridItem> items = [
      GridItem(
        icon: CupertinoIcons.book,
        text: 'Start Reading',
        color: Colors.red,
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          int currentPage = prefs.getInt('currentPage') ?? 0;
          Get.to(
            () => ReadingPage(
                path: appController.path.value, currentPage: currentPage),
          );
        },
      ),
      GridItem(
        icon: CupertinoIcons.bookmark,
        text: 'Book Marks',
        color: Colors.green,
        onTap: () {
          Get.to(
            () => BookmarksPage(
              path: appController.path.value,
            ),
          );
        },
      ),
      GridItem(
        icon: CupertinoIcons.hand_thumbsup_fill,
        text: 'Rate Us',
        color: Colors.purple,
        onTap: () {},
      ),
      GridItem(
        icon: Icons.key_outlined,
        text: 'Privacy Policy',
        color: Colors.teal,
        onTap: () async {
          if (!await launchUrl(Uri.parse(
              'https://sites.google.com/view/ishq-e-aatish-novel/home'))) {}
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ishq e Atish'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/home.png',
                height: height * 0.2,
              ),
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.15,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: items[index].onTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: items[index].color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            items[index].icon,
                            size: 48,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            items[index].text,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
