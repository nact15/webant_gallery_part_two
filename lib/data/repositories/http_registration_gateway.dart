import 'package:dio/dio.dart';
import 'package:webant_gallery_part_two/domain/models/registration/registration_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';


class HttpRegistrationGateway {
  HttpRegistrationGateway();
  Dio dio = Dio();

  // ignore: missing_return
  Future<void> registration(RegistrationModel registrationModel) async {
    try {
      final String url = AppStrings.urlUsers;
      Response response = await dio.post(url, data: registrationModel.toJson());
      final statusCode = response.statusCode;
      print(response.data);
      if (statusCode == 201) {
        print(statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
