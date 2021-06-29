part of 'add_photo_bloc.dart';

@immutable
abstract class AddPhotoEvent {}
class PostPhoto extends AddPhotoEvent{
  final String name;
  final String description;
  final File file;

  PostPhoto({this.name, this.description, this.file});
}
class DeletingPhoto extends AddPhotoEvent{
  final PhotoModel photo;
  DeletingPhoto(this.photo);
}
class EditingPhoto extends AddPhotoEvent{
  final PhotoModel photo;
  final String name;
  final String description;
  EditingPhoto({this.photo, this.name, this.description});
}