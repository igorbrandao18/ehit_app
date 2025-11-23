// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      venue: json['venue'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      date: json['date'] as String,
      formattedDate: json['formatted_date'] as String,
      locationTag: json['location_tag'] as String,
      cover: json['cover'] as String?,
      isFeatured: json['is_featured'] as bool,
      order: (json['order'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'venue': instance.venue,
      'city': instance.city,
      'state': instance.state,
      'date': instance.date,
      'formatted_date': instance.formattedDate,
      'location_tag': instance.locationTag,
      'cover': instance.cover,
      'is_featured': instance.isFeatured,
      'order': instance.order,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'is_active': instance.isActive,
    };
