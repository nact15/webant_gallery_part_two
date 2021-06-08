// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) {
  return TokenModel(
    json['access_token'] as String,
    json['expires_in'] as int,
    json['token_type'] as String,
    json['scope'],
    json['refresh_token'] as String,
  );
}

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'token_type': instance.tokenType,
      'scope': instance.scope,
      'refresh_token': instance.refreshToken,
    };
