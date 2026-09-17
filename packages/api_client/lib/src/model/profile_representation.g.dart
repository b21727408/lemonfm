// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_representation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProfileRepresentationKindEnum _$profileRepresentationKindEnum_PHOTO =
    const ProfileRepresentationKindEnum._('PHOTO');
const ProfileRepresentationKindEnum
_$profileRepresentationKindEnum_unknownDefaultOpenApi =
    const ProfileRepresentationKindEnum._('unknownDefaultOpenApi');

ProfileRepresentationKindEnum _$profileRepresentationKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'PHOTO':
      return _$profileRepresentationKindEnum_PHOTO;
    case 'unknownDefaultOpenApi':
      return _$profileRepresentationKindEnum_unknownDefaultOpenApi;
    default:
      return _$profileRepresentationKindEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<ProfileRepresentationKindEnum>
_$profileRepresentationKindEnumValues = BuiltSet<ProfileRepresentationKindEnum>(
  const <ProfileRepresentationKindEnum>[
    _$profileRepresentationKindEnum_PHOTO,
    _$profileRepresentationKindEnum_unknownDefaultOpenApi,
  ],
);

Serializer<ProfileRepresentationKindEnum>
_$profileRepresentationKindEnumSerializer =
    _$ProfileRepresentationKindEnumSerializer();

class _$ProfileRepresentationKindEnumSerializer
    implements PrimitiveSerializer<ProfileRepresentationKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PHOTO': 'PHOTO',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PHOTO': 'PHOTO',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[ProfileRepresentationKindEnum];
  @override
  final String wireName = 'ProfileRepresentationKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    ProfileRepresentationKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ProfileRepresentationKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ProfileRepresentationKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ProfileRepresentation extends ProfileRepresentation {
  @override
  final OneOf oneOf;

  factory _$ProfileRepresentation([
    void Function(ProfileRepresentationBuilder)? updates,
  ]) => (ProfileRepresentationBuilder()..update(updates))._build();

  _$ProfileRepresentation._({required this.oneOf}) : super._();
  @override
  ProfileRepresentation rebuild(
    void Function(ProfileRepresentationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProfileRepresentationBuilder toBuilder() =>
      ProfileRepresentationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileRepresentation && oneOf == other.oneOf;
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
      r'ProfileRepresentation',
    )..add('oneOf', oneOf)).toString();
  }
}

class ProfileRepresentationBuilder
    implements Builder<ProfileRepresentation, ProfileRepresentationBuilder> {
  _$ProfileRepresentation? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  ProfileRepresentationBuilder() {
    ProfileRepresentation._defaults(this);
  }

  ProfileRepresentationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileRepresentation other) {
    _$v = other as _$ProfileRepresentation;
  }

  @override
  void update(void Function(ProfileRepresentationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileRepresentation build() => _build();

  _$ProfileRepresentation _build() {
    final _$result =
        _$v ??
        _$ProfileRepresentation._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'ProfileRepresentation',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
