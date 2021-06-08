import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'registration_model.g.dart';

@JsonSerializable()
class RegistrationModel {

   int id;
   String email;
   bool enabled;
   String phone;
   String fullName;
   String username;
   String birthday;
   List<String> roles;


  RegistrationModel(
      {this.id,
      this.email,
      this.enabled,
      this.phone,
      this.fullName,
      this.username,
      this.birthday,
      this.roles});

  factory RegistrationModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationModelToJson(this);

  String toJsonPost(RegistrationModel data){
    final jdata = data.toJson();
    return json.encode(jdata);
  }
}

//
// "id": 1,
// "email": "admin@mail.ru",
// "enabled": true,
// "phone": "299991",
// "fullName": "фцвфцвф",
// "username": "admin",
// "birthday": null,
// "roles": [
// "ROLE_ADMIN",
// "ROLE_USER"
// ]
// },