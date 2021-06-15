import 'package:webant_gallery_part_two/domain/models/registration/user_model.dart';

abstract class OauthGateway{
  Future<UserModel> authorization (String username, String password);
}