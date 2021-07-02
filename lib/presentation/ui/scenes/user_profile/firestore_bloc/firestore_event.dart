part of 'firestore_bloc.dart';

@immutable
abstract class FirestoreEvent {}
class UserViewsCounter extends FirestoreEvent{
  final UserModel user;

  UserViewsCounter(this.user);
}
class UserCountUpdated extends FirestoreEvent{
  final count;

  UserCountUpdated(this.count);
}