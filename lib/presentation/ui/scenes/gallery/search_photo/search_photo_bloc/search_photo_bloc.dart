import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/domain/models/base_model/base_model.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/photo_gateway.dart';

part 'search_photo_event.dart';
part 'search_photo_state.dart';

class SearchPhotoBloc<T> extends Bloc<SearchPhotoEvent, SearchPhotoState> {
  SearchPhotoBloc(this.photoGateway) : super(SearchPhotoInitial());
  final PhotoGateway photoGateway;
  List<PhotoModel> photos = [];
  BaseModel<T> baseModel;
  int page = 1;

  @override
  Stream<SearchPhotoState> mapEventToState(
    SearchPhotoEvent event,
  ) async* {
    if (event is Searching) {
      if (event.newQuery) {
        photos.clear();
        page = 1;
      }
      if (photos.isEmpty) {
        yield Loading();
      }
      baseModel = await photoGateway.fetchPhotos(
          queryText: event.queryText, page: page);

      if (page <= baseModel.countOfPages) {
        photos.addAll(baseModel.data as List<PhotoModel>);
        print('length ${photos.length}');
        page++;
        yield Search(photos, false);
      } else {
        yield Search(photos, true);
      }
      if (photos.isEmpty) {
        yield NotFound();
      }
    }

    if (event is NotSearching) {
      yield NothingToSearch();
    }
  }
}
