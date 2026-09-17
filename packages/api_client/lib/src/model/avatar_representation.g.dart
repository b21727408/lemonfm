// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_representation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AvatarRepresentationKindEnum _$avatarRepresentationKindEnum_AVATAR =
    const AvatarRepresentationKindEnum._('AVATAR');
const AvatarRepresentationKindEnum
_$avatarRepresentationKindEnum_unknownDefaultOpenApi =
    const AvatarRepresentationKindEnum._('unknownDefaultOpenApi');

AvatarRepresentationKindEnum _$avatarRepresentationKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'AVATAR':
      return _$avatarRepresentationKindEnum_AVATAR;
    case 'unknownDefaultOpenApi':
      return _$avatarRepresentationKindEnum_unknownDefaultOpenApi;
    default:
      return _$avatarRepresentationKindEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<AvatarRepresentationKindEnum>
_$avatarRepresentationKindEnumValues =
    BuiltSet<AvatarRepresentationKindEnum>(const <AvatarRepresentationKindEnum>[
      _$avatarRepresentationKindEnum_AVATAR,
      _$avatarRepresentationKindEnum_unknownDefaultOpenApi,
    ]);

Serializer<AvatarRepresentationKindEnum>
_$avatarRepresentationKindEnumSerializer =
    _$AvatarRepresentationKindEnumSerializer();

class _$AvatarRepresentationKindEnumSerializer
    implements PrimitiveSerializer<AvatarRepresentationKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVATAR': 'AVATAR',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVATAR': 'AVATAR',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[AvatarRepresentationKindEnum];
  @override
  final String wireName = 'AvatarRepresentationKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AvatarRepresentationKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AvatarRepresentationKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AvatarRepresentationKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AvatarRepresentation extends AvatarRepresentation {
  @override
  final AvatarRepresentationKindEnum kind;
  @override
  final String avatarId;

  factory _$AvatarRepresentation([
    void Function(AvatarRepresentationBuilder)? updates,
  ]) => (AvatarRepresentationBuilder()..update(updates))._build();

  _$AvatarRepresentation._({required this.kind, required this.avatarId})
    : super._();
  @override
  AvatarRepresentation rebuild(
    void Function(AvatarRepresentationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AvatarRepresentationBuilder toBuilder() =>
      AvatarRepresentationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AvatarRepresentation &&
        kind == other.kind &&
        avatarId == other.avatarId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, avatarId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AvatarRepresentation')
          ..add('kind', kind)
          ..add('avatarId', avatarId))
        .toString();
  }
}

class AvatarRepresentationBuilder
    implements Builder<AvatarRepresentation, AvatarRepresentationBuilder> {
  _$AvatarRepresentation? _$v;

  AvatarRepresentationKindEnum? _kind;
  AvatarRepresentationKindEnum? get kind => _$this._kind;
  set kind(AvatarRepresentationKindEnum? kind) => _$this._kind = kind;

  String? _avatarId;
  String? get avatarId => _$this._avatarId;
  set avatarId(String? avatarId) => _$this._avatarId = avatarId;

  AvatarRepresentationBuilder() {
    AvatarRepresentation._defaults(this);
  }

  AvatarRepresentationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _avatarId = $v.avatarId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AvatarRepresentation other) {
    _$v = other as _$AvatarRepresentation;
  }

  @override
  void update(void Function(AvatarRepresentationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AvatarRepresentation build() => _build();

  _$AvatarRepresentation _build() {
    final _$result =
        _$v ??
        _$AvatarRepresentation._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AvatarRepresentation',
            'kind',
          ),
          avatarId: BuiltValueNullFieldError.checkNotNull(
            avatarId,
            r'AvatarRepresentation',
            'avatarId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
