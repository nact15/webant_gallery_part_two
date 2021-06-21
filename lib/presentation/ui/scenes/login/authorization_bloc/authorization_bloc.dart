import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/data/repositories/http_oauth_gateway.dart';
import 'package:webant_gallery_part_two/data/repositories/http_user_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/resources/http_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/user_bloc/user_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;

part 'authorization_event.dart';

part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  AuthorizationBloc(this.oauthGateway, this.userBloc)
      : super(AuthorizationInitial());
  final UserBloc userBloc;
  final HttpOauthGateway oauthGateway;
  HttpUserGateway httpRegistrationGateway = HttpUserGateway();
  UserModel user;
  final _storage = Storage.FlutterSecureStorage();

  @override
  Stream<AuthorizationState> mapEventToState(
    AuthorizationEvent event,
  ) async* {
    try {
      if (event is LoginFetch) {
        String _token = await _storage.read(key: HttpStrings.userAccessToken);
        if (_token != null ?? _token.isNotEmpty) {
          await oauthGateway.getUser();
          userBloc.add(UserFetch());
          yield LoginData(isLogin: true, isLoading: false);
        } else{
          yield LoginData(isLogin: false, isLoading: false);
        }
      }
      if (event is AuthorizationSignUpEvent) {
        yield LoadingAuthorization();
        user = UserModel(
            username: event.name,
            birthday: event.birthday,
            email: event.email,
            phone: event.phone,
            password: event.password,
            roles: [AppStrings.roleUser]);
        await httpRegistrationGateway.registration(user);
        await oauthGateway.authorization(event.name, event.password);
        userBloc.add(UserFetch());
        yield AccessAuthorization();
      }
      if (event is AuthorizationSignInEvent) {
        yield LoadingAuthorization();
        await oauthGateway.authorization(event.name, event.password);
        userBloc.add(UserFetch());
        yield AccessAuthorization();
      }
    } on DioError catch (err) {
      if (err?.response?.statusCode == 400) {
        if (err.requestOptions.method == 'POST') {
          yield ErrorAuthorization(jsonDecode(err?.response?.data)['detail']);
        } else
          yield ErrorAuthorization(err?.response?.data['error_description']);
      } else {
        yield ErrorAuthorization(AppStrings.noInternet);
      }
      yield AuthorizationInitial();
    }
  }
}
