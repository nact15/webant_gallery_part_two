import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/data/repositories/http_oauth_gateway.dart';
import 'package:webant_gallery_part_two/data/repositories/http_user_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/http_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/user_bloc/user_bloc.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  AuthorizationBloc(this.oauthGateway, this.userGateway, this.userBloc)
      : super(AuthorizationInitial());
  final UserBloc userBloc;
  UserModel user;
  final HttpOauthGateway oauthGateway;
  final HttpUserGateway userGateway;
  final _storage = Storage.FlutterSecureStorage();

  @override
  Stream<AuthorizationState> mapEventToState(
    AuthorizationEvent event,
  ) async* {
    if (event is LoginFetch) {
      yield* _mapLoginFetchToLoginData(event);
    }
    if (event is SignUpEvent) {
      yield* _mapSignUpEventToAccess(event);
    }
    if (event is SignInEvent) {
      yield* _mapSignInEventToAccess(event);
    }
  }

  Stream<AuthorizationState> _mapLoginFetchToLoginData(
      LoginFetch event) async* {
    yield LoginData(isLogin: true, isLoading: true);
    String _token = await _storage.read(key: HttpStrings.userAccessToken);
    if (_token != null ?? _token.isNotEmpty) {
      userBloc.add(UserFetch());
      yield LoginData(isLogin: true, isLoading: false);
    } else {
      yield AuthorizationInitial();
    }
  }

  Stream<AuthorizationState> _mapSignUpEventToAccess(SignUpEvent event) async* {
    try {
      yield LoadingAuthorization();
      user = UserModel(
          username: event.name,
          birthday: event.birthday,
          email: event.email,
          phone: event.phone,
          password: event.password,
          roles: [AppStrings.roleUser]);
      await userGateway.registration(user);
      await oauthGateway.authorization(event.name, event.password);
      userBloc.add(UserFetch());
      yield AccessAuthorization();
    } on DioError catch (err) {
      if (err?.response?.statusCode == 400) {
        yield ErrorAuthorization(jsonDecode(err?.response?.data)['detail']);
      } else {
        yield ErrorAuthorization(AppStrings.noInternet);
      }
    }
  }

  Stream<AuthorizationState> _mapSignInEventToAccess(SignInEvent event) async* {
    try {
      yield LoadingAuthorization();
      await oauthGateway.authorization(event.name, event.password); //!!!
      userBloc.add(UserFetch());
      yield AccessAuthorization();
    } on DioError catch (err) {
      if (err?.response?.statusCode == 400) {
        yield ErrorAuthorization(err?.response?.data['error_description']);
      } else {
        yield ErrorAuthorization(AppStrings.noInternet);
      }
    }
  }
}
