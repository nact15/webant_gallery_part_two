import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/data/repositories/http_oauth_gateway.dart';
import 'package:webant_gallery_part_two/data/repositories/http_search_photo.dart';
import 'package:webant_gallery_part_two/data/repositories/http_search_photo_by_user.dart';
import 'package:webant_gallery_part_two/data/repositories/http_user_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/base_model/base_model.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/oauth_gateway.dart';
import 'package:webant_gallery_part_two/domain/repositories/search_photo_gateway.dart';
import 'package:webant_gallery_part_two/domain/repositories/user_gateway.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/search_photo/search_photo_bloc/search_photo_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc<T> extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial());
  final _storage = Storage.FlutterSecureStorage();
  UserGateway userGateway = HttpUserGateway();
  OauthGateway oauthGateway = HttpOauthGateway();
  SearchPhotoGateway photoGateway = HttpSearchPhotoByUserGateway();
  UserModel user;
  List<PhotoModel> photos = [];
  BaseModel<T> baseModel;
  bool isUpdate = false;

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is LogOut) {
      yield* _mapLogOutToExit(event);
    }
    if (event is UserFetch) {
      yield* _mapUserFetchToUserData(event);
    }
    if (event is UpdateUser) {
      yield* _mapUpdateUserToUserFetch(event);
    }
    if (event is UpdatePassword) {
      yield* _mapUpdatePasswordToUserFetch(event);
    }
    if (event is UserDelete) {
      _mapUserDeleteToExit(event);
    }
  }

  Stream<UserState> _mapLogOutToExit(LogOut event) async* {
    yield LoadingUpdate();
    await _storage.deleteAll();
    Hive.box('new').clear();
    Hive.box('popular').clear();
    yield Exit();
  }

  Stream<UserState> _mapUserFetchToUserData(UserFetch event) async* {
    try {
      yield LoadingUpdate();
      user = await oauthGateway.getUser();
      baseModel = await photoGateway.fetchPhotos(queryText: user.id);
      photos = baseModel.data as List<PhotoModel>;
      int countOfPhotos = baseModel.totalItems;
      yield UserData(user, photos, countOfPhotos, isUpdate);
    } on DioError{
      yield ErrorData();
    }
  }

  Stream<UserState> _mapUpdateUserToUserFetch(UpdateUser event) async* {
    try {
      yield LoadingUpdate();
      await userGateway.updateUser(event.user);
      isUpdate = true;
      add(UserFetch());
      isUpdate = false;
    } on DioError{
      yield ErrorUpdate(AppStrings.error);
    }
  }

  Stream<UserState> _mapUpdatePasswordToUserFetch(UpdatePassword event) async* {
    yield LoadingUpdate();
    try {
      await userGateway.updatePasswordUser(
          event.user, event.oldPassword, event.newPassword);
      add(UserFetch());
    } on DioError catch (err) {
      isUpdate = false;
      if (err?.response?.statusCode == 400) {
        yield ErrorUpdate(jsonDecode(err?.response?.data)['detail']);
      } else {
        yield ErrorUpdate(AppStrings.error);
      }
      add(UserFetch());
    }
  }

  Stream<UserState> _mapUserDeleteToExit(UserDelete event) async* {
    yield LoadingUpdate();
    await _storage.deleteAll();
    Hive.box('new').clear();
    Hive.box('popular').clear();
    await userGateway.deleteUser(event.user);
    yield Exit();
  }
}
