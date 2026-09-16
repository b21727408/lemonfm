// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_photo_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProfilePhotoChangeKindEnum _$profilePhotoChangeKindEnum_PHOTO =
    const ProfilePhotoChangeKindEnum._('PHOTO');
const ProfilePhotoChangeKindEnum
_$profilePhotoChangeKindEnum_unknownDefaultOpenApi =
    const ProfilePhotoChangeKindEnum._('unknownDefaultOpenApi');

ProfilePhotoChangeKindEnum _$profilePhotoChangeKindEnumValueOf(String name) {
  switch (name) {
    case 'PHOTO':
      return _$profilePhotoChangeKindEnum_PHOTO;
    case 'unknownDefaultOpenApi':
      return _$profilePhotoChangeKindEnum_unknownDefaultOpenApi;
    default:
      return _$profilePhotoChangeKindEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<ProfilePhotoChangeKindEnum> _$profilePhotoChangeKindEnumValues =
    BuiltSet<ProfilePhotoChangeKindEnum>(const <ProfilePhotoChangeKindEnum>[
      _$profilePhotoChangeKindEnum_PHOTO,
      _$profilePhotoChangeKindEnum_unknownDefaultOpenApi,
    ]);

Serializer<ProfilePhotoChangeKindEnum> _$profilePhotoChangeKindEnumSerializer =
    _$ProfilePhotoChangeKindEnumSerializer();

class _$ProfilePhotoChangeKindEnumSerializer
    implements PrimitiveSerializer<ProfilePhotoChangeKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PHOTO': 'PHOTO',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PHOTO': 'PHOTO',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[ProfilePhotoChangeKindEnum];
  @override
  final String wireName = 'ProfilePhotoChangeKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    ProfilePhotoChangeKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ProfilePhotoChangeKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ProfilePhotoChangeKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ProfilePhotoChange extends ProfilePhotoChange {
  @override
  final ProfilePhotoChangeKindEnum kind;
  @override
  final String mediaId;

  factory _$ProfilePhotoChange([
    void Function(ProfilePhotoChangeBuilder)? updates,
  ]) => (ProfilePhotoChangeBuilder()..update(updates))._build();

  _$ProfilePhotoChange._({required this.kind, required this.mediaId})
    : super._();
  @override
  ProfilePhotoChange rebuild(
    void Function(ProfilePhotoChangeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProfilePhotoChangeBuilder toBuilder() =>
      ProfilePhotoChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfilePhotoChange &&
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
    return (newBuiltValueToStringHelper(r'ProfilePhotoChange')
          ..add('kind', kind)
          ..add('mediaId', mediaId))
        .toString();
  }
}

class ProfilePhotoChangeBuilder
    implements Builder<ProfilePhotoChange, ProfilePhotoChangeBuilder> {
  _$ProfilePhotoChange? _$v;

  ProfilePhotoChangeKindEnum? _kind;
  ProfilePhotoChangeKindEnum? get kind => _$this._kind;
  set kind(ProfilePhotoChangeKindEnum? kind) => _$this._kind = kind;

  String? _mediaId;
  String? get mediaId => _$this._mediaId;
  set mediaId(String? mediaId) => _$this._mediaId = mediaId;

  ProfilePhotoChangeBuilder() {
    ProfilePhotoChange._defaults(this);
  }

  ProfilePhotoChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _mediaId = $v.mediaId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfilePhotoChange other) {
    _$v = other as _$ProfilePhotoChange;
  }

  @override
  void update(void Function(ProfilePhotoChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfilePhotoChange build() => _build();

  _$ProfilePhotoChange _build() {
    final _$result =
        _$v ??
        _$ProfilePhotoChange._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'ProfilePhotoChange',
            'kind',
          ),
          mediaId: BuiltValueNullFieldError.checkNotNull(
            mediaId,
            r'ProfilePhotoChange',
            'mediaId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
