import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:photo_view/photo_view_gallery.dart';

class ImageViewerPage extends StatefulWidget {
  ImageViewerPage(
    this.imageList, {
    Key? key,
    this.initialIndex = 0,
  })  : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final List<String> imageList;
  final int initialIndex;
  final PageController pageController;

  @override
  State<StatefulWidget> createState() {
    return _ImageViewerPageState();
  }
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.imageList.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.black.withOpacity(0.5),
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: itemCount,
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
            ),
          ),
          Positioned(
            bottom: 26,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 4,
                    bottom: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / $itemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    String imageUrl = widget.imageList[index];

    return PhotoViewGalleryPageOptions.customChild(
      child: Container(
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 42,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        FluentIcons.dismiss_20_regular,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
            Hero(
              tag: imageUrl,
              child: Container(
                margin: const EdgeInsets.only(bottom: 42),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 60,
                ),
                child: imageUrl.startsWith('http')
                    ? Image.network(imageUrl)
                    : Image.file(File(imageUrl)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
