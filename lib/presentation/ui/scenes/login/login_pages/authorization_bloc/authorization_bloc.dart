import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/data/repositories/http_oauth_gateway.dart';
import 'package:webant_gallery_part_two/data/repositories/http_user_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/registration/user_model.dart';

part 'authorization_event.dart';

part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  AuthorizationBloc() : super(AuthorizationInitial());
  HttpOauthGateway httpOauthGateway = HttpOauthGateway();
  HttpRegistrationGateway httpRegistrationGateway = HttpRegistrationGateway();
  UserModel user;

  @override
  Stream<AuthorizationState> mapEventToState(
    AuthorizationEvent event,
  ) async* {
    if (event is AuthorizationSignUpEvent) {
      try {
        yield LoadingAuthorization();
        user = UserModel(
            username: event.name,
            birthday: event.birthday,
            email: event.email,
            phone: event.phone,
            password: event.password);
        httpRegistrationGateway.registration(user);
        user = await httpOauthGateway.authorization(event.name, event.password);
        yield AccessAuthorization(user);
      } on DioError {
        yield ErrorAuthorization();
      }
    }
    if (event is AuthorizationSignInEvent) {
      try {
        yield LoadingAuthorization();
        user = await httpOauthGateway.authorization(event.name, event.password);
        yield AccessAuthorization(user);
      } on DioError {
        yield ErrorAuthorization();
      }
    }
  }
}
