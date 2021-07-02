import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery_part_two/data/repositories/http_photo_gateway.dart';
import 'package:webant_gallery_part_two/data/repositories/http_user_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
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
  TextEditingController searchController;
  bool _search;
  String queryText;
  SearchPhotoBloc searchPhotoBloc;

  @override
  void initState() {
    _search = false;
    searchController = TextEditingController();
    searchController.addListener(_searchListener);
    super.initState();
  }

  _searchListener() {
    String searchText = searchController.text;
    if (searchController.text.isEmpty) {
      queryText = '';
      context.read<SearchPhotoBloc>().add(NotSearching());
    } else if (searchText != queryText) {
      setState(() {
        queryText = searchController.text;
        context
            .read<SearchPhotoBloc>()
            .add(Searching(queryText: queryText, newQuery: true));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchPhotoBloc, SearchPhotoState>(
      listener: (context, state) {
        if (state is! NothingToSearch) {
          setState(() {
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
                searchController: searchController,
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
            body: BlocBuilder<SearchPhotoBloc, SearchPhotoState>(
              builder: (context, state) {
                if (state is Loading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          color: AppColors.mainColorAccent,
                          strokeWidth: 2.0,
                        ),
                        Text(
                          AppStrings.loading,
                          style: TextStyle(color: AppColors.mainColorAccent),
                        ),
                      ],
                    ),
                  );
                }
                if (state is Search) {
                  return GalleryGrid(
                    photos: state.photos,
                    queryText: queryText,
                    type: typeGrid.SEARCH,
                  );
                }
                if (state is NotFound) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Column(
                        children: [
                          Image.asset(AppStrings.imageIntersect),
                          Text(
                            'Image not found',
                            style: TextStyle(
                                color: AppColors.mainColorAccent, fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is NothingToSearch || !_search) {
                  return TabBarView(
                    children: <Widget>[
                      BlocProvider<GalleryBloc>(
                          create: (BuildContext c) => GalleryBloc<PhotoModel>(
                              HttpPhotoGateway(type: typePhoto.NEW), HttpUserGateway())
                            ..add(GalleryFetch()),
                          child: GalleryGrid(
                            type: typeGrid.PHOTOS,
                          )),
                      BlocProvider<GalleryBloc>(
                          create: (BuildContext c) => GalleryBloc<PhotoModel>(
                              HttpPhotoGateway(type: typePhoto.POPULAR), HttpUserGateway())
                            ..add(GalleryFetch()),
                          child: GalleryGrid(
                            type: typeGrid.PHOTOS,
                          )),
                    ],
                  );
                }
                return Text('');
              },
            ),
          ),
        ),
      ),
    );
  }
}
