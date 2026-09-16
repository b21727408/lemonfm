//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/profile_change_nudge.dart';
import 'package:api_client/src/model/profile_change_problem.dart';
import 'package:api_client/src/model/profile_change_fields.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:api_client/src/optional.dart';

part 'profile_change.g.dart';

/// Owner-only current projection of an immutable submitted patch. State and safe disclosure can advance without changing the submitted content. An HTTP 2xx means the requested resource operation succeeded; only APPLIED records a completed save. APPLIED is not proof of browsing readiness or that these remain the current published values. Read getMyProfile for both. The response is not a moderation-evidence or general account model.
///
/// Properties:
/// * [changeId] - Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
/// * [operationId] - Client-generated action identity. Its syntax is a transport constraint, not proof of randomness or ownership. UUID-style keys are suitable.
/// * [expectedRevision] - Saved-profile revision against which this immutable patch was submitted.
/// * [state] - PROCESSING covers pending automatic checks or final application work. AWAITING_REVIEW is not approval or publication. REJECTED is a content decision; NOT_APPLIED is a technical failure or a failed current publication predicate. Only the first three states are live. Terminal candidates never reactivate; retry/correction is an explicit new submission. Unknown states disable mutation and trigger reconciliation.
/// * [stateVersion] - Positive canonical decimal counter increasing with each visible state, prompt or disclosure change. Compare as an integer only within this changeId; ignore older responses. It is not the saved-profile revision or authorization, and cannot order different candidates.
/// * [createdAt] - RFC 3339 UTC instant of candidate registration.
/// * [updatedAt] - RFC 3339 UTC instant of the latest visible candidate update.
/// * [changes]
/// * [nudge]
/// * [problem]
/// * [appliedRevision] - Revision produced by this save, possibly unchanged for a no-op; not necessarily current now.
/// * [appliedAt] - RFC 3339 UTC instant when the complete save committed.
@BuiltValue()
abstract class ProfileChange
    implements Built<ProfileChange, ProfileChangeBuilder> {
  /// Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
  @BuiltValueField(wireName: r'changeId')
  String get changeId;

  /// Client-generated action identity. Its syntax is a transport constraint, not proof of randomness or ownership. UUID-style keys are suitable.
  @BuiltValueField(wireName: r'operationId')
  String get operationId;

  /// Saved-profile revision against which this immutable patch was submitted.
  @BuiltValueField(wireName: r'expectedRevision')
  String get expectedRevision;

  /// PROCESSING covers pending automatic checks or final application work. AWAITING_REVIEW is not approval or publication. REJECTED is a content decision; NOT_APPLIED is a technical failure or a failed current publication predicate. Only the first three states are live. Terminal candidates never reactivate; retry/correction is an explicit new submission. Unknown states disable mutation and trigger reconciliation.
  @BuiltValueField(wireName: r'state')
  ProfileChangeStateEnum get state;
  // enum stateEnum {  PROCESSING,  AWAITING_ACKNOWLEDGEMENT,  AWAITING_REVIEW,  APPLIED,  REJECTED,  NOT_APPLIED,  CANCELED,  SUPERSEDED,  };

  /// Positive canonical decimal counter increasing with each visible state, prompt or disclosure change. Compare as an integer only within this changeId; ignore older responses. It is not the saved-profile revision or authorization, and cannot order different candidates.
  @BuiltValueField(wireName: r'stateVersion')
  String get stateVersion;

  /// RFC 3339 UTC instant of candidate registration.
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// RFC 3339 UTC instant of the latest visible candidate update.
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'changes')
  Optional<ProfileChangeFields?> get changes;

  @BuiltValueField(wireName: r'nudge')
  Optional<ProfileChangeNudge?> get nudge;

  @BuiltValueField(wireName: r'problem')
  Optional<ProfileChangeProblem?> get problem;

  /// Revision produced by this save, possibly unchanged for a no-op; not necessarily current now.
  @BuiltValueField(wireName: r'appliedRevision')
  Optional<String?> get appliedRevision;

  /// RFC 3339 UTC instant when the complete save committed.
  @BuiltValueField(wireName: r'appliedAt')
  Optional<DateTime?> get appliedAt;

  ProfileChange._();

  factory ProfileChange([void updates(ProfileChangeBuilder b)]) =
      _$ProfileChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfileChangeBuilder b) => b
    ..changes = Optional.absent()
    ..nudge = Optional.absent()
    ..problem = Optional.absent()
    ..appliedRevision = Optional.absent()
    ..appliedAt = Optional.absent();

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfileChange> get serializer =>
      _$ProfileChangeSerializer();
}

class _$ProfileChangeSerializer implements PrimitiveSerializer<ProfileChange> {
  @override
  final Iterable<Type> types = const [ProfileChange, _$ProfileChange];

