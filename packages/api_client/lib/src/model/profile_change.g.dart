// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProfileChangeStateEnum _$profileChangeStateEnum_PROCESSING =
    const ProfileChangeStateEnum._('PROCESSING');
const ProfileChangeStateEnum _$profileChangeStateEnum_AWAITING_ACKNOWLEDGEMENT =
    const ProfileChangeStateEnum._('AWAITING_ACKNOWLEDGEMENT');
const ProfileChangeStateEnum _$profileChangeStateEnum_AWAITING_REVIEW =
    const ProfileChangeStateEnum._('AWAITING_REVIEW');
const ProfileChangeStateEnum _$profileChangeStateEnum_APPLIED =
    const ProfileChangeStateEnum._('APPLIED');
const ProfileChangeStateEnum _$profileChangeStateEnum_REJECTED =
    const ProfileChangeStateEnum._('REJECTED');
const ProfileChangeStateEnum _$profileChangeStateEnum_NOT_APPLIED =
    const ProfileChangeStateEnum._('NOT_APPLIED');
const ProfileChangeStateEnum _$profileChangeStateEnum_CANCELED =
    const ProfileChangeStateEnum._('CANCELED');
const ProfileChangeStateEnum _$profileChangeStateEnum_SUPERSEDED =
    const ProfileChangeStateEnum._('SUPERSEDED');
const ProfileChangeStateEnum _$profileChangeStateEnum_unknownDefaultOpenApi =
    const ProfileChangeStateEnum._('unknownDefaultOpenApi');

ProfileChangeStateEnum _$profileChangeStateEnumValueOf(String name) {
  switch (name) {
    case 'PROCESSING':
      return _$profileChangeStateEnum_PROCESSING;
    case 'AWAITING_ACKNOWLEDGEMENT':
      return _$profileChangeStateEnum_AWAITING_ACKNOWLEDGEMENT;
    case 'AWAITING_REVIEW':
      return _$profileChangeStateEnum_AWAITING_REVIEW;
    case 'APPLIED':
      return _$profileChangeStateEnum_APPLIED;
    case 'REJECTED':
      return _$profileChangeStateEnum_REJECTED;
    case 'NOT_APPLIED':
      return _$profileChangeStateEnum_NOT_APPLIED;
    case 'CANCELED':
      return _$profileChangeStateEnum_CANCELED;
    case 'SUPERSEDED':
      return _$profileChangeStateEnum_SUPERSEDED;
    case 'unknownDefaultOpenApi':
      return _$profileChangeStateEnum_unknownDefaultOpenApi;
    default:
      return _$profileChangeStateEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<ProfileChangeStateEnum> _$profileChangeStateEnumValues =
    BuiltSet<ProfileChangeStateEnum>(const <ProfileChangeStateEnum>[
      _$profileChangeStateEnum_PROCESSING,
      _$profileChangeStateEnum_AWAITING_ACKNOWLEDGEMENT,
      _$profileChangeStateEnum_AWAITING_REVIEW,
      _$profileChangeStateEnum_APPLIED,
      _$profileChangeStateEnum_REJECTED,
      _$profileChangeStateEnum_NOT_APPLIED,
      _$profileChangeStateEnum_CANCELED,
      _$profileChangeStateEnum_SUPERSEDED,
      _$profileChangeStateEnum_unknownDefaultOpenApi,
    ]);

Serializer<ProfileChangeStateEnum> _$profileChangeStateEnumSerializer =
    _$ProfileChangeStateEnumSerializer();

class _$ProfileChangeStateEnumSerializer
    implements PrimitiveSerializer<ProfileChangeStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PROCESSING': 'PROCESSING',
    'AWAITING_ACKNOWLEDGEMENT': 'AWAITING_ACKNOWLEDGEMENT',
    'AWAITING_REVIEW': 'AWAITING_REVIEW',
    'APPLIED': 'APPLIED',
    'REJECTED': 'REJECTED',
    'NOT_APPLIED': 'NOT_APPLIED',
    'CANCELED': 'CANCELED',
    'SUPERSEDED': 'SUPERSEDED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PROCESSING': 'PROCESSING',
    'AWAITING_ACKNOWLEDGEMENT': 'AWAITING_ACKNOWLEDGEMENT',
    'AWAITING_REVIEW': 'AWAITING_REVIEW',
    'APPLIED': 'APPLIED',
    'REJECTED': 'REJECTED',
    'NOT_APPLIED': 'NOT_APPLIED',
    'CANCELED': 'CANCELED',
    'SUPERSEDED': 'SUPERSEDED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[ProfileChangeStateEnum];
  @override
  final String wireName = 'ProfileChangeStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    ProfileChangeStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ProfileChangeStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ProfileChangeStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ProfileChange extends ProfileChange {
  @override
  final String changeId;
  @override
  final String operationId;
  @override
  final String expectedRevision;
  @override
  final ProfileChangeStateEnum state;
  @override
  final String stateVersion;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final Optional<ProfileChangeFields?> changes;
  @override
  final Optional<ProfileChangeNudge?> nudge;
  @override
  final Optional<ProfileChangeProblem?> problem;
  @override
  final Optional<String?> appliedRevision;
  @override
  final Optional<DateTime?> appliedAt;

  factory _$ProfileChange([void Function(ProfileChangeBuilder)? updates]) =>
      (ProfileChangeBuilder()..update(updates))._build();

  _$ProfileChange._({
    required this.changeId,
    required this.operationId,
    required this.expectedRevision,
    required this.state,
    required this.stateVersion,
    required this.createdAt,
    required this.updatedAt,
    required this.changes,
    required this.nudge,
    required this.problem,
    required this.appliedRevision,
    required this.appliedAt,
  }) : super._();
  @override
  ProfileChange rebuild(void Function(ProfileChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileChangeBuilder toBuilder() => ProfileChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileChange &&
        changeId == other.changeId &&
        operationId == other.operationId &&
        expectedRevision == other.expectedRevision &&
        state == other.state &&
        stateVersion == other.stateVersion &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        changes == other.changes &&
        nudge == other.nudge &&
        problem == other.problem &&
        appliedRevision == other.appliedRevision &&
        appliedAt == other.appliedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, changeId.hashCode);
    _$hash = $jc(_$hash, operationId.hashCode);
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, stateVersion.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, changes.hashCode);
    _$hash = $jc(_$hash, nudge.hashCode);
    _$hash = $jc(_$hash, problem.hashCode);
    _$hash = $jc(_$hash, appliedRevision.hashCode);
    _$hash = $jc(_$hash, appliedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileChange')
          ..add('changeId', changeId)
          ..add('operationId', operationId)
          ..add('expectedRevision', expectedRevision)
          ..add('state', state)
          ..add('stateVersion', stateVersion)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('changes', changes)
          ..add('nudge', nudge)
          ..add('problem', problem)
          ..add('appliedRevision', appliedRevision)
          ..add('appliedAt', appliedAt))
        .toString();
  }
}

class ProfileChangeBuilder
    implements Builder<ProfileChange, ProfileChangeBuilder> {
  _$ProfileChange? _$v;

  String? _changeId;
  String? get changeId => _$this._changeId;
  set changeId(String? changeId) => _$this._changeId = changeId;

  String? _operationId;
  String? get operationId => _$this._operationId;
  set operationId(String? operationId) => _$this._operationId = operationId;

  String? _expectedRevision;
  String? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(String? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

  ProfileChangeStateEnum? _state;
  ProfileChangeStateEnum? get state => _$this._state;
  set state(ProfileChangeStateEnum? state) => _$this._state = state;

  String? _stateVersion;
  String? get stateVersion => _$this._stateVersion;
  set stateVersion(String? stateVersion) => _$this._stateVersion = stateVersion;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  Optional<ProfileChangeFields?>? _changes;
  Optional<ProfileChangeFields?>? get changes => _$this._changes;
  set changes(Optional<ProfileChangeFields?>? changes) =>
      _$this._changes = changes;

  Optional<ProfileChangeNudge?>? _nudge;
  Optional<ProfileChangeNudge?>? get nudge => _$this._nudge;
  set nudge(Optional<ProfileChangeNudge?>? nudge) => _$this._nudge = nudge;

  Optional<ProfileChangeProblem?>? _problem;
  Optional<ProfileChangeProblem?>? get problem => _$this._problem;
  set problem(Optional<ProfileChangeProblem?>? problem) =>
      _$this._problem = problem;

  Optional<String?>? _appliedRevision;
  Optional<String?>? get appliedRevision => _$this._appliedRevision;
  set appliedRevision(Optional<String?>? appliedRevision) =>
      _$this._appliedRevision = appliedRevision;

  Optional<DateTime?>? _appliedAt;
  Optional<DateTime?>? get appliedAt => _$this._appliedAt;
  set appliedAt(Optional<DateTime?>? appliedAt) =>
      _$this._appliedAt = appliedAt;

  ProfileChangeBuilder() {
    ProfileChange._defaults(this);
  }

  ProfileChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _changeId = $v.changeId;
      _operationId = $v.operationId;
      _expectedRevision = $v.expectedRevision;
      _state = $v.state;
      _stateVersion = $v.stateVersion;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _changes = $v.changes;
      _nudge = $v.nudge;
      _problem = $v.problem;
      _appliedRevision = $v.appliedRevision;
      _appliedAt = $v.appliedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileChange other) {
    _$v = other as _$ProfileChange;
  }

  @override
  void update(void Function(ProfileChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileChange build() => _build();

  _$ProfileChange _build() {
    final _$result =
        _$v ??
        _$ProfileChange._(
          changeId: BuiltValueNullFieldError.checkNotNull(
            changeId,
            r'ProfileChange',
            'changeId',
          ),
          operationId: BuiltValueNullFieldError.checkNotNull(
            operationId,
            r'ProfileChange',
            'operationId',
          ),
          expectedRevision: BuiltValueNullFieldError.checkNotNull(
            expectedRevision,
            r'ProfileChange',
            'expectedRevision',
          ),
          state: BuiltValueNullFieldError.checkNotNull(
            state,
            r'ProfileChange',
            'state',
          ),
          stateVersion: BuiltValueNullFieldError.checkNotNull(
            stateVersion,
            r'ProfileChange',
            'stateVersion',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'ProfileChange',
            'createdAt',
          ),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
            updatedAt,
            r'ProfileChange',
            'updatedAt',
          ),
          changes: BuiltValueNullFieldError.checkNotNull(
            changes,
            r'ProfileChange',
            'changes',
          ),
          nudge: BuiltValueNullFieldError.checkNotNull(
            nudge,
            r'ProfileChange',
            'nudge',
          ),
          problem: BuiltValueNullFieldError.checkNotNull(
            problem,
            r'ProfileChange',
            'problem',
          ),
          appliedRevision: BuiltValueNullFieldError.checkNotNull(
            appliedRevision,
            r'ProfileChange',
            'appliedRevision',
          ),
          appliedAt: BuiltValueNullFieldError.checkNotNull(
            appliedAt,
            r'ProfileChange',
            'appliedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
