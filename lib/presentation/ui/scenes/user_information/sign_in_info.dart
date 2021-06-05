import 'package:webant_gallery_part_two/presentation/ui/scenes/user_information/base_user_info.dart';

class SignInInfo implements BaseUserInformation{
  @override
  String email;

  @override
  String password;

  SignInInfo({this.email, this.password});

}