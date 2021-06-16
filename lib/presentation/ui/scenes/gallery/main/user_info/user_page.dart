import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery_part_two/domain/models/registration/user_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/user_info/user_bloc/user_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/user_info/user_settings.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key key, this.user}) : super(key: key);
  final UserModel user;

  @override
  _UserPageState createState() => _UserPageState(user);
}

class _UserPageState extends State<UserPage> {
  _UserPageState(this.user);
  UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider<UserBloc>(
                    create: (BuildContext context) => UserBloc(),
                    child: UserSettings(user: user,),
                  ),
                ),
              );
            },
            alignment: Alignment.centerRight,
          ),
        ],
        elevation: 1,
      ),
      body: Container(
        height: 225,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: AppColors.mainColorAccent),
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Container(
                  child: Icon(
                    Icons.camera_alt,
                    size: 55,
                    color: AppColors.mainColorAccent,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.mainColorAccent),
                    borderRadius: BorderRadius.all(Radius.circular(90)),
                  ),
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  user.username,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  user.birthday,
                  style:
                  TextStyle(fontSize: 12, color: AppColors.mainColorAccent),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 27, 0, 0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('Loaded???'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
