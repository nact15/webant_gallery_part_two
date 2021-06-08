import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery_part_two/data/repositories/http_photo_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/photos_bloc/gallery_bloc.dart';

import 'gallery_grid.dart';

class NewOrPopularPhotos extends StatefulWidget {
  const NewOrPopularPhotos({Key key}) : super(key: key);

  @override
  _NewOrPopularPhotosState createState() => _NewOrPopularPhotosState();
}

enum typePhoto { NEW, POPULAR }

class _NewOrPopularPhotosState extends State<NewOrPopularPhotos> {

  TextEditingController _searchController;

  _searchListener() {

  }

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(_searchListener);
    super.initState();
  }

  Widget buildAppBarSearch() {
    return Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.91,
          child: TextField(
            cursorColor: AppColors.mainColorAccent,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.colorOfSearchBar,
              contentPadding: EdgeInsets.all(8),
              hintText: 'Search',
              hintStyle: TextStyle(
                fontSize: 17,
                color: AppColors.mainColorAccent,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.mainColorAccent,
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: AppColors.decorationColor)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: AppColors.colorWhite),
              ),
            ),
            controller: _searchController,
            onTap: () {},
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.colorWhite,
          appBar: AppBar(
            title: buildAppBarSearch(),
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.colorWhite,
            bottom: TabBar(
              tabs: [
                Container(child: Tab(text: 'New')),
                Tab(text: 'Popular'),
              ],
              indicatorColor: AppColors.decorationColor,
              labelColor: AppColors.mainColor,
              unselectedLabelColor: AppColors.mainColorAccent,
              labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              BlocProvider<GalleryBloc>(
                  create: (BuildContext c) =>
                      GalleryBloc<PhotoModel>(HttpPhotoGateway(typePhoto.NEW))
                        ..add(GalleryFetch()),
                  child: GalleryGrid()),
              BlocProvider<GalleryBloc>(
                  create: (BuildContext c) =>
                      GalleryBloc<PhotoModel>(HttpPhotoGateway(typePhoto.POPULAR))
                        ..add(GalleryFetch()),
                  child: GalleryGrid()),
            ],
          ),
        ),
      ),
    );
  }
}
