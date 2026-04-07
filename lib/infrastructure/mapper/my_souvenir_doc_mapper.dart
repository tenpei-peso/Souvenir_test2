import 'package:test2/domain/entities/my_souvenir.dart';
import 'package:test2/domain/entities/souvenir_category.dart';
import 'my_souvenir_doc.dart';

/// MySouvenirDoc -> MySouvenir Entity への変換 Extension
extension MySouvenirDocMapper on MySouvenirDoc {
  /// Firestore ドキュメントを Entity に変換
  MySouvenir toEntity(String id) {
    return MySouvenir(
      id: id,
      name: name,
      category: SouvenirCategory.fromString(category),
      description: description,
      price: price,
      imageUrls: imageUrls,
      tags: tags,
      purchaseLocation: purchaseLocation,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Entity を Firestore ドキュメント DTO に変換
  static MySouvenirDoc fromEntity(MySouvenir entity) {
    return MySouvenirDoc(
      name: entity.name,
      category: entity.category.value,
      description: entity.description,
      price: entity.price,
      imageUrls: entity.imageUrls,
      tags: entity.tags,
      purchaseLocation: entity.purchaseLocation,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
