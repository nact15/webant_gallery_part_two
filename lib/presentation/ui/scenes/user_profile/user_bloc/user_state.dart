part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class Exit extends UserState{}

class LoadingUpdate extends UserState{}
class UserData extends UserState{
  final UserModel user;

  UserData(this.user);
}

class ErrorUpdate extends UserState{}
class UserUpdate extends UserState{}