import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {
  final String id, createdBy, location, url;
  final String? description;
  final DateTime createdAt, takenAt;

  Photo({required this.id, required this.createdBy, required this.location, required this.url, this.description,
    required this.createdAt, required this.takenAt});

  /// Connect the generated [_$PhotoFromJson] function to the `fromJson`
  /// factory.
  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  /// Connect the generated [_$PhotosToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
