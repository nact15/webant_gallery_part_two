import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/photos_pages/photo_bottom_sheet.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/photos_pages/single_photo.dart';

import 'gallery_bloc/gallery_bloc.dart';

class GalleryGrid extends StatefulWidget {
  const GalleryGrid({Key key}) : super(key: key);

  @override
  _GalleryGridState createState() => _GalleryGridState();
}

class _GalleryGridState extends State<GalleryGrid> {
  ScrollController _controller;
  Completer<void> _reFresh;

  bool _isLastPage = false;

  _GalleryGridState();

  _scrollListener() {
    if (!_isLastPage) {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        context.read<GalleryBloc>().add(GalleryFetch());
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

  // @override
  // void dispose() {
  //   _reFresh = Completer<void>();
  //   _controller = ScrollController();
  //   _controller.addListener(_scrollListener);
  //   super.dispose();
  // }

  Widget _photosView(Box photosBox) {
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
                            tag: (photosBox.getAt(i) as PhotoModel).id,
                            child: photosBox.getAt(i).isPhotoSVG()
                                ? SvgPicture.network(
                                    photosBox.getAt(i).getImage())
                                : CachedNetworkImage(
                                    imageUrl: photosBox.getAt(i).getImage(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        onTap: () => _toScreenInfo(photosBox.getAt(i)),
                        onLongPress: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) =>
                                  PhotoBottomSheet(photo: photosBox.getAt(i)));
                        }),
                  ),
              childCount: photosBox?.length ?? 0,
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
    return BlocListener<GalleryBloc, GalleryState>(
      listener: (context, state) {
        setState(() {
          _reFresh?.complete();
          _reFresh = Completer();
        });
        if (state is GalleryData) {
          if (state.isLastPage) {
            setState(() {
              _isLastPage = true;
            });
          }
        }
      },
      child: RefreshIndicator(
        color: AppColors.mainColorAccent,
        backgroundColor: AppColors.colorWhite,
        strokeWidth: 2.0,
        onRefresh: () async {
          context.read<GalleryBloc>().add(GalleryRefresh());
          return _reFresh.future;
        },
        child:
            BlocBuilder<GalleryBloc, GalleryState>(builder: (context, state) {
          if (state is GalleryData) {
            if (state.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      color: AppColors.mainColorAccent,
                      strokeWidth: 2.0,
                    ),
                    Text(
                      'Loading...',
                      style: TextStyle(color: AppColors.mainColorAccent),
                    ),
                  ],
                ),
              );
            }
            return _photosView(state.photosBox);
          }
          if (state is GalleryInternetLost) {
            //
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                color: AppColors.colorWhite,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 150, 0, 40),
                        //child: Image.asset(AppStrings.imageAssetNoInternet),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: Text(
                          'no internet',
                          style: TextStyle(
                              fontSize: 25,
                              //color: AppColors.colorPink,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'no internet',
                        style: TextStyle(color: AppColors.mainColor),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Text(' ');
        }),
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
