import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/data/repositories/http_user_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/base_model/base_model.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/photo_gateway.dart';
import 'package:webant_gallery_part_two/domain/repositories/user_gateway.dart';

part 'search_photo_event.dart';

part 'search_photo_state.dart';

class SearchPhotoBloc<T> extends Bloc<SearchPhotoEvent, SearchPhotoState> {
  SearchPhotoBloc(this._photoGateway, this._httpUserGateway) : super(SearchPhotoInitial());
  final PhotoGateway _photoGateway;
  List<PhotoModel> _photos = [];
  BaseModel<T> _baseModel;
  final UserGateway _httpUserGateway;
  int _page = 1;

  @override
  Stream<SearchPhotoState> mapEventToState(
    SearchPhotoEvent event,
  ) async* {
    if (event is Searching) {
      try {
        if (event.newQuery) {
          _photos.clear();
          _page = 1;
        }
        if (_photos.isEmpty) {
          yield Loading();
        }
        _baseModel = await _photoGateway.fetchPhotos(
            queryText: event.queryText, page: _page);

        if (_page <= _baseModel.countOfPages) {
          String userName;
          List<PhotoModel> basePhotoModel = _baseModel.data as List<PhotoModel>;
          for (PhotoModel element in basePhotoModel) {
            if (element.user != null) {
              userName = await _httpUserGateway.getUserName(element.user);
              element = element.copyWith(user: userName);
            }
            _photos.add(element);
          }
          _page++;
          yield Search(_photos, false);
        } else {
          yield Search(_photos, true);
        }
        if (_photos.isEmpty) {
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
