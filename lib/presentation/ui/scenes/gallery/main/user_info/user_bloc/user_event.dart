part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class LogOut extends UserEvent {}
class UpdateUser extends UserEvent{
  final String name;
  final String email;
  final String password;
  final String birthday;

  UpdateUser({this.birthday, this.name, this.email, this.password});

}
