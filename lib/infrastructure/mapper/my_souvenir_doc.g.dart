// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_souvenir_doc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MySouvenirDoc _$MySouvenirDocFromJson(Map<String, dynamic> json) =>
    MySouvenirDoc(
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      purchaseLocation: json['purchaseLocation'] as String?,
      createdAt: MySouvenirDoc._dateTimeFromTimestamp(json['createdAt']),
      updatedAt: MySouvenirDoc._dateTimeFromTimestamp(json['updatedAt']),
    );

Map<String, dynamic> _$MySouvenirDocToJson(MySouvenirDoc instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': instance.category,
      'description': instance.description,
      'price': instance.price,
      'imageUrls': instance.imageUrls,
      'tags': instance.tags,
      'purchaseLocation': instance.purchaseLocation,
      'createdAt': MySouvenirDoc._dateTimeToTimestamp(instance.createdAt),
      'updatedAt': MySouvenirDoc._dateTimeToTimestamp(instance.updatedAt),
    };
