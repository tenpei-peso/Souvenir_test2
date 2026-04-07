// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_souvenir.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MySouvenirImpl _$$MySouvenirImplFromJson(Map<String, dynamic> json) =>
    _$MySouvenirImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: const SouvenirCategoryConverter().fromJson(
        json['category'] as String,
      ),
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
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MySouvenirImplToJson(_$MySouvenirImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': const SouvenirCategoryConverter().toJson(instance.category),
      'description': instance.description,
      'price': instance.price,
      'imageUrls': instance.imageUrls,
      'tags': instance.tags,
      'purchaseLocation': instance.purchaseLocation,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
