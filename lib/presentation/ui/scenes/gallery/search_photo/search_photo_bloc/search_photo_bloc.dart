import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/data/repositories/http_user_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/base_model/base_model.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/search_photo_gateway.dart';

part 'search_photo_event.dart';
part 'search_photo_state.dart';

class SearchPhotoBloc<T> extends Bloc<SearchPhotoEvent, SearchPhotoState> {
  SearchPhotoBloc(this.photoGateway) : super(SearchPhotoInitial());
  final SearchPhotoGateway photoGateway;
  List<PhotoModel> photos = [];
  BaseModel<T> baseModel;
  HttpUserGateway httpUserGateway = HttpUserGateway();
  int page = 1;

  @override
  Stream<SearchPhotoState> mapEventToState(
    SearchPhotoEvent event,
  ) async* {
    if (event is Searching) {
      try {
        if (event.newQuery) {
          photos.clear();
          page = 1;
        }
        if (photos.isEmpty) {
          yield Loading();
        }
        baseModel = await photoGateway.fetchPhotos(
            queryText: event.queryText, page: page);
        List<PhotoModel> basePhotoModel = baseModel.data as List<PhotoModel>;
        if (page <= baseModel.countOfPages) {
          photos.addAll(basePhotoModel);
          page++;
          yield Search(photos, false);
        } else {
          yield Search(photos, true);
        }
        if (photos.isEmpty) {
          yield NotFound();
        }
      } on DioError {
        yield NotFound();
      }
    }
    if (event is NotSearching) {
      yield NothingToSearch();
    }
  }
}