  @override
  final String wireName = r'ProfileChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfileChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'changeId';
    yield serializers.serialize(
      object.changeId,
      specifiedType: const FullType(String),
    );
    yield r'operationId';
    yield serializers.serialize(
      object.operationId,
      specifiedType: const FullType(String),
    );
    yield r'expectedRevision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(ProfileChangeStateEnum),
    );
    yield r'stateVersion';
    yield serializers.serialize(
      object.stateVersion,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.changes.isPresent) {
      yield r'changes';
      final optionalValue = object.changes.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(ProfileChangeFields),
        );
      }
    }
    if (object.nudge.isPresent) {
      yield r'nudge';
      final optionalValue = object.nudge.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(ProfileChangeNudge),
        );
      }
    }
    if (object.problem.isPresent) {
      yield r'problem';
      final optionalValue = object.problem.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(ProfileChangeProblem),
        );
      }
    }
    if (object.appliedRevision.isPresent) {
      yield r'appliedRevision';
      final optionalValue = object.appliedRevision.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(String),
        );
      }
    }
    if (object.appliedAt.isPresent) {
      yield r'appliedAt';
      final optionalValue = object.appliedAt.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(DateTime),
        );
      }
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProfileChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProfileChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'changeId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.changeId = valueDes;
          break;
        case r'operationId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.operationId = valueDes;
          break;
        case r'expectedRevision':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.expectedRevision = valueDes;
          break;
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(ProfileChangeStateEnum),
                  )
                  as ProfileChangeStateEnum;
          result.state = valueDes;
          break;
        case r'stateVersion':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.stateVersion = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'changes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(ProfileChangeFields),
                  )
                  as ProfileChangeFields?;
          result.changes = Optional.present(valueDes);
          break;
        case r'nudge':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(ProfileChangeNudge),
                  )
                  as ProfileChangeNudge?;
          result.nudge = Optional.present(valueDes);
          break;
        case r'problem':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      ProfileChangeProblem,
                    ),
                  )
                  as ProfileChangeProblem?;
          result.problem = Optional.present(valueDes);
          break;
        case r'appliedRevision':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          result.appliedRevision = Optional.present(valueDes);
          break;
        case r'appliedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          result.appliedAt = Optional.present(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProfileChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfileChangeBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

/// PROCESSING covers pending automatic checks or final application work. AWAITING_REVIEW is not approval or publication. REJECTED is a content decision; NOT_APPLIED is a technical failure or a failed current publication predicate. Only the first three states are live. Terminal candidates never reactivate; retry/correction is an explicit new submission. Unknown states disable mutation and trigger reconciliation.
class ProfileChangeStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PROCESSING')
  static const ProfileChangeStateEnum PROCESSING =
      _$profileChangeStateEnum_PROCESSING;
  @BuiltValueEnumConst(wireName: r'AWAITING_ACKNOWLEDGEMENT')
  static const ProfileChangeStateEnum AWAITING_ACKNOWLEDGEMENT =
      _$profileChangeStateEnum_AWAITING_ACKNOWLEDGEMENT;
  @BuiltValueEnumConst(wireName: r'AWAITING_REVIEW')
  static const ProfileChangeStateEnum AWAITING_REVIEW =
      _$profileChangeStateEnum_AWAITING_REVIEW;
  @BuiltValueEnumConst(wireName: r'APPLIED')
  static const ProfileChangeStateEnum APPLIED =
      _$profileChangeStateEnum_APPLIED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const ProfileChangeStateEnum REJECTED =
      _$profileChangeStateEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'NOT_APPLIED')
  static const ProfileChangeStateEnum NOT_APPLIED =
      _$profileChangeStateEnum_NOT_APPLIED;
  @BuiltValueEnumConst(wireName: r'CANCELED')
  static const ProfileChangeStateEnum CANCELED =
      _$profileChangeStateEnum_CANCELED;
  @BuiltValueEnumConst(wireName: r'SUPERSEDED')
  static const ProfileChangeStateEnum SUPERSEDED =
      _$profileChangeStateEnum_SUPERSEDED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ProfileChangeStateEnum unknownDefaultOpenApi =
      _$profileChangeStateEnum_unknownDefaultOpenApi;

  static Serializer<ProfileChangeStateEnum> get serializer =>
      _$profileChangeStateEnumSerializer;

  const ProfileChangeStateEnum._(String name) : super(name);

  static BuiltSet<ProfileChangeStateEnum> get values =>
      _$profileChangeStateEnumValues;
  static ProfileChangeStateEnum valueOf(String name) =>
      _$profileChangeStateEnumValueOf(name);
}
