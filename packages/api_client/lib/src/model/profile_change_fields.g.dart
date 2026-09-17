// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_change_fields.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProfileChangeFields extends ProfileChangeFields {
  @override
  final Optional<String?> nickname;
  @override
  final Optional<String?> cityId;
  @override
  final Optional<ProfileRepresentationChange?> representation;
  @override
  final Optional<String?> bio;
  @override
  final Optional<BuiltSet<String>?> interestIds;
  @override
  final Optional<BuiltList<ProfileChangeFieldsPromptAnswersInner>?>
  promptAnswers;

  factory _$ProfileChangeFields([
    void Function(ProfileChangeFieldsBuilder)? updates,
  ]) => (ProfileChangeFieldsBuilder()..update(updates))._build();

  _$ProfileChangeFields._({
    required this.nickname,
    required this.cityId,
    required this.representation,
    required this.bio,
    required this.interestIds,
    required this.promptAnswers,
  }) : super._();
  @override
  ProfileChangeFields rebuild(
    void Function(ProfileChangeFieldsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProfileChangeFieldsBuilder toBuilder() =>
      ProfileChangeFieldsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileChangeFields &&
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
    return (newBuiltValueToStringHelper(r'ProfileChangeFields')
          ..add('nickname', nickname)
          ..add('cityId', cityId)
          ..add('representation', representation)
          ..add('bio', bio)
          ..add('interestIds', interestIds)
          ..add('promptAnswers', promptAnswers))
        .toString();
  }
}

class ProfileChangeFieldsBuilder
    implements Builder<ProfileChangeFields, ProfileChangeFieldsBuilder> {
  _$ProfileChangeFields? _$v;

  Optional<String?>? _nickname;
  Optional<String?>? get nickname => _$this._nickname;
  set nickname(Optional<String?>? nickname) => _$this._nickname = nickname;

  Optional<String?>? _cityId;
  Optional<String?>? get cityId => _$this._cityId;
  set cityId(Optional<String?>? cityId) => _$this._cityId = cityId;

  Optional<ProfileRepresentationChange?>? _representation;
  Optional<ProfileRepresentationChange?>? get representation =>
      _$this._representation;
  set representation(Optional<ProfileRepresentationChange?>? representation) =>
      _$this._representation = representation;

  Optional<String?>? _bio;
  Optional<String?>? get bio => _$this._bio;
  set bio(Optional<String?>? bio) => _$this._bio = bio;

  Optional<BuiltSet<String>?>? _interestIds;
  Optional<BuiltSet<String>?>? get interestIds => _$this._interestIds;
  set interestIds(Optional<BuiltSet<String>?>? interestIds) =>
      _$this._interestIds = interestIds;

  Optional<BuiltList<ProfileChangeFieldsPromptAnswersInner>?>? _promptAnswers;
  Optional<BuiltList<ProfileChangeFieldsPromptAnswersInner>?>?
  get promptAnswers => _$this._promptAnswers;
  set promptAnswers(
    Optional<BuiltList<ProfileChangeFieldsPromptAnswersInner>?>? promptAnswers,
  ) => _$this._promptAnswers = promptAnswers;

  ProfileChangeFieldsBuilder() {
    ProfileChangeFields._defaults(this);
  }

  ProfileChangeFieldsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nickname = $v.nickname;
      _cityId = $v.cityId;
      _representation = $v.representation;
      _bio = $v.bio;
      _interestIds = $v.interestIds;
      _promptAnswers = $v.promptAnswers;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileChangeFields other) {
    _$v = other as _$ProfileChangeFields;
  }

  @override
  void update(void Function(ProfileChangeFieldsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileChangeFields build() => _build();

  _$ProfileChangeFields _build() {
    final _$result =
        _$v ??
        _$ProfileChangeFields._(
          nickname: BuiltValueNullFieldError.checkNotNull(
            nickname,
            r'ProfileChangeFields',
            'nickname',
          ),
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'ProfileChangeFields',
            'cityId',
          ),
          representation: BuiltValueNullFieldError.checkNotNull(
            representation,
            r'ProfileChangeFields',
            'representation',
          ),
          bio: BuiltValueNullFieldError.checkNotNull(
            bio,
            r'ProfileChangeFields',
            'bio',
          ),
          interestIds: BuiltValueNullFieldError.checkNotNull(
            interestIds,
            r'ProfileChangeFields',
            'interestIds',
          ),
          promptAnswers: BuiltValueNullFieldError.checkNotNull(
            promptAnswers,
            r'ProfileChangeFields',
            'promptAnswers',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
