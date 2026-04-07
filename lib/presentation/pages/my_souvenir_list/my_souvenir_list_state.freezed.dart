// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_souvenir_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MySouvenirListState {
  List<MySouvenir> get souvenirs => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of MySouvenirListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MySouvenirListStateCopyWith<MySouvenirListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MySouvenirListStateCopyWith<$Res> {
  factory $MySouvenirListStateCopyWith(
    MySouvenirListState value,
    $Res Function(MySouvenirListState) then,
  ) = _$MySouvenirListStateCopyWithImpl<$Res, MySouvenirListState>;
  @useResult
  $Res call({List<MySouvenir> souvenirs, bool isLoading, String? error});
}

/// @nodoc
class _$MySouvenirListStateCopyWithImpl<$Res, $Val extends MySouvenirListState>
    implements $MySouvenirListStateCopyWith<$Res> {
  _$MySouvenirListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MySouvenirListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? souvenirs = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            souvenirs: null == souvenirs
                ? _value.souvenirs
                : souvenirs // ignore: cast_nullable_to_non_nullable
                      as List<MySouvenir>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MySouvenirListStateImplCopyWith<$Res>
    implements $MySouvenirListStateCopyWith<$Res> {
  factory _$$MySouvenirListStateImplCopyWith(
    _$MySouvenirListStateImpl value,
    $Res Function(_$MySouvenirListStateImpl) then,
  ) = __$$MySouvenirListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MySouvenir> souvenirs, bool isLoading, String? error});
}

/// @nodoc
class __$$MySouvenirListStateImplCopyWithImpl<$Res>
    extends _$MySouvenirListStateCopyWithImpl<$Res, _$MySouvenirListStateImpl>
    implements _$$MySouvenirListStateImplCopyWith<$Res> {
  __$$MySouvenirListStateImplCopyWithImpl(
    _$MySouvenirListStateImpl _value,
    $Res Function(_$MySouvenirListStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MySouvenirListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? souvenirs = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _$MySouvenirListStateImpl(
        souvenirs: null == souvenirs
            ? _value._souvenirs
            : souvenirs // ignore: cast_nullable_to_non_nullable
                  as List<MySouvenir>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$MySouvenirListStateImpl extends _MySouvenirListState {
  const _$MySouvenirListStateImpl({
    required final List<MySouvenir> souvenirs,
    this.isLoading = false,
    this.error,
  }) : _souvenirs = souvenirs,
       super._();

  final List<MySouvenir> _souvenirs;
  @override
  List<MySouvenir> get souvenirs {
    if (_souvenirs is EqualUnmodifiableListView) return _souvenirs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_souvenirs);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'MySouvenirListState(souvenirs: $souvenirs, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MySouvenirListStateImpl &&
            const DeepCollectionEquality().equals(
              other._souvenirs,
              _souvenirs,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_souvenirs),
    isLoading,
    error,
  );

  /// Create a copy of MySouvenirListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MySouvenirListStateImplCopyWith<_$MySouvenirListStateImpl> get copyWith =>
      __$$MySouvenirListStateImplCopyWithImpl<_$MySouvenirListStateImpl>(
        this,
        _$identity,
      );
}

abstract class _MySouvenirListState extends MySouvenirListState {
  const factory _MySouvenirListState({
    required final List<MySouvenir> souvenirs,
    final bool isLoading,
    final String? error,
  }) = _$MySouvenirListStateImpl;
  const _MySouvenirListState._() : super._();

  @override
  List<MySouvenir> get souvenirs;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of MySouvenirListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MySouvenirListStateImplCopyWith<_$MySouvenirListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
