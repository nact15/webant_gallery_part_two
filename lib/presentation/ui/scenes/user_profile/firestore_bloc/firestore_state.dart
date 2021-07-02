part of 'firestore_bloc.dart';

@immutable
abstract class FirestoreState {}

class FirestoreInitial extends FirestoreState {}

class CountOfUserViews extends FirestoreState{
  final count;

  CountOfUserViews(this.count);
}
