import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:test2/domain/entities/my_souvenir.dart';
import 'package:test2/domain/repositories/my_souvenir_repository.dart';
import 'package:test2/util/app_exception.dart';
import '../mapper/my_souvenir_doc.dart';
import '../mapper/my_souvenir_doc_mapper.dart';

/// MySouvenirRepository の Firestore 実装
class MySouvenirRepositoryImpl implements MySouvenirRepository {
  MySouvenirRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;
  static const _souvenirCollection = 'my_souvenirs';

  /// ユーザーのお土産コレクション参照
  CollectionReference<MySouvenirDoc> _userSouvenirsCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection(_souvenirCollection)
        .withConverter<MySouvenirDoc>(
          fromFirestore: (snapshot, _) =>
              MySouvenirDoc.fromJson(snapshot.data() ?? {}),
          toFirestore: (doc, _) => doc.toJson(),
        );
  }

  @override
  Future<List<MySouvenir>> fetchAll(String userId) async {
    try {
      final snapshot = await _userSouvenirsCollection(
        userId,
      ).orderBy('createdAt', descending: true).get();
      return [for (final doc in snapshot.docs) doc.data().toEntity(doc.id)];
    } on FirebaseException catch (e, st) {
      throw FirestoreException(
        message: 'お土産一覧の取得に失敗しました',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<MySouvenir?> fetchById(String userId, String souvenirId) async {
    try {
      final doc = await _userSouvenirsCollection(userId).doc(souvenirId).get();
      if (!doc.exists) {
        return null;
      }
      return doc.data()?.toEntity(doc.id);
    } on FirebaseException catch (e, st) {
      throw FirestoreException(
        message: 'お土産の取得に失敗しました',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<MySouvenir> create(String userId, MySouvenir souvenir) async {
    try {
      final id = souvenir.id.isEmpty ? const Uuid().v4() : souvenir.id;
      final now = DateTime.now();
      final docToSave = MySouvenirDoc(
        name: souvenir.name,
        category: souvenir.category.value,
        description: souvenir.description,
        price: souvenir.price,
        imageUrls: souvenir.imageUrls,
        tags: souvenir.tags,
        purchaseLocation: souvenir.purchaseLocation,
        createdAt: now,
        updatedAt: now,
      );

      await _userSouvenirsCollection(userId).doc(id).set(docToSave);
      return souvenir.copyWith(id: id, createdAt: now, updatedAt: now);
    } on FirebaseException catch (e, st) {
      throw FirestoreException(
        message: 'お土産の作成に失敗しました',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> update(String userId, MySouvenir souvenir) async {
    try {
      final docToSave = MySouvenirDocMapper.fromEntity(
        souvenir,
      ).copyWith(updatedAt: DateTime.now());
      await _userSouvenirsCollection(
        userId,
      ).doc(souvenir.id).update(docToSave.toJson());
    } on FirebaseException catch (e, st) {
      throw FirestoreException(
        message: 'お土産の更新に失敗しました',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> delete(String userId, String souvenirId) async {
    try {
      await _userSouvenirsCollection(userId).doc(souvenirId).delete();
    } on FirebaseException catch (e, st) {
      throw FirestoreException(
        message: 'お土産の削除に失敗しました',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  @override
  Stream<List<MySouvenir>> watchAll(String userId) {
    try {
      return _userSouvenirsCollection(userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => [
              for (final doc in snapshot.docs) doc.data().toEntity(doc.id),
            ],
          )
          .handleError((e, st) {
            throw FirestoreException(
              message: 'お土産の監視に失敗しました',
              originalError: e,
              stackTrace: st,
            );
          });
    } catch (e, st) {
      throw FirestoreException(
        message: 'お土産の監視に失敗しました',
        originalError: e,
        stackTrace: st,
      );
    }
  }
}

extension _MySouvenirDocCopyWith on MySouvenirDoc {
  MySouvenirDoc copyWith({
    String? name,
    String? category,
    String? description,
    int? price,
    List<String>? imageUrls,
    List<String>? tags,
    String? purchaseLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MySouvenirDoc(
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrls: imageUrls ?? this.imageUrls,
      tags: tags ?? this.tags,
      purchaseLocation: purchaseLocation ?? this.purchaseLocation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
