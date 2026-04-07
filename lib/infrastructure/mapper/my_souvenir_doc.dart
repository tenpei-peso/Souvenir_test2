import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_souvenir_doc.g.dart';

/// Firestore ドキュメント用 MySouvenir DTO
@JsonSerializable(explicitToJson: true)
class MySouvenirDoc {
  MySouvenirDoc({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    this.imageUrls = const <String>[],
    this.tags = const <String>[],
    this.purchaseLocation,
    required this.createdAt,
    required this.updatedAt,
  });

  final String name;
  final String category;
  final String description;
  final int price;
  final List<String> imageUrls;
  final List<String> tags;
  final String? purchaseLocation;

  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime createdAt;

  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime updatedAt;

  /// Firestore Timestamp を DateTime に変換
  static DateTime _dateTimeFromTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    throw TypeError();
  }

  /// DateTime を Firestore Timestamp に変換
  static dynamic _dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  factory MySouvenirDoc.fromJson(Map<String, dynamic> json) =>
      _$MySouvenirDocFromJson(json);

  Map<String, dynamic> toJson() => _$MySouvenirDocToJson(this);
}
