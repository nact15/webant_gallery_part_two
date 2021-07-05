part of 'firestore_bloc.dart';

@immutable
abstract class FirestoreState {}

class FirestoreInitial extends FirestoreState {}

class CountOfUserViews extends FirestoreState {
  final count;

  CountOfUserViews(this.count);
}

class ShowTags extends FirestoreState {
  final List<dynamic> tags;
  final String userName;

  ShowTags(this.tags, this.userName);
}
