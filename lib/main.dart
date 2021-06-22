import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:webant_gallery_part_two/data/repositories/http_oauth_gateway.dart';
import 'package:webant_gallery_part_two/data/repositories/http_user_gateway.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/add_photo/add_photo_bloc/add_photo_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/authorization_bloc/authorization_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/welcome_screen.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/user_bloc/user_bloc.dart';

import 'domain/models/photos_model/image_model.dart';
import 'domain/models/photos_model/photo_model.dart';

GetIt getIt = GetIt.instance;
UserBloc userBloc = UserBloc();

Future<void> main() async {
  var path = Directory.systemTemp.path;
  Hive
    ..init(path)
    ..registerAdapter(ImageModelAdapter())
    ..registerAdapter(PhotoModelAdapter());
  await Hive.openBox('new');
  await Hive.openBox('popular');
  runZonedGuarded(() {
    runApp(MultiBlocProvider(providers: [
      BlocProvider(
          create: (BuildContext context) =>
              AuthorizationBloc(HttpOauthGateway(), HttpUserGateway(), userBloc)
                ..add(LoginFetch())),
      BlocProvider(create: (BuildContext context) => AddPhotoBloc()),
      BlocProvider(create: (BuildContext context) => userBloc),
    ], child: WelcomeScreen()));
  }, (error, stackTrace) {});
}
