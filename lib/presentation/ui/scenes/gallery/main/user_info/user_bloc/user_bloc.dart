import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/domain/models/registration/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this.user) : super(UserInitial());
  final UserModel user;
  final _storage = Storage.FlutterSecureStorage();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is LogOut) {
      await _storage.deleteAll();
      yield Exit();
    }
    if (event is UpdateUser) {
      //password, email, name and birthday
    }
  }
}
