// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_representation_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProfileRepresentationChangeKindEnum
_$profileRepresentationChangeKindEnum_PHOTO =
    const ProfileRepresentationChangeKindEnum._('PHOTO');
const ProfileRepresentationChangeKindEnum
_$profileRepresentationChangeKindEnum_unknownDefaultOpenApi =
    const ProfileRepresentationChangeKindEnum._('unknownDefaultOpenApi');

ProfileRepresentationChangeKindEnum
_$profileRepresentationChangeKindEnumValueOf(String name) {
  switch (name) {
    case 'PHOTO':
      return _$profileRepresentationChangeKindEnum_PHOTO;
    case 'unknownDefaultOpenApi':
      return _$profileRepresentationChangeKindEnum_unknownDefaultOpenApi;
    default:
      return _$profileRepresentationChangeKindEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<ProfileRepresentationChangeKindEnum>
_$profileRepresentationChangeKindEnumValues =
    BuiltSet<ProfileRepresentationChangeKindEnum>(
      const <ProfileRepresentationChangeKindEnum>[
        _$profileRepresentationChangeKindEnum_PHOTO,
        _$profileRepresentationChangeKindEnum_unknownDefaultOpenApi,
      ],
    );

Serializer<ProfileRepresentationChangeKindEnum>
_$profileRepresentationChangeKindEnumSerializer =
    _$ProfileRepresentationChangeKindEnumSerializer();

class _$ProfileRepresentationChangeKindEnumSerializer
    implements PrimitiveSerializer<ProfileRepresentationChangeKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PHOTO': 'PHOTO',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PHOTO': 'PHOTO',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProfileRepresentationChangeKindEnum,
  ];
  @override
  final String wireName = 'ProfileRepresentationChangeKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    ProfileRepresentationChangeKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ProfileRepresentationChangeKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ProfileRepresentationChangeKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ProfileRepresentationChange extends ProfileRepresentationChange {
  @override
  final OneOf oneOf;

  factory _$ProfileRepresentationChange([
    void Function(ProfileRepresentationChangeBuilder)? updates,
  ]) => (ProfileRepresentationChangeBuilder()..update(updates))._build();

  _$ProfileRepresentationChange._({required this.oneOf}) : super._();
  @override
  ProfileRepresentationChange rebuild(
    void Function(ProfileRepresentationChangeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProfileRepresentationChangeBuilder toBuilder() =>
      ProfileRepresentationChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileRepresentationChange && oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ProfileRepresentationChange',
    )..add('oneOf', oneOf)).toString();
  }
}

class ProfileRepresentationChangeBuilder
    implements
        Builder<
          ProfileRepresentationChange,
          ProfileRepresentationChangeBuilder
        > {
  _$ProfileRepresentationChange? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  ProfileRepresentationChangeBuilder() {
    ProfileRepresentationChange._defaults(this);
  }

  ProfileRepresentationChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileRepresentationChange other) {
    _$v = other as _$ProfileRepresentationChange;
  }

  @override
  void update(void Function(ProfileRepresentationChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileRepresentationChange build() => _build();

  _$ProfileRepresentationChange _build() {
    final _$result =
        _$v ??
        _$ProfileRepresentationChange._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'ProfileRepresentationChange',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
