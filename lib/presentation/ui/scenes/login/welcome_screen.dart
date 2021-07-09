import 'package:alice/alice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:webant_gallery_part_two/generated/l10n.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/gallery.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/loading_circular.dart';

import 'authorization_bloc/authorization_bloc.dart';
import 'enter_page.dart';

Alice alice = Alice(
    showNotification: true,
    darkTheme: true,
    maxCallsCount: 1000,
    showInspectorOnShake: true,
    notificationIcon: '@mipmap/ant',
);

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: alice.getNavigatorKey(),
      theme: ThemeData(
        accentColor: AppColors.colorGreyAccent,
      ),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'WebAnt Gallery',
      home: BlocBuilder<AuthorizationBloc, AuthorizationState>(
        builder: (context, state) {
          if (state is LoginData) {
            if (state.isLoading) {
              return Scaffold(
                body: LoadingCircular(),
              );
            }
            if (state.isLogin) {
              return Gallery();
            }
            if (!state.isLogin) {
              return EnterPage();
            }
          }
          if (state is AuthorizationInitial) {
            return Scaffold(
              body: LoadingCircular(),
            );
          }
          return Container();
        },
      ),
    );
  }
}
