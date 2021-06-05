import 'package:flutter/cupertino.dart';

import 'base_user_info.dart';

class SignUpInfo implements BaseUserInformation{

  String birthday;
  String name;

  @override
  String email;

  @override
  String password;

  SignUpInfo({this.birthday, this.name, this.email, this.password});

}