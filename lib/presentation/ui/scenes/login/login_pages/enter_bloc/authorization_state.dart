part of 'authorization_bloc.dart';

@immutable
abstract class AuthorizationState {}

class AuthorizationInitial extends AuthorizationState {}
class AccessAuthorization extends AuthorizationState{
  final UserModel user;

  AccessAuthorization(this.user);
}
class ErrorAuthorization extends AuthorizationState{}
class LoadingAuthorization extends AuthorizationState{}