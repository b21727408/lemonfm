// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_representation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PhotoRepresentationKindEnum _$photoRepresentationKindEnum_PHOTO =
    const PhotoRepresentationKindEnum._('PHOTO');
const PhotoRepresentationKindEnum
_$photoRepresentationKindEnum_unknownDefaultOpenApi =
    const PhotoRepresentationKindEnum._('unknownDefaultOpenApi');

PhotoRepresentationKindEnum _$photoRepresentationKindEnumValueOf(String name) {
  switch (name) {
    case 'PHOTO':
      return _$photoRepresentationKindEnum_PHOTO;
    case 'unknownDefaultOpenApi':
      return _$photoRepresentationKindEnum_unknownDefaultOpenApi;
    default:
      return _$photoRepresentationKindEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<PhotoRepresentationKindEnum>
_$photoRepresentationKindEnumValues =
    BuiltSet<PhotoRepresentationKindEnum>(const <PhotoRepresentationKindEnum>[
      _$photoRepresentationKindEnum_PHOTO,
      _$photoRepresentationKindEnum_unknownDefaultOpenApi,
    ]);

Serializer<PhotoRepresentationKindEnum>
_$photoRepresentationKindEnumSerializer =
    _$PhotoRepresentationKindEnumSerializer();

class _$PhotoRepresentationKindEnumSerializer
    implements PrimitiveSerializer<PhotoRepresentationKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PHOTO': 'PHOTO',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PHOTO': 'PHOTO',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[PhotoRepresentationKindEnum];
  @override
  final String wireName = 'PhotoRepresentationKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    PhotoRepresentationKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  PhotoRepresentationKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => PhotoRepresentationKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$PhotoRepresentation extends PhotoRepresentation {
  @override
  final PhotoRepresentationKindEnum kind;
  @override
  final String mediaId;

  factory _$PhotoRepresentation([
    void Function(PhotoRepresentationBuilder)? updates,
  ]) => (PhotoRepresentationBuilder()..update(updates))._build();

  _$PhotoRepresentation._({required this.kind, required this.mediaId})
    : super._();
  @override
  PhotoRepresentation rebuild(
    void Function(PhotoRepresentationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PhotoRepresentationBuilder toBuilder() =>
      PhotoRepresentationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PhotoRepresentation &&
        kind == other.kind &&
        mediaId == other.mediaId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, mediaId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PhotoRepresentation')
          ..add('kind', kind)
          ..add('mediaId', mediaId))
        .toString();
  }
}

class PhotoRepresentationBuilder
    implements Builder<PhotoRepresentation, PhotoRepresentationBuilder> {
  _$PhotoRepresentation? _$v;

  PhotoRepresentationKindEnum? _kind;
  PhotoRepresentationKindEnum? get kind => _$this._kind;
  set kind(PhotoRepresentationKindEnum? kind) => _$this._kind = kind;

  String? _mediaId;
  String? get mediaId => _$this._mediaId;
  set mediaId(String? mediaId) => _$this._mediaId = mediaId;

  PhotoRepresentationBuilder() {
    PhotoRepresentation._defaults(this);
  }

  PhotoRepresentationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _mediaId = $v.mediaId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PhotoRepresentation other) {
    _$v = other as _$PhotoRepresentation;
  }

  @override
  void update(void Function(PhotoRepresentationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PhotoRepresentation build() => _build();

  _$PhotoRepresentation _build() {
    final _$result =
        _$v ??
        _$PhotoRepresentation._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'PhotoRepresentation',
            'kind',
          ),
          mediaId: BuiltValueNullFieldError.checkNotNull(
            mediaId,
            r'PhotoRepresentation',
            'mediaId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
