import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/enter_bloc/authorization_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/login_bloc/login_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/welcome_screen.dart';

import 'domain/models/photos_model/image_model.dart';
import 'domain/models/photos_model/photo_model.dart';

Future<void> main() async {
  var path = Directory.systemTemp.path;
  Hive
    ..init(path)
    ..registerAdapter(ImageModelAdapter())..registerAdapter(
      PhotoModelAdapter());
  await Hive.openBox('new');
  await Hive.openBox('popular');
  runZonedGuarded(() {
    runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => LoginBloc()..add(LoginFetch())),
        BlocProvider(create: (BuildContext context) => AuthorizationBloc())
        ],
        child: WelcomeScreen()));
    }, (error, stackTrace) {});
}
