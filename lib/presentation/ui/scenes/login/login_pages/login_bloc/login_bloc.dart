import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/domain/models/registration/user_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/oauth_gateway.dart';
import 'package:webant_gallery_part_two/presentation/resources/http_strings.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.oauthGateway) : super(LoginInitial());
  final OauthGateway oauthGateway;
  final _storage = Storage.FlutterSecureStorage();
  UserModel user;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginFetch) {
      yield LoginData(isLogin: false, isLoading: true);
      String _token = await _storage.read(key: HttpStrings.userAccessToken);
      if (_token != null) {
        user = await oauthGateway.getUser();
        GetIt.I.registerSingleton<UserModel>(user, signalsReady: true);
        yield LoginData(isLogin: true, isLoading: false);
      } else {
        yield LoginData(isLogin: false, isLoading: false);
      }
    }
  }
}
