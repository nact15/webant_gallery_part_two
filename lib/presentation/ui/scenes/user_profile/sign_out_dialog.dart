import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/user_bloc/user_bloc.dart';

showSignOutDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    child: Text("Cancel"),
    style: ElevatedButton.styleFrom(
      primary: AppColors.decorationColor,
    ),
    onPressed: () => Navigator.of(context).pop(),
  );
  Widget continueButton = ElevatedButton(
    child: Text("Yes"),
    style: ElevatedButton.styleFrom(
      primary: AppColors.mainColorAccent,
    ),
    onPressed: () {
      context.read<UserBloc>().add(LogOut());
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Sign out"),
    content: Text("Would you like to sign out?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}