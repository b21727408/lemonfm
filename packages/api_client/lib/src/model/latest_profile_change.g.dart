// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_profile_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LatestProfileChange extends LatestProfileChange {
  @override
  final ProfileChange? change;

  factory _$LatestProfileChange([
    void Function(LatestProfileChangeBuilder)? updates,
  ]) => (LatestProfileChangeBuilder()..update(updates))._build();

  _$LatestProfileChange._({this.change}) : super._();
  @override
  LatestProfileChange rebuild(
    void Function(LatestProfileChangeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  LatestProfileChangeBuilder toBuilder() =>
      LatestProfileChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LatestProfileChange && change == other.change;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, change.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'LatestProfileChange',
    )..add('change', change)).toString();
  }
}

class LatestProfileChangeBuilder
    implements Builder<LatestProfileChange, LatestProfileChangeBuilder> {
  _$LatestProfileChange? _$v;

  ProfileChangeBuilder? _change;
  ProfileChangeBuilder get change => _$this._change ??= ProfileChangeBuilder();
  set change(ProfileChangeBuilder? change) => _$this._change = change;

  LatestProfileChangeBuilder() {
    LatestProfileChange._defaults(this);
  }

  LatestProfileChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _change = $v.change?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LatestProfileChange other) {
    _$v = other as _$LatestProfileChange;
  }

  @override
  void update(void Function(LatestProfileChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LatestProfileChange build() => _build();

  _$LatestProfileChange _build() {
    _$LatestProfileChange _$result;
    try {
      _$result = _$v ?? _$LatestProfileChange._(change: _change?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'change';
        _change?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'LatestProfileChange',
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
