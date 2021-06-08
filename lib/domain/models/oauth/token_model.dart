import 'package:json_annotation/json_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable()
class TokenModel {

  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  @JsonKey(name: 'token_type')
  final String tokenType;

  final scope;

  @JsonKey(name: 'refresh_token')
   final String refreshToken;

  TokenModel(this.accessToken, this.expiresIn, this.tokenType, this.scope, this.refreshToken);

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}
