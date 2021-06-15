import 'package:webant_gallery_part_two/domain/models/registration/user_model.dart';

abstract class RegistrationGateway{
  Future<void> registration (
      {String username,
      String password,
      String birthday,
      String email,
      String phone});
}