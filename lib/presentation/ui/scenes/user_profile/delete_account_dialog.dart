import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/user_bloc/user_bloc.dart';

showDeleteAccountDialog(BuildContext context, UserModel user) {

  Widget cancelButton = ElevatedButton(
    child: Text('Cancel'),
    style: ElevatedButton.styleFrom(
      primary: AppColors.decorationColor,
    ),
    onPressed: () => Navigator.of(context).pop(),
  );
  Widget continueButton = ElevatedButton(
    child: Text('Yes'),
    style: ElevatedButton.styleFrom(
      primary: AppColors.mainColorAccent,
    ),
    onPressed: () {
      context.read<UserBloc>().add(UserDelete(user));
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text('Delete account'),
    content: Text('Would you like to delete your account?'),
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