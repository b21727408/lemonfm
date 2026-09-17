// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acknowledge_profile_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AcknowledgeProfileChange extends AcknowledgeProfileChange {
  @override
  final String nudgeToken;

  factory _$AcknowledgeProfileChange([
    void Function(AcknowledgeProfileChangeBuilder)? updates,
  ]) => (AcknowledgeProfileChangeBuilder()..update(updates))._build();

  _$AcknowledgeProfileChange._({required this.nudgeToken}) : super._();
  @override
  AcknowledgeProfileChange rebuild(
    void Function(AcknowledgeProfileChangeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AcknowledgeProfileChangeBuilder toBuilder() =>
      AcknowledgeProfileChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AcknowledgeProfileChange && nudgeToken == other.nudgeToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nudgeToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AcknowledgeProfileChange',
    )..add('nudgeToken', nudgeToken)).toString();
  }
}

class AcknowledgeProfileChangeBuilder
    implements
        Builder<AcknowledgeProfileChange, AcknowledgeProfileChangeBuilder> {
  _$AcknowledgeProfileChange? _$v;

  String? _nudgeToken;
  String? get nudgeToken => _$this._nudgeToken;
  set nudgeToken(String? nudgeToken) => _$this._nudgeToken = nudgeToken;

  AcknowledgeProfileChangeBuilder() {
    AcknowledgeProfileChange._defaults(this);
  }

  AcknowledgeProfileChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nudgeToken = $v.nudgeToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AcknowledgeProfileChange other) {
    _$v = other as _$AcknowledgeProfileChange;
  }

  @override
  void update(void Function(AcknowledgeProfileChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AcknowledgeProfileChange build() => _build();

  _$AcknowledgeProfileChange _build() {
    final _$result =
        _$v ??
        _$AcknowledgeProfileChange._(
          nudgeToken: BuiltValueNullFieldError.checkNotNull(
            nudgeToken,
            r'AcknowledgeProfileChange',
            'nudgeToken',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
