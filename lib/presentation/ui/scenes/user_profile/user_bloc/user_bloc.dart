import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/data/repositories/http_oauth_gateway.dart';
import 'package:webant_gallery_part_two/data/repositories/http_user_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/oauth_gateway.dart';
import 'package:webant_gallery_part_two/domain/repositories/user_gateway.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial());
  final _storage = Storage.FlutterSecureStorage();
  final UserGateway userGateway = HttpUserGateway();
  OauthGateway oauthGateway = HttpOauthGateway();
  UserModel user;

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is LogOut) {
      await _storage.deleteAll();
      yield Exit();
    }
    if (event is UserFetch){
      user = await oauthGateway.getUser();
      yield UserData(user);
    }
    if (event is UpdateUser) {
      try{
        yield LoadingUpdate();
        await userGateway.updateUser(event.user);
        user = await oauthGateway.getUser();
        yield UserData(user);
      } on DioError{
        yield ErrorUpdate();
      }
    }
    if (event is UserDelete){
      await userGateway.deleteUser(event.user);
      await _storage.deleteAll();
      yield Exit();
    }
  }
}
