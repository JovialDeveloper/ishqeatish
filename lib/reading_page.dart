import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:novel/app_controller.dart';

class ReadingPage extends StatefulWidget {
  final String path;
  final int currentPage;
  const ReadingPage({
    super.key,
    required this.path,
    required this.currentPage,
  });

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  final AppController appController = Get.put(AppController());
  late PDFViewController _pdfViewController;

  bool isNightMode = false;
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    currentPage = widget.currentPage;
  }

  void _goToPage(int page) {
    if (page >= 0 && page < pages!) {
      _pdfViewController.setPage(page);
      setState(() {
        currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ishq-e-Atish'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PDFView(
              filePath: widget.path,
              nightMode: false,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: widget.currentPage,
              fitPolicy: FitPolicy.BOTH,
              onLinkHandler: (uri) {},
              preventLinkNavigation:
                  true, // if set to true the link is handled in flutter
              onRender: (pagess) {
                setState(() {
                  pages = pagess;
                  isReady = true;
                });
              },

              onViewCreated: (PDFViewController pdfViewController) {
                _pdfViewController = pdfViewController;
              },

              onPageChanged: (int? page, int? total) async {
                setState(() {
                  currentPage = page;
                });
                appController.saveCurrentPage(currentPage!);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    if (currentPage! > 0) {
                      _goToPage(currentPage! - 1);
                    }
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      color: Colors.white,
                      CupertinoIcons.back,
                    ),
                  ),
                ),
                const Text(
                  'Page:',
                  style: TextStyle(fontSize: 18),
                ),
                InkWell(
                  onTap: () => _showGoToPageDialog(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Text(
                      "${currentPage! + 1}/${pages!}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await appController.toggleBookmark(currentPage!);
                    setState(() {});
                  },
                  child: Icon(
                    appController.isBookmarked(currentPage!)
                        ? CupertinoIcons.star_fill
                        : CupertinoIcons.star,
                    color: appController.isBookmarked(currentPage!)
                        ? Colors.yellow.shade800
                        : Colors.grey,
                    size: 30,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (currentPage! < (pages! - 1)) {
                      _goToPage(currentPage! + 1);
                    }
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      color: Colors.white,
                      CupertinoIcons.forward,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showGoToPageDialog() async {
    final TextEditingController pageController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Go to Page Number'),
          content: TextField(
            controller: pageController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              hintText: 'Enter page number',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Set'),
              onPressed: () {
                final pageNumber =
                    int.tryParse(pageController.text.trim().toString());
                if (pageNumber != null &&
                    pageNumber >= 0 &&
                    pageNumber < (pages ?? 0)) {
                  _goToPage(pageNumber - 1);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
