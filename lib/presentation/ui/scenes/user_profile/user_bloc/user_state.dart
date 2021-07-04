part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class Exit extends UserState{}

class LoadingUpdate extends UserState{}
class UserData extends UserState{
  final UserModel user;
  final int countOfPhotos;
  final bool isUpdate;
  UserData({this.user, this.countOfPhotos, this.isUpdate});
}
class ErrorUpdate extends UserState{
  final String err;

  ErrorUpdate(this.err);
}
class UserUpdate extends UserState{}
class ErrorData extends UserState{}