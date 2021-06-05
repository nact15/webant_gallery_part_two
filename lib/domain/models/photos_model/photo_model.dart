import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';

import 'image_model.dart';

part 'photo_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 0)
class PhotoModel {

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  @JsonKey(name: 'new')
  final bool newType;

  @HiveField(3)
  @JsonKey(name: 'popular')
  final bool popularType;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final ImageModel image;

  PhotoModel(
      {this.id,
      this.name,
      this.newType,
      this.popularType,
      this.description,
      this.image});

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoModelToJson(this);

  String getImage() {
    return AppStrings.urlMedia + this.image.name.toString();
  }

  bool isPhotoSVG() {
    return this.image?.name?.contains('.svg')??false;
  }

  List addToHive() {
    return [this.id, this.name, this.description];
  }
}


