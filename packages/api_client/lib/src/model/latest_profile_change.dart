//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/profile_change.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'latest_profile_change.g.dart';

/// LatestProfileChange
///
/// Properties:
/// * [change]
@BuiltValue()
abstract class LatestProfileChange
    implements Built<LatestProfileChange, LatestProfileChangeBuilder> {
  @BuiltValueField(wireName: r'change')
  ProfileChange? get change;

  LatestProfileChange._();

  factory LatestProfileChange([void updates(LatestProfileChangeBuilder b)]) =
      _$LatestProfileChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LatestProfileChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LatestProfileChange> get serializer =>
      _$LatestProfileChangeSerializer();
}

class _$LatestProfileChangeSerializer
    implements PrimitiveSerializer<LatestProfileChange> {
  @override
  final Iterable<Type> types = const [
    LatestProfileChange,
    _$LatestProfileChange,
  ];

  @override
  final String wireName = r'LatestProfileChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LatestProfileChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'change';
    yield object.change == null
        ? null
        : serializers.serialize(
            object.change,
            specifiedType: const FullType.nullable(ProfileChange),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    LatestProfileChange object, {
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
    required LatestProfileChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'change':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(ProfileChange),
                  )
                  as ProfileChange?;
          if (valueDes == null) continue;
          result.change.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LatestProfileChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LatestProfileChangeBuilder();
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
