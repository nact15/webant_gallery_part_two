import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/data/repositories/http_user_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/base_model/base_model.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/photo_gateway.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc<T> extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc(this.photoGateway) : super(GalleryInitial());
  final PhotoGateway<T> photoGateway;
  HttpUserGateway httpUserGateway = HttpUserGateway();
  Box photosBox;
  int _page = 1;
  BaseModel<T> baseModel;

@override
  Stream<GalleryState> mapEventToState(GalleryEvent event) async* {
    photosBox = Hive.box(photoGateway.enumToString());
    if (event is GalleryFetch) {
      yield* _mapGalleryFetch(event);
    }
    if (event is GalleryRefresh) {
      yield* _mapGalleryRefresh(event);
    }
    if (event is GalleryLoading){
      yield GalleryLoaded();
    }
  }

  Stream<GalleryState> _mapGalleryFetch(GalleryFetch event) async* {
    try {
      if (photosBox.isEmpty) {
        yield GalleryLoaded();
      }
      baseModel = await photoGateway.fetchPhotos(page: _page);
      if (photosBox.length < baseModel.totalItems) {
        _addToBox(); //add photos to box
        _page++;
        yield GalleryData(
            isLoading: false, isLastPage: false, photosBox: photosBox);
      }else {
        yield GalleryData(
          isLastPage: true,
          isLoading: false,
          photosBox: photosBox,
        );
     }
    } on DioError {
      yield* _internetError();
    }
  }

  Stream<GalleryState> _mapGalleryRefresh(GalleryRefresh event) async* {
    try {
      photosBox.clear();
      _page = 1;
      baseModel = await photoGateway.fetchPhotos(page: _page);
      _addToBox(); //add items to box after refresh
      _page++;
      yield GalleryData(
        isLoading: false,
        isLastPage: false,
        photosBox: photosBox,
      );
    } on DioError {
      yield* _internetError();
    }
  }

  Stream<GalleryState> _internetError() async* {
    if (photosBox.isNotEmpty) {
      yield GalleryData(
        photosBox: photosBox,
        isLastPage: true,
        isLoading: false,
      );
    } else
      yield GalleryInternetLost();
  }

  void _addToBox()  {
    List<PhotoModel> basePhotoModel = baseModel.data as List<PhotoModel>;
    List<PhotoModel> boxPhotoModel =
        photosBox.values.toList().cast<PhotoModel>();
    basePhotoModel.forEach((element) async {
      if (element.user != null){
        String userName = await httpUserGateway.getUserName(element.user);
        element = element.copyWith(user: userName);
      }
      if (boxPhotoModel.firstWhere(
            (elementB) => element.id == elementB.id,
            orElse: () => null,
          ) ==
          null) {
        photosBox.add(element);
      }
    });
  }
}
