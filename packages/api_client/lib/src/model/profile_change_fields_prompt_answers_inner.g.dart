// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_change_fields_prompt_answers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProfileChangeFieldsPromptAnswersInner
    extends ProfileChangeFieldsPromptAnswersInner {
  @override
  final String promptId;
  @override
  final String answer;

  factory _$ProfileChangeFieldsPromptAnswersInner([
    void Function(ProfileChangeFieldsPromptAnswersInnerBuilder)? updates,
  ]) => (ProfileChangeFieldsPromptAnswersInnerBuilder()..update(updates))
      ._build();

  _$ProfileChangeFieldsPromptAnswersInner._({
    required this.promptId,
    required this.answer,
  }) : super._();
  @override
  ProfileChangeFieldsPromptAnswersInner rebuild(
    void Function(ProfileChangeFieldsPromptAnswersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProfileChangeFieldsPromptAnswersInnerBuilder toBuilder() =>
      ProfileChangeFieldsPromptAnswersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileChangeFieldsPromptAnswersInner &&
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
    return (newBuiltValueToStringHelper(
            r'ProfileChangeFieldsPromptAnswersInner',
          )
          ..add('promptId', promptId)
          ..add('answer', answer))
        .toString();
  }
}

class ProfileChangeFieldsPromptAnswersInnerBuilder
    implements
        Builder<
          ProfileChangeFieldsPromptAnswersInner,
          ProfileChangeFieldsPromptAnswersInnerBuilder
        > {
  _$ProfileChangeFieldsPromptAnswersInner? _$v;

  String? _promptId;
  String? get promptId => _$this._promptId;
  set promptId(String? promptId) => _$this._promptId = promptId;

  String? _answer;
  String? get answer => _$this._answer;
  set answer(String? answer) => _$this._answer = answer;

  ProfileChangeFieldsPromptAnswersInnerBuilder() {
    ProfileChangeFieldsPromptAnswersInner._defaults(this);
  }

  ProfileChangeFieldsPromptAnswersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _promptId = $v.promptId;
      _answer = $v.answer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileChangeFieldsPromptAnswersInner other) {
    _$v = other as _$ProfileChangeFieldsPromptAnswersInner;
  }

  @override
  void update(
    void Function(ProfileChangeFieldsPromptAnswersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  ProfileChangeFieldsPromptAnswersInner build() => _build();

  _$ProfileChangeFieldsPromptAnswersInner _build() {
    final _$result =
        _$v ??
        _$ProfileChangeFieldsPromptAnswersInner._(
          promptId: BuiltValueNullFieldError.checkNotNull(
            promptId,
            r'ProfileChangeFieldsPromptAnswersInner',
            'promptId',
          ),
          answer: BuiltValueNullFieldError.checkNotNull(
            answer,
            r'ProfileChangeFieldsPromptAnswersInner',
            'answer',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
