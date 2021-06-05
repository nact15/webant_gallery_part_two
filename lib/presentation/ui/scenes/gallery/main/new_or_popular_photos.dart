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

enum typePhoto {NEW, POPULAR}

class _NewOrPopularPhotosState extends State<NewOrPopularPhotos> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.colorWhite,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.colorWhite,
            bottom: TabBar(
              tabs: [
                Tab(text: 'New'),
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
                  create: (BuildContext c) => GalleryBloc<PhotoModel>(
                      HttpPhotoGateway(typePhoto.NEW))
                    ..add(GalleryFetch()),
                  child: GalleryGrid()),
              BlocProvider<GalleryBloc>(
                  create: (BuildContext c) => GalleryBloc<PhotoModel>(
                      HttpPhotoGateway(typePhoto.POPULAR))
                    ..add(GalleryFetch()),
                  child: GalleryGrid()),
            ],
          ),
        ),
      ),
    );
  }
}
