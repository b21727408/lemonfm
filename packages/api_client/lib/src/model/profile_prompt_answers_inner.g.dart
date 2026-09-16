// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_prompt_answers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProfilePromptAnswersInner extends ProfilePromptAnswersInner {
  @override
  final String promptId;
  @override
  final String answer;

  factory _$ProfilePromptAnswersInner([
    void Function(ProfilePromptAnswersInnerBuilder)? updates,
  ]) => (ProfilePromptAnswersInnerBuilder()..update(updates))._build();

  _$ProfilePromptAnswersInner._({required this.promptId, required this.answer})
    : super._();
  @override
  ProfilePromptAnswersInner rebuild(
    void Function(ProfilePromptAnswersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProfilePromptAnswersInnerBuilder toBuilder() =>
      ProfilePromptAnswersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfilePromptAnswersInner &&
        promptId == other.promptId &&
        answer == other.answer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, promptId.hashCode);
    _$hash = $jc(_$hash, answer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfilePromptAnswersInner')
          ..add('promptId', promptId)
          ..add('answer', answer))
        .toString();
  }
}

class ProfilePromptAnswersInnerBuilder
    implements
        Builder<ProfilePromptAnswersInner, ProfilePromptAnswersInnerBuilder> {
  _$ProfilePromptAnswersInner? _$v;

  String? _promptId;
  String? get promptId => _$this._promptId;
  set promptId(String? promptId) => _$this._promptId = promptId;

  String? _answer;
  String? get answer => _$this._answer;
  set answer(String? answer) => _$this._answer = answer;

  ProfilePromptAnswersInnerBuilder() {
    ProfilePromptAnswersInner._defaults(this);
  }

  ProfilePromptAnswersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _promptId = $v.promptId;
      _answer = $v.answer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfilePromptAnswersInner other) {
    _$v = other as _$ProfilePromptAnswersInner;
  }

  @override
  void update(void Function(ProfilePromptAnswersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfilePromptAnswersInner build() => _build();

  _$ProfilePromptAnswersInner _build() {
    final _$result =
        _$v ??
        _$ProfilePromptAnswersInner._(
          promptId: BuiltValueNullFieldError.checkNotNull(
            promptId,
            r'ProfilePromptAnswersInner',
            'promptId',
          ),
          answer: BuiltValueNullFieldError.checkNotNull(
            answer,
            r'ProfilePromptAnswersInner',
            'answer',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
