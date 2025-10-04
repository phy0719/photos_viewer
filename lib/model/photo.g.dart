// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      id: json['id'] as String,
      createdBy: json['createdBy'] as String,
      location: json['location'] as String,
      url: json['url'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      takenAt: DateTime.parse(json['takenAt'] as String),
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'id': instance.id,
      'createdBy': instance.createdBy,
      'location': instance.location,
      'url': instance.url,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'takenAt': instance.takenAt.toIso8601String(),
    };
