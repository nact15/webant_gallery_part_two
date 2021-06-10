import 'package:dio/dio.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';

class HttpRegistrationGateway {
  HttpRegistrationGateway();

  Dio dio = Dio();

  // ignore: missing_return
  Future<void> registration(
      {String username,
      String password,
      String birthday,
      String email,
      String phone}) async {
    try {
      print(birthday);
      Response response = await dio.post(AppStrings.urlUsers, data: {
        AppStrings.username: username,
        'email': email,
        AppStrings.password: password,
        'birthday': birthday,
        'phone': phone,
        'fullName': username,
      });

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
