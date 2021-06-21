import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery_part_two/data/repositories/http_search_photo.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/add_photo/select_photo.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/search_photo/search_photo_bloc/search_photo_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/user_page.dart';

import 'new_or_popular_photos.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  _GalleryState();

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
        BlocProvider<SearchPhotoBloc>(
            create: (BuildContext c) =>
                SearchPhotoBloc<PhotoModel>(HttpSearchPhotoGateway()),
            child: NewOrPopularPhotos()),
        SelectPhoto(),
        UserPage(),
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
        label: AppStrings.home,
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.camera_alt, size: 24.8),
        label: AppStrings.camera,
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.account_circle, size: 24.8),
        label: AppStrings.profile,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
      ),
    );
  }
}
