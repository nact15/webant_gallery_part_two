import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';

abstract class OauthGateway{
  Future<UserModel> authorization (String username, String password);
  Future<UserModel> getUser();
  Future<String> refreshToken ();
}