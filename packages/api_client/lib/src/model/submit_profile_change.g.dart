// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_profile_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SubmitProfileChange extends SubmitProfileChange {
  @override
  final String expectedRevision;
  @override
  final Optional<String?> replacesChangeId;
  @override
  final ProfileChangeFields changes;

  factory _$SubmitProfileChange([
    void Function(SubmitProfileChangeBuilder)? updates,
  ]) => (SubmitProfileChangeBuilder()..update(updates))._build();

  _$SubmitProfileChange._({
    required this.expectedRevision,
    required this.replacesChangeId,
    required this.changes,
  }) : super._();
  @override
  SubmitProfileChange rebuild(
    void Function(SubmitProfileChangeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SubmitProfileChangeBuilder toBuilder() =>
      SubmitProfileChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubmitProfileChange &&
        expectedRevision == other.expectedRevision &&
        replacesChangeId == other.replacesChangeId &&
        changes == other.changes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, replacesChangeId.hashCode);
    _$hash = $jc(_$hash, changes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubmitProfileChange')
          ..add('expectedRevision', expectedRevision)
          ..add('replacesChangeId', replacesChangeId)
          ..add('changes', changes))
        .toString();
  }
}

class SubmitProfileChangeBuilder
    implements Builder<SubmitProfileChange, SubmitProfileChangeBuilder> {
  _$SubmitProfileChange? _$v;

  String? _expectedRevision;
  String? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(String? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  Optional<String?>? _replacesChangeId;
  Optional<String?>? get replacesChangeId => _$this._replacesChangeId;
  set replacesChangeId(Optional<String?>? replacesChangeId) =>
      _$this._replacesChangeId = replacesChangeId;

  ProfileChangeFieldsBuilder? _changes;
  ProfileChangeFieldsBuilder get changes =>
      _$this._changes ??= ProfileChangeFieldsBuilder();
  set changes(ProfileChangeFieldsBuilder? changes) => _$this._changes = changes;

  SubmitProfileChangeBuilder() {
    SubmitProfileChange._defaults(this);
  }

  SubmitProfileChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedRevision = $v.expectedRevision;
      _replacesChangeId = $v.replacesChangeId;
      _changes = $v.changes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubmitProfileChange other) {
    _$v = other as _$SubmitProfileChange;
  }

  @override
  void update(void Function(SubmitProfileChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubmitProfileChange build() => _build();

  _$SubmitProfileChange _build() {
    _$SubmitProfileChange _$result;
    try {
      _$result =
          _$v ??
          _$SubmitProfileChange._(
            expectedRevision: BuiltValueNullFieldError.checkNotNull(
              expectedRevision,
              r'SubmitProfileChange',
              'expectedRevision',
            ),
            replacesChangeId: BuiltValueNullFieldError.checkNotNull(
              replacesChangeId,
              r'SubmitProfileChange',
              'replacesChangeId',
            ),
            changes: changes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'changes';
        changes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SubmitProfileChange',
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
