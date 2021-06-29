import 'dart:async';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/new_or_popular_photos.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/photos_pages/single_photo.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/search_photo/search_photo_bloc/search_photo_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/loading_circular.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/photo_bottom_sheet.dart';

import 'gallery_bloc/gallery_bloc.dart';

class GalleryGrid extends StatefulWidget {
  const GalleryGrid({Key key, this.type, this.queryText, this.photos})
      : super(key: key);
  final queryText;
  final typeGrid type;
  final List<PhotoModel> photos;

  @override
  _GalleryGridState createState() =>
      _GalleryGridState(type: type, queryText: queryText, photos: photos);
}

class _GalleryGridState extends State<GalleryGrid> {
  ScrollController _controller;
  Completer<void> _reFresh;
  final typeGrid type;
  var queryText;
  bool _isLastPage = false;
  List<PhotoModel> photos;

  _GalleryGridState({this.type, this.queryText, this.photos});

  _scrollListener() {
    if (!_isLastPage) {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        if (type == typeGrid.PHOTOS) {
          context.read<GalleryBloc>().add(GalleryFetch());
        }
        if (type == typeGrid.SEARCH) {
          context
              .read<SearchPhotoBloc>()
              .add(Searching(queryText: queryText, newQuery: false));
        }
      }
    }
  }

  @override
  void initState() {
    _reFresh = Completer<void>();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _photosView(List<PhotoModel> photos) {
    return CustomScrollView(
      controller: _controller,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (c, i) => Container(
                child: GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Hero(
                        tag: photos[i].id,
                        child: photos[i].isPhotoSVG()
                            ? SvgPicture.network(photos[i].getImage())
                            : FancyShimmerImage(
                                imageUrl: photos[i].getImage(),
                                boxFit: BoxFit.cover,
                              ),
                      ),
                    ),
                    onTap: () => _toScreenInfo(photos[i]),
                    onLongPress: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) =>
                              PhotoBottomSheet(photo: photos[i]));
                    }),
              ),
              childCount: photos?.length ?? 0,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 9,
              crossAxisSpacing: 9,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: SizedBox(
                height: 40,
                width: 40,
                child: _isLastPage || photos.length < 10
                    ? null
                    : CircularProgressIndicator(
                        color: AppColors.mainColorAccent,
                        strokeWidth: 2.0,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        type == typeGrid.PHOTOS
            ? BlocListener<GalleryBloc, GalleryState>(
                listener: (context, state) {
                  setState(() {
                    _reFresh?.complete();
                    _reFresh = Completer();
                  });
                  if (state is GalleryData) {
                    setState(() {
                      photos =
                          state.photosBox.values.toList().cast<PhotoModel>();
                    });
                    if (state.isLastPage) {
                      setState(() {
                        _isLastPage = true;
                      });
                    }
                  }
                },
              )
            : BlocListener<SearchPhotoBloc, SearchPhotoState>(
                listener: (context, state) {
                  if (state is Search) {
                    if (state.isLastPage) {
                      setState(() {
                        _isLastPage = true;
                      });
                    }
                  }
                },
              ),
      ],
      child: RefreshIndicator(
        color: AppColors.mainColorAccent,
        backgroundColor: AppColors.colorWhite,
        strokeWidth: 2.0,
        onRefresh: () async {
          type == typeGrid.PHOTOS
              ? context.read<GalleryBloc>().add(GalleryRefresh())
              : context.read<SearchPhotoBloc>().add(SearchRefresh());
          return _reFresh.future;
        },
        child: type == typeGrid.SEARCH
            ? _photosView(photos)
            : BlocBuilder<GalleryBloc, GalleryState>(
                builder: (context, state) {
                  if (state is GalleryLoaded) {
                    return LoadingCircular();
                  }
                  if (state is GalleryData) {
                    return _photosView(photos);
                  }
                  if (state is GalleryInternetLost) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        color: AppColors.colorWhite,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0.0, 220, 0, 8),
                                child: Image.asset(AppStrings.imageIntersect),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'Sorry!',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: AppColors.mainColorAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                'There is no pictures. \nPlease come back later.',
                                style: TextStyle(color: AppColors.mainColorAccent),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
      ),
    );
  }

  void _toScreenInfo(PhotoModel photo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenInfo(photo: photo),
      ),
    );
  }
}
