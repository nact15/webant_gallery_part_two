part of 'firestore_bloc.dart';

@immutable
abstract class FirestoreEvent {}
class UserViewsCounter extends FirestoreEvent{}
class UserCountUpdated extends FirestoreEvent{
  final count;

  UserCountUpdated(this.count);
}
class GetTags extends FirestoreEvent{
  final PhotoModel photo;

  GetTags(this.photo);
}