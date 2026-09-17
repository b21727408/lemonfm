// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberProfile extends MemberProfile {
  @override
  final String profileId;
  @override
  final String nickname;
  @override
  final String cityId;
  @override
  final ProfileRepresentation representation;
  @override
  final String? bio;
  @override
  final BuiltSet<String> interestIds;
  @override
  final BuiltList<ProfilePromptAnswersInner> promptAnswers;

  factory _$MemberProfile([void Function(MemberProfileBuilder)? updates]) =>
      (MemberProfileBuilder()..update(updates))._build();

  _$MemberProfile._({
    required this.profileId,
    required this.nickname,
    required this.cityId,
    required this.representation,
    this.bio,
    required this.interestIds,
    required this.promptAnswers,
  }) : super._();
  @override
  MemberProfile rebuild(void Function(MemberProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberProfileBuilder toBuilder() => MemberProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberProfile &&
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
    return (newBuiltValueToStringHelper(r'MemberProfile')
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

class MemberProfileBuilder
    implements Builder<MemberProfile, MemberProfileBuilder> {
  _$MemberProfile? _$v;

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

  MemberProfileBuilder() {
    MemberProfile._defaults(this);
  }

  MemberProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
  void replace(MemberProfile other) {
    _$v = other as _$MemberProfile;
  }

  @override
  void update(void Function(MemberProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberProfile build() => _build();

  _$MemberProfile _build() {
    _$MemberProfile _$result;
    try {
      _$result =
          _$v ??
          _$MemberProfile._(
            profileId: BuiltValueNullFieldError.checkNotNull(
              profileId,
              r'MemberProfile',
              'profileId',
            ),
            nickname: BuiltValueNullFieldError.checkNotNull(
              nickname,
              r'MemberProfile',
              'nickname',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'MemberProfile',
              'cityId',
            ),
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
          r'MemberProfile',
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
