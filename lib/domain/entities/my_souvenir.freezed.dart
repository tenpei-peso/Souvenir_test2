// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_souvenir.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MySouvenir _$MySouvenirFromJson(Map<String, dynamic> json) {
  return _MySouvenir.fromJson(json);
}

/// @nodoc
mixin _$MySouvenir {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @SouvenirCategoryConverter()
  SouvenirCategory get category => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get purchaseLocation => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MySouvenir to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MySouvenir
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MySouvenirCopyWith<MySouvenir> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MySouvenirCopyWith<$Res> {
  factory $MySouvenirCopyWith(
    MySouvenir value,
    $Res Function(MySouvenir) then,
  ) = _$MySouvenirCopyWithImpl<$Res, MySouvenir>;
  @useResult
  $Res call({
    String id,
    String name,
    @SouvenirCategoryConverter() SouvenirCategory category,
    String description,
    int price,
    List<String> imageUrls,
    List<String> tags,
    String? purchaseLocation,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$MySouvenirCopyWithImpl<$Res, $Val extends MySouvenir>
    implements $MySouvenirCopyWith<$Res> {
  _$MySouvenirCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MySouvenir
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? description = null,
    Object? price = null,
    Object? imageUrls = null,
    Object? tags = null,
    Object? purchaseLocation = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as SouvenirCategory,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
            imageUrls: null == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            purchaseLocation: freezed == purchaseLocation
                ? _value.purchaseLocation
                : purchaseLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MySouvenirImplCopyWith<$Res>
    implements $MySouvenirCopyWith<$Res> {
  factory _$$MySouvenirImplCopyWith(
    _$MySouvenirImpl value,
    $Res Function(_$MySouvenirImpl) then,
  ) = __$$MySouvenirImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    @SouvenirCategoryConverter() SouvenirCategory category,
    String description,
    int price,
    List<String> imageUrls,
    List<String> tags,
    String? purchaseLocation,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$MySouvenirImplCopyWithImpl<$Res>
    extends _$MySouvenirCopyWithImpl<$Res, _$MySouvenirImpl>
    implements _$$MySouvenirImplCopyWith<$Res> {
  __$$MySouvenirImplCopyWithImpl(
    _$MySouvenirImpl _value,
    $Res Function(_$MySouvenirImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MySouvenir
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? description = null,
    Object? price = null,
    Object? imageUrls = null,
    Object? tags = null,
    Object? purchaseLocation = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MySouvenirImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as SouvenirCategory,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        imageUrls: null == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        purchaseLocation: freezed == purchaseLocation
            ? _value.purchaseLocation
            : purchaseLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MySouvenirImpl extends _MySouvenir {
  const _$MySouvenirImpl({
    required this.id,
    required this.name,
    @SouvenirCategoryConverter() required this.category,
    required this.description,
    required this.price,
    final List<String> imageUrls = const <String>[],
    final List<String> tags = const <String>[],
    this.purchaseLocation,
    required this.createdAt,
    required this.updatedAt,
  }) : _imageUrls = imageUrls,
       _tags = tags,
       super._();

  factory _$MySouvenirImpl.fromJson(Map<String, dynamic> json) =>
      _$$MySouvenirImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @SouvenirCategoryConverter()
  final SouvenirCategory category;
  @override
  final String description;
  @override
  final int price;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? purchaseLocation;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MySouvenir(id: $id, name: $name, category: $category, description: $description, price: $price, imageUrls: $imageUrls, tags: $tags, purchaseLocation: $purchaseLocation, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MySouvenirImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.purchaseLocation, purchaseLocation) ||
                other.purchaseLocation == purchaseLocation) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    category,
    description,
    price,
    const DeepCollectionEquality().hash(_imageUrls),
    const DeepCollectionEquality().hash(_tags),
    purchaseLocation,
    createdAt,
    updatedAt,
  );

  /// Create a copy of MySouvenir
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MySouvenirImplCopyWith<_$MySouvenirImpl> get copyWith =>
      __$$MySouvenirImplCopyWithImpl<_$MySouvenirImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MySouvenirImplToJson(this);
  }
}

abstract class _MySouvenir extends MySouvenir {
  const factory _MySouvenir({
    required final String id,
    required final String name,
    @SouvenirCategoryConverter() required final SouvenirCategory category,
    required final String description,
    required final int price,
    final List<String> imageUrls,
    final List<String> tags,
    final String? purchaseLocation,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$MySouvenirImpl;
  const _MySouvenir._() : super._();

  factory _MySouvenir.fromJson(Map<String, dynamic> json) =
      _$MySouvenirImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @SouvenirCategoryConverter()
  SouvenirCategory get category;
  @override
  String get description;
  @override
  int get price;
  @override
  List<String> get imageUrls;
  @override
  List<String> get tags;
  @override
  String? get purchaseLocation;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of MySouvenir
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MySouvenirImplCopyWith<_$MySouvenirImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
