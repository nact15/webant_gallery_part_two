part of 'add_photo_bloc.dart';

@immutable
abstract class AddPhotoState {}

class AddPhotoInitial extends AddPhotoState {}
class ErrorPostPhoto extends AddPhotoState{}
class LoadingPostPhoto extends AddPhotoState{}
class CompletePost extends AddPhotoState{
  final PhotoModel photo;

  CompletePost(this.photo);
}
class DeletePhoto extends AddPhotoState{
  final int index;

  DeletePhoto({this.index});
}
