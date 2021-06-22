import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';

abstract class UserGateway{
  Future<void> registration (UserModel userModel);
  Future<void> updateUser(UserModel userModel);
  Future<void> updatePasswordUser(UserModel userModel, String oldPassword, String newPassword);
  Future<void> deleteUser(UserModel userModel);
}