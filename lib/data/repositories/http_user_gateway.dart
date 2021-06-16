import 'package:dio/dio.dart';
import 'package:webant_gallery_part_two/domain/models/registration/user_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/user_gateway.dart';
import 'package:webant_gallery_part_two/presentation/resources/http_strings.dart';

class HttpRegistrationGateway extends UserGateway{
  HttpRegistrationGateway();

  Dio dio = Dio()..interceptors.add(LogInterceptor(
    responseBody: true,requestBody: true, error: true
  ));
 @override
  Future<void> registration(UserModel userModel) async {
    try {
      await dio.post(HttpStrings.urlUsers, data: userModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(UserModel userModel) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<void> updatePasswordUser(UserModel userModel) {
    // TODO: implement updatePasswordUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(UserModel userModel) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
