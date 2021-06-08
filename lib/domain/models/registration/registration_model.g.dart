// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationModel _$RegistrationModelFromJson(Map<String, dynamic> json) {
  return RegistrationModel(
    id: json['id'] as int,
    email: json['email'] as String,
    enabled: json['enabled'] as bool,
    phone: json['phone'] as String,
    fullName: json['fullName'] as String,
    username: json['username'] as String,
    birthday: json['birthday'] as String,
    roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$RegistrationModelToJson(RegistrationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'enabled': instance.enabled,
      'phone': instance.phone,
      'fullName': instance.fullName,
      'username': instance.username,
      'birthday': instance.birthday,
      'roles': instance.roles,
    };
