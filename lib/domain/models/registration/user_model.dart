import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {

   int id;
   String email;
   bool enabled;
   String phone;
   String fullName;
   String username;
   String birthday;
   List<String> roles;

  UserModel(
      {this.id,
      this.email,
      this.enabled,
      this.phone,
      this.fullName,
      this.username,
      this.birthday,
      this.roles});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String toJsonPost(UserModel data){
    final jdata = data.toJson();
    return json.encode(jdata);
  }
}