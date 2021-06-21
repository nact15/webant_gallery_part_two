part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class LogOut extends UserEvent {}

class UpdateUser extends UserEvent{
  final UserModel user;

  UpdateUser({this.user});
}
class UpdatePassword extends UserEvent{
  final String oldPassword;
  final String newPassword;

  UpdatePassword(this.oldPassword, this.newPassword);

}
class UserFetch extends UserEvent{}
class UserDelete extends UserEvent{
 final UserModel user;

  UserDelete(this.user);
}
