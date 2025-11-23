import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  final int id;
  final String name;
  final String venue;
  final String city;
  final String state;
  final String date;
  @JsonKey(name: 'formatted_date')
  final String formattedDate;
  @JsonKey(name: 'location_tag')
  final String locationTag;
  final String? photo;
  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  final int order;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'is_active')
  final bool isActive;

  EventModel({
    required this.id,
    required this.name,
    required this.venue,
    required this.city,
    required this.state,
    required this.date,
    required this.formattedDate,
    required this.locationTag,
    this.photo,
    required this.isFeatured,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final photoValue = json['photo'] ?? json['cover'];
    String? photoUrl;
    
    if (photoValue != null) {
      if (photoValue is String) {
        photoUrl = photoValue.trim();
        if (photoUrl.isEmpty) {
          photoUrl = null;
        }
      } else if (photoValue is int) {
        photoUrl = photoValue.toString();
      }
    }
    
    return EventModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      venue: json['venue'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      date: json['date'] as String,
      formattedDate: json['formatted_date'] as String,
      locationTag: json['location_tag'] as String,
      photo: photoUrl,
      isFeatured: json['is_featured'] as bool,
      order: (json['order'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}

