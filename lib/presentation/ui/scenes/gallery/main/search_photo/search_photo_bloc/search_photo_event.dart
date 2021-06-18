part of 'search_photo_bloc.dart';

@immutable
abstract class SearchPhotoEvent {}
class Searching extends SearchPhotoEvent{
  final String queryText;
  final bool newQuery;
  Searching({this.queryText, this.newQuery});
}
class NotSearching extends SearchPhotoEvent{}