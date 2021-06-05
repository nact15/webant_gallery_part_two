import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';

import 'new_or_popular_photos.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  int _bottomSelectedIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (int index) {
        pageChanged(index);
      },
      children: <Widget>[
        NewOrPopularPhotos(),
        NewOrPopularPhotos(),
        NewOrPopularPhotos(),
      ],
    );
  }

  void bottomTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    });
  }

  List<BottomNavigationBarItem> buildBottomBar() {
    return <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.home, size: 24.8),
        label: 'home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.camera_alt, size: 24.8),
        label: 'camera',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.account_circle, size: 24.8),
        label: 'profile',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.colorWhite,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.decorationColor,
        unselectedItemColor: AppColors.mainColorAccent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: buildBottomBar(),
        currentIndex: _bottomSelectedIndex,
        onTap: (int index) => bottomTapped(index),
      ),
    );
  }
}
