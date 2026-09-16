//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'acknowledge_profile_change.g.dart';

/// AcknowledgeProfileChange
///
/// Properties:
/// * [nudgeToken] - Exact currently displayed challenge; neither normalize nor log it.
@BuiltValue()
abstract class AcknowledgeProfileChange
    implements
        Built<AcknowledgeProfileChange, AcknowledgeProfileChangeBuilder> {
  /// Exact currently displayed challenge; neither normalize nor log it.
  @BuiltValueField(wireName: r'nudgeToken')
  String get nudgeToken;

  AcknowledgeProfileChange._();

  factory AcknowledgeProfileChange([
    void updates(AcknowledgeProfileChangeBuilder b),
  ]) = _$AcknowledgeProfileChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AcknowledgeProfileChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AcknowledgeProfileChange> get serializer =>
      _$AcknowledgeProfileChangeSerializer();
}

class _$AcknowledgeProfileChangeSerializer
    implements PrimitiveSerializer<AcknowledgeProfileChange> {
  @override
  final Iterable<Type> types = const [
    AcknowledgeProfileChange,
    _$AcknowledgeProfileChange,
  ];

  @override
  final String wireName = r'AcknowledgeProfileChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AcknowledgeProfileChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nudgeToken';
    yield serializers.serialize(
      object.nudgeToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AcknowledgeProfileChange object, {
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
    required AcknowledgeProfileChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nudgeToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nudgeToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AcknowledgeProfileChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AcknowledgeProfileChangeBuilder();
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
