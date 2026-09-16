//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/profile_change_fields.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:api_client/src/optional.dart';

part 'submit_profile_change.g.dart';

/// SubmitProfileChange
///
/// Properties:
/// * [expectedRevision] - Current saved-profile revision from getMyProfile, including its initial revision.
/// * [replacesChangeId] - Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
/// * [changes]
@BuiltValue()
abstract class SubmitProfileChange
    implements Built<SubmitProfileChange, SubmitProfileChangeBuilder> {
  /// Current saved-profile revision from getMyProfile, including its initial revision.
  @BuiltValueField(wireName: r'expectedRevision')
  String get expectedRevision;

  /// Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
  @BuiltValueField(wireName: r'replacesChangeId')
  Optional<String?> get replacesChangeId;

  @BuiltValueField(wireName: r'changes')
  ProfileChangeFields get changes;

  SubmitProfileChange._();

  factory SubmitProfileChange([void updates(SubmitProfileChangeBuilder b)]) =
      _$SubmitProfileChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubmitProfileChangeBuilder b) =>
      b..replacesChangeId = Optional.absent();

  @BuiltValueSerializer(custom: true)
  static Serializer<SubmitProfileChange> get serializer =>
      _$SubmitProfileChangeSerializer();
}

class _$SubmitProfileChangeSerializer
    implements PrimitiveSerializer<SubmitProfileChange> {
  @override
  final Iterable<Type> types = const [
    SubmitProfileChange,
    _$SubmitProfileChange,
  ];

  @override
  final String wireName = r'SubmitProfileChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubmitProfileChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expectedRevision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(String),
    );
    if (object.replacesChangeId.isPresent) {
      yield r'replacesChangeId';
      final optionalValue = object.replacesChangeId.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(String),
        );
      }
    }
    yield r'changes';
    yield serializers.serialize(
      object.changes,
      specifiedType: const FullType(ProfileChangeFields),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SubmitProfileChange object, {
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
    required SubmitProfileChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expectedRevision':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.expectedRevision = valueDes;
          break;
        case r'replacesChangeId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          result.replacesChangeId = Optional.present(valueDes);
          break;
        case r'changes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(ProfileChangeFields),
                  )
                  as ProfileChangeFields;
          result.changes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubmitProfileChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubmitProfileChangeBuilder();
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
