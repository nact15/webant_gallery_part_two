import 'package:dio/dio.dart';
import 'package:webant_gallery_part_two/domain/repositories/registration_gateway.dart';
import 'package:webant_gallery_part_two/presentation/resources/http_strings.dart';

class HttpRegistrationGateway extends RegistrationGateway{
  HttpRegistrationGateway();

  Dio dio = Dio();
@override
  Future<void> registration(
      {String username,
      String password,
      String birthday,
      String email,
      String phone}) async {
    try {
      Response response = await dio.post(HttpStrings.urlUsers, data: {
        HttpStrings.username: username,
        'email': email,
        HttpStrings.password: password,
        'birthday': birthday,
        'phone': phone,
        'fullName': username,
      }
      );

      final statusCode = response.statusCode;
      print(response.data);

      print(response.statusMessage);
      if (statusCode == 200) {
        print(response.statusMessage);
      }
    } catch (e) {
      rethrow;
    }
  }
}
