import 'base_user_info.dart';

class SignInInfo implements BaseUserInformation{
  @override
  String email;

  @override
  String password;

  SignInInfo({this.email, this.password});

}