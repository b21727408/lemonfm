// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_change_nudge.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProfileChangeNudgeCodeEnum
_$profileChangeNudgeCodeEnum_CONTENT_NUDGE_REQUIRED =
    const ProfileChangeNudgeCodeEnum._('CONTENT_NUDGE_REQUIRED');
const ProfileChangeNudgeCodeEnum
_$profileChangeNudgeCodeEnum_unknownDefaultOpenApi =
    const ProfileChangeNudgeCodeEnum._('unknownDefaultOpenApi');

ProfileChangeNudgeCodeEnum _$profileChangeNudgeCodeEnumValueOf(String name) {
  switch (name) {
    case 'CONTENT_NUDGE_REQUIRED':
      return _$profileChangeNudgeCodeEnum_CONTENT_NUDGE_REQUIRED;
    case 'unknownDefaultOpenApi':
      return _$profileChangeNudgeCodeEnum_unknownDefaultOpenApi;
    default:
      return _$profileChangeNudgeCodeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<ProfileChangeNudgeCodeEnum> _$profileChangeNudgeCodeEnumValues =
    BuiltSet<ProfileChangeNudgeCodeEnum>(const <ProfileChangeNudgeCodeEnum>[
      _$profileChangeNudgeCodeEnum_CONTENT_NUDGE_REQUIRED,
      _$profileChangeNudgeCodeEnum_unknownDefaultOpenApi,
    ]);

const ProfileChangeNudgeFieldsEnum _$profileChangeNudgeFieldsEnum_nickname =
    const ProfileChangeNudgeFieldsEnum._('nickname');
const ProfileChangeNudgeFieldsEnum _$profileChangeNudgeFieldsEnum_bio =
    const ProfileChangeNudgeFieldsEnum._('bio');
const ProfileChangeNudgeFieldsEnum
_$profileChangeNudgeFieldsEnum_promptAnswers =
    const ProfileChangeNudgeFieldsEnum._('promptAnswers');
const ProfileChangeNudgeFieldsEnum
_$profileChangeNudgeFieldsEnum_unknownDefaultOpenApi =
    const ProfileChangeNudgeFieldsEnum._('unknownDefaultOpenApi');

ProfileChangeNudgeFieldsEnum _$profileChangeNudgeFieldsEnumValueOf(
  String name,
) {
  switch (name) {
    case 'nickname':
      return _$profileChangeNudgeFieldsEnum_nickname;
    case 'bio':
      return _$profileChangeNudgeFieldsEnum_bio;
    case 'promptAnswers':
      return _$profileChangeNudgeFieldsEnum_promptAnswers;
    case 'unknownDefaultOpenApi':
      return _$profileChangeNudgeFieldsEnum_unknownDefaultOpenApi;
    default:
      return _$profileChangeNudgeFieldsEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<ProfileChangeNudgeFieldsEnum>
_$profileChangeNudgeFieldsEnumValues =
    BuiltSet<ProfileChangeNudgeFieldsEnum>(const <ProfileChangeNudgeFieldsEnum>[
      _$profileChangeNudgeFieldsEnum_nickname,
      _$profileChangeNudgeFieldsEnum_bio,
      _$profileChangeNudgeFieldsEnum_promptAnswers,
      _$profileChangeNudgeFieldsEnum_unknownDefaultOpenApi,
    ]);

Serializer<ProfileChangeNudgeCodeEnum> _$profileChangeNudgeCodeEnumSerializer =
    _$ProfileChangeNudgeCodeEnumSerializer();
Serializer<ProfileChangeNudgeFieldsEnum>
_$profileChangeNudgeFieldsEnumSerializer =
    _$ProfileChangeNudgeFieldsEnumSerializer();

class _$ProfileChangeNudgeCodeEnumSerializer
    implements PrimitiveSerializer<ProfileChangeNudgeCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CONTENT_NUDGE_REQUIRED': 'CONTENT_NUDGE_REQUIRED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CONTENT_NUDGE_REQUIRED': 'CONTENT_NUDGE_REQUIRED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[ProfileChangeNudgeCodeEnum];
  @override
  final String wireName = 'ProfileChangeNudgeCodeEnum';

  @override
  Object serialize(
    Serializers serializers,
    ProfileChangeNudgeCodeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ProfileChangeNudgeCodeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ProfileChangeNudgeCodeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ProfileChangeNudgeFieldsEnumSerializer
    implements PrimitiveSerializer<ProfileChangeNudgeFieldsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'nickname': 'nickname',
    'bio': 'bio',
    'promptAnswers': 'promptAnswers',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'nickname': 'nickname',
    'bio': 'bio',
    'promptAnswers': 'promptAnswers',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[ProfileChangeNudgeFieldsEnum];
  @override
  final String wireName = 'ProfileChangeNudgeFieldsEnum';

  @override
  Object serialize(
    Serializers serializers,
    ProfileChangeNudgeFieldsEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ProfileChangeNudgeFieldsEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ProfileChangeNudgeFieldsEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ProfileChangeNudge extends ProfileChangeNudge {
  @override
  final ProfileChangeNudgeCodeEnum code;
  @override
  final String reasonCode;
  @override
  final String nudgeToken;
  @override
  final Optional<BuiltSet<ProfileChangeNudgeFieldsEnum>?> fields;

  factory _$ProfileChangeNudge([
    void Function(ProfileChangeNudgeBuilder)? updates,
  ]) => (ProfileChangeNudgeBuilder()..update(updates))._build();

  _$ProfileChangeNudge._({
    required this.code,
    required this.reasonCode,
    required this.nudgeToken,
    required this.fields,
  }) : super._();
  @override
  ProfileChangeNudge rebuild(
    void Function(ProfileChangeNudgeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProfileChangeNudgeBuilder toBuilder() =>
      ProfileChangeNudgeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileChangeNudge &&
        code == other.code &&
        reasonCode == other.reasonCode &&
        nudgeToken == other.nudgeToken &&
        fields == other.fields;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, nudgeToken.hashCode);
    _$hash = $jc(_$hash, fields.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileChangeNudge')
          ..add('code', code)
          ..add('reasonCode', reasonCode)
          ..add('nudgeToken', nudgeToken)
          ..add('fields', fields))
        .toString();
  }
}

class ProfileChangeNudgeBuilder
    implements Builder<ProfileChangeNudge, ProfileChangeNudgeBuilder> {
  _$ProfileChangeNudge? _$v;

  ProfileChangeNudgeCodeEnum? _code;
  ProfileChangeNudgeCodeEnum? get code => _$this._code;
  set code(ProfileChangeNudgeCodeEnum? code) => _$this._code = code;

  String? _reasonCode;
  String? get reasonCode => _$this._reasonCode;
  set reasonCode(String? reasonCode) => _$this._reasonCode = reasonCode;

  String? _nudgeToken;
  String? get nudgeToken => _$this._nudgeToken;
  set nudgeToken(String? nudgeToken) => _$this._nudgeToken = nudgeToken;

  Optional<BuiltSet<ProfileChangeNudgeFieldsEnum>?>? _fields;
  Optional<BuiltSet<ProfileChangeNudgeFieldsEnum>?>? get fields =>
      _$this._fields;
  set fields(Optional<BuiltSet<ProfileChangeNudgeFieldsEnum>?>? fields) =>
      _$this._fields = fields;

  ProfileChangeNudgeBuilder() {
    ProfileChangeNudge._defaults(this);
  }

  ProfileChangeNudgeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _reasonCode = $v.reasonCode;
      _nudgeToken = $v.nudgeToken;
      _fields = $v.fields;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileChangeNudge other) {
    _$v = other as _$ProfileChangeNudge;
  }

  @override
  void update(void Function(ProfileChangeNudgeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileChangeNudge build() => _build();

  _$ProfileChangeNudge _build() {
    final _$result =
        _$v ??
        _$ProfileChangeNudge._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'ProfileChangeNudge',
            'code',
          ),
          reasonCode: BuiltValueNullFieldError.checkNotNull(
            reasonCode,
            r'ProfileChangeNudge',
            'reasonCode',
          ),
          nudgeToken: BuiltValueNullFieldError.checkNotNull(
            nudgeToken,
            r'ProfileChangeNudge',
            'nudgeToken',
          ),
          fields: BuiltValueNullFieldError.checkNotNull(
            fields,
            r'ProfileChangeNudge',
            'fields',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
