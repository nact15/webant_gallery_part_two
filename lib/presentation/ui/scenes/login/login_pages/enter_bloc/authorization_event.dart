part of 'authorization_bloc.dart';

@immutable
abstract class AuthorizationEvent {}
class AuthorizationSignInEvent extends AuthorizationEvent{
  final String name;
  final String password;

  AuthorizationSignInEvent(this.name, this.password);
}
class AuthorizationSignUpEvent extends AuthorizationEvent{
  final String name;
  final String password;
  final String birthday;
  final String phone;
  final String email;

  AuthorizationSignUpEvent(
      {this.name, this.password, this.birthday, this.phone, this.email});
}