import 'package:json_annotation/json_annotation.dart';

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
  final String? description;
  final Map<String, dynamic>? links;

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
    this.description,
    this.links,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return _$EventModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
