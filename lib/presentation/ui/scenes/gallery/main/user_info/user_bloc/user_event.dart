part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class LogOut extends UserEvent {}

class UpdateUser extends UserEvent{
  final UserModel user;

  UpdateUser({this.user});
}
class UserFetch extends UserEvent{}
