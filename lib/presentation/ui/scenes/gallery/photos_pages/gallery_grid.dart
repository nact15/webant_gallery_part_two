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
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/add_photo/add_photo_bloc/add_photo_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/new_or_popular_photos.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/photos_pages/single_photo.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/search_photo/search_photo_bloc/search_photo_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/firestore_bloc/firestore_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/loading_circular.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/photo_bottom_sheet.dart';

import 'gallery_bloc/gallery_bloc.dart';

class GalleryGrid extends StatefulWidget {
  const GalleryGrid({Key key, this.type, this.crossCount, this.queryText})
      : super(key: key);
  final typeGrid type;
  final int crossCount;
  final queryText;

  @override
  _GalleryGridState createState() => _GalleryGridState(
      type: type, crossCount: crossCount, queryText: queryText);
}

class _GalleryGridState extends State<GalleryGrid> {
  ScrollController _controller;
  Completer<void> _reFresh;
  List<PhotoModel> _photos;
  bool _isLastPage;
  final typeGrid type;
  final queryText;
  final int crossCount;

  _GalleryGridState({this.type, this.crossCount, this.queryText});

  @override
  void initState() {
    _reFresh = Completer<void>();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _isLastPage = false;
    super.initState();
  }
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _photosGrid(List<PhotoModel> photos) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
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
              crossAxisCount: crossCount ?? 2,
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
                child: _isLastPage
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
                      _photos =
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
                  setState(() {
                    _reFresh?.complete();
                    _reFresh = Completer();
                  });
                  if (state is Search) {
                    _photos = state.photos;
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
          if (type == typeGrid.PHOTOS) {
            context.read<GalleryBloc>().add(GalleryRefresh());
          }
          if (type == typeGrid.SEARCH) {
            context
                .read<SearchPhotoBloc>()
                .add(Searching(queryText: queryText, newQuery: true));
          }
        },
        child: _selectBloc(),
      ),
    );
  }

  Widget _selectBloc() {
    if (type == typeGrid.SEARCH) {
      return BlocBuilder<SearchPhotoBloc, SearchPhotoState>(
        builder: (context, state) {
          if (state is Loading) {
            return LoadingCircular();
          }
          if (state is Search) {
            return _photosGrid(state.photos);
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
          return Container();
        },
      );
    }
    if (type == typeGrid.PHOTOS) {
      return BlocBuilder<GalleryBloc, GalleryState>(builder: (context, state) {
        if (state is GalleryLoaded) {
          return LoadingCircular();
        }
        if (state is GalleryData) {
          return _photosGrid(_photos);
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
                      padding: const EdgeInsets.fromLTRB(0.0, 220, 0, 8),
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
      });
    }
    return Container();
  }

  void _toScreenInfo(PhotoModel photo) {
    context.read<AddPhotoBloc>().add(ViewsCounter(photo));
    context.read<FirestoreBloc>().add(GetTags(photo));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenInfo(photo: photo),
      ),
    );
  }
}
