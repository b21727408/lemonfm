// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MyProfileReadinessEnum _$myProfileReadinessEnum_INCOMPLETE =
    const MyProfileReadinessEnum._('INCOMPLETE');
const MyProfileReadinessEnum _$myProfileReadinessEnum_READY =
    const MyProfileReadinessEnum._('READY');
const MyProfileReadinessEnum _$myProfileReadinessEnum_unknownDefaultOpenApi =
    const MyProfileReadinessEnum._('unknownDefaultOpenApi');

MyProfileReadinessEnum _$myProfileReadinessEnumValueOf(String name) {
  switch (name) {
    case 'INCOMPLETE':
      return _$myProfileReadinessEnum_INCOMPLETE;
    case 'READY':
      return _$myProfileReadinessEnum_READY;
    case 'unknownDefaultOpenApi':
      return _$myProfileReadinessEnum_unknownDefaultOpenApi;
    default:
      return _$myProfileReadinessEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<MyProfileReadinessEnum> _$myProfileReadinessEnumValues =
    BuiltSet<MyProfileReadinessEnum>(const <MyProfileReadinessEnum>[
      _$myProfileReadinessEnum_INCOMPLETE,
      _$myProfileReadinessEnum_READY,
      _$myProfileReadinessEnum_unknownDefaultOpenApi,
    ]);

Serializer<MyProfileReadinessEnum> _$myProfileReadinessEnumSerializer =
    _$MyProfileReadinessEnumSerializer();

class _$MyProfileReadinessEnumSerializer
    implements PrimitiveSerializer<MyProfileReadinessEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INCOMPLETE': 'INCOMPLETE',
    'READY': 'READY',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INCOMPLETE': 'INCOMPLETE',
    'READY': 'READY',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[MyProfileReadinessEnum];
  @override
  final String wireName = 'MyProfileReadinessEnum';

  @override
  Object serialize(
    Serializers serializers,
    MyProfileReadinessEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MyProfileReadinessEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => MyProfileReadinessEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$MyProfile extends MyProfile {
  @override
  final String revision;
  @override
  final MyProfileReadinessEnum readiness;
  @override
  final String? profileId;
  @override
  final String? nickname;
  @override
  final String? cityId;
  @override
  final ProfileRepresentation representation;
  @override
  final String? bio;
  @override
  final BuiltSet<String> interestIds;
  @override
  final BuiltList<ProfilePromptAnswersInner> promptAnswers;

  factory _$MyProfile([void Function(MyProfileBuilder)? updates]) =>
      (MyProfileBuilder()..update(updates))._build();

  _$MyProfile._({
    required this.revision,
    required this.readiness,
    this.profileId,
    this.nickname,
    this.cityId,
    required this.representation,
    this.bio,
    required this.interestIds,
    required this.promptAnswers,
  }) : super._();
  @override
  MyProfile rebuild(void Function(MyProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MyProfileBuilder toBuilder() => MyProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MyProfile &&
        revision == other.revision &&
        readiness == other.readiness &&
        profileId == other.profileId &&
        nickname == other.nickname &&
        cityId == other.cityId &&
        representation == other.representation &&
        bio == other.bio &&
        interestIds == other.interestIds &&
        promptAnswers == other.promptAnswers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, readiness.hashCode);
    _$hash = $jc(_$hash, profileId.hashCode);
    _$hash = $jc(_$hash, nickname.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, representation.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, interestIds.hashCode);
    _$hash = $jc(_$hash, promptAnswers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MyProfile')
          ..add('revision', revision)
          ..add('readiness', readiness)
          ..add('profileId', profileId)
          ..add('nickname', nickname)
          ..add('cityId', cityId)
          ..add('representation', representation)
          ..add('bio', bio)
          ..add('interestIds', interestIds)
          ..add('promptAnswers', promptAnswers))
        .toString();
  }
}

class MyProfileBuilder implements Builder<MyProfile, MyProfileBuilder> {
  _$MyProfile? _$v;

  String? _revision;
  String? get revision => _$this._revision;
  set revision(String? revision) => _$this._revision = revision;

  MyProfileReadinessEnum? _readiness;
  MyProfileReadinessEnum? get readiness => _$this._readiness;
  set readiness(MyProfileReadinessEnum? readiness) =>
      _$this._readiness = readiness;

  String? _profileId;
  String? get profileId => _$this._profileId;
  set profileId(String? profileId) => _$this._profileId = profileId;

  String? _nickname;
  String? get nickname => _$this._nickname;
  set nickname(String? nickname) => _$this._nickname = nickname;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  ProfileRepresentationBuilder? _representation;
  ProfileRepresentationBuilder get representation =>
      _$this._representation ??= ProfileRepresentationBuilder();
  set representation(ProfileRepresentationBuilder? representation) =>
      _$this._representation = representation;

  String? _bio;
  String? get bio => _$this._bio;
  set bio(String? bio) => _$this._bio = bio;

  SetBuilder<String>? _interestIds;
  SetBuilder<String> get interestIds =>
      _$this._interestIds ??= SetBuilder<String>();
  set interestIds(SetBuilder<String>? interestIds) =>
      _$this._interestIds = interestIds;

  ListBuilder<ProfilePromptAnswersInner>? _promptAnswers;
  ListBuilder<ProfilePromptAnswersInner> get promptAnswers =>
      _$this._promptAnswers ??= ListBuilder<ProfilePromptAnswersInner>();
  set promptAnswers(ListBuilder<ProfilePromptAnswersInner>? promptAnswers) =>
      _$this._promptAnswers = promptAnswers;

  MyProfileBuilder() {
    MyProfile._defaults(this);
  }

  MyProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _revision = $v.revision;
      _readiness = $v.readiness;
      _profileId = $v.profileId;
      _nickname = $v.nickname;
      _cityId = $v.cityId;
      _representation = $v.representation.toBuilder();
      _bio = $v.bio;
      _interestIds = $v.interestIds.toBuilder();
      _promptAnswers = $v.promptAnswers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MyProfile other) {
    _$v = other as _$MyProfile;
  }

  @override
  void update(void Function(MyProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MyProfile build() => _build();

  _$MyProfile _build() {
    _$MyProfile _$result;
    try {
      _$result =
          _$v ??
          _$MyProfile._(
            revision: BuiltValueNullFieldError.checkNotNull(
              revision,
              r'MyProfile',
              'revision',
            ),
            readiness: BuiltValueNullFieldError.checkNotNull(
              readiness,
              r'MyProfile',
              'readiness',
            ),
            profileId: profileId,
            nickname: nickname,
            cityId: cityId,
            representation: representation.build(),
            bio: bio,
            interestIds: interestIds.build(),
            promptAnswers: promptAnswers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'representation';
        representation.build();

        _$failedField = 'interestIds';
        interestIds.build();
        _$failedField = 'promptAnswers';
        promptAnswers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MyProfile',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
