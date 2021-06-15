import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/data/repositories/http_oauth_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/registration/user_model.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());
  HttpOauthGateway httpOauthGateway = HttpOauthGateway();
  final _storage = Storage.FlutterSecureStorage();
  UserModel user;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginFetch) {
      yield LoginData(isLogin: false, isLoading: true);
      String _token = await _storage.read(key: 'USER_ACCESS_TOKEN');
      if (_token != null) {
        user = await httpOauthGateway.getUser();
        yield LoginData(isLogin: true, user: user, isLoading: false);
      } else {
        yield LoginData(isLogin: false, isLoading: false);
      }
    }
  }
}
