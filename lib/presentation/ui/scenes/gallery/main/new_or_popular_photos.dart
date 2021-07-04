import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery_part_two/data/repositories/http_photo_gateway.dart';
import 'package:webant_gallery_part_two/data/repositories/http_user_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/photos_pages/gallery_bloc/gallery_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/photos_pages/gallery_grid.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/search_photo/search_bar.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/search_photo/search_photo_bloc/search_photo_bloc.dart';

class NewOrPopularPhotos extends StatefulWidget {
  const NewOrPopularPhotos({Key key}) : super(key: key);

  @override
  _NewOrPopularPhotosState createState() => _NewOrPopularPhotosState();
}

enum typePhoto { NEW, POPULAR, SEARCH_BY_USER, SEARCH }
enum typeGrid { PHOTOS, SEARCH }

class _NewOrPopularPhotosState extends State<NewOrPopularPhotos> {
  TextEditingController _searchController;
  bool _search;
  String _queryText;

  @override
  void initState() {
    _search = false;
    _searchController = TextEditingController();
    _searchController.addListener(_searchListener);
    super.initState();
  }

  _searchListener() {
    String searchText = _searchController.text;
    if (_searchController.text.isEmpty) {
      _queryText = '';
      setState(() {
        _search = true;
      });
    } else if (searchText != _queryText) {
      setState(() {
        _search = false;
        _queryText = _searchController.text;
        context
            .read<SearchPhotoBloc>()
            .add(Searching(queryText: _queryText, newQuery: true));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchPhotoBloc, SearchPhotoState>(
      listener: (context, state) {
        if (state is! NothingToSearch) {
          setState(() {//TODO DELETE
            _search = true;
          });
        } else
          setState(() {
            _search = false;
          });
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        onHorizontalDragCancel: () =>
            FocusManager.instance.primaryFocus?.unfocus(),
        child: DefaultTabController(
          length: _search ? 1 : 2,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.colorWhite,
            appBar: AppBar(
              title: SearchBar(
                searchController: _searchController,
              ),
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.colorWhite,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TabBar(
                    tabs: _search
                        ? [Tab(text: 'Search by photo name')]
                        : ([Tab(text: 'New'), Tab(text: 'Popular')]),
                    indicatorColor: AppColors.decorationColor,
                    labelColor: AppColors.mainColor,
                    unselectedLabelColor: AppColors.mainColorAccent,
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                  ),
                ),
              ),
            ),
            body: !_search
                ? TabBarView(
                    children: <Widget>[
                      BlocProvider<GalleryBloc>(
                          create: (BuildContext c) => GalleryBloc<PhotoModel>(
                              HttpPhotoGateway(type: typePhoto.NEW),
                              HttpUserGateway())
                            ..add(GalleryFetch()),
                          child: GalleryGrid(
                            type: typeGrid.PHOTOS,
                          )),
                      BlocProvider<GalleryBloc>(
                          create: (BuildContext c) => GalleryBloc<PhotoModel>(
                              HttpPhotoGateway(type: typePhoto.POPULAR),
                              HttpUserGateway())
                            ..add(GalleryFetch()),
                          child: GalleryGrid(
                            type: typeGrid.PHOTOS,
                          )),
                    ],
                  )
                : GalleryGrid(type: typeGrid.SEARCH, queryText: _queryText),
          ),
        ),
      ),
    );
  }
}
