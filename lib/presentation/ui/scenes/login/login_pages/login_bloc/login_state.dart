part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginData extends LoginState {
  final bool isLoading;
  final bool isLogin;

  LoginData({this.isLoading, this.isLogin});
}
