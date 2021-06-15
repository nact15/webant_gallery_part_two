import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/gallery.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/login/login_pages/login_bloc/login_bloc.dart';

import 'enter_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: AppColors.colorGreyAccent,
        fontFamily: 'Roboto',
      ),
      title: AppStrings.titleGallery,
      home: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginData) {
            if (state.isLoading) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        color: AppColors.mainColorAccent,
                        strokeWidth: 2.0,
                      ),
                      Text(
                        'Loading...',
                        style: TextStyle(color: AppColors.mainColorAccent),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (!state.isLogin) {
              return EnterPage();
            }
            if (state.isLogin) {
              return Gallery(
                user: state.user,
              );
            }
          }
          return Text('Error');
        },
      ),
    );
  }
}
