//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'avatar_representation.g.dart';

/// AvatarRepresentation
///
/// Properties:
/// * [kind]
/// * [avatarId] - Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
@BuiltValue()
abstract class AvatarRepresentation
    implements Built<AvatarRepresentation, AvatarRepresentationBuilder> {
  @BuiltValueField(wireName: r'kind')
  AvatarRepresentationKindEnum get kind;
  // enum kindEnum {  AVATAR,  };

  /// Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
  @BuiltValueField(wireName: r'avatarId')
  String get avatarId;

  AvatarRepresentation._();

  factory AvatarRepresentation([void updates(AvatarRepresentationBuilder b)]) =
      _$AvatarRepresentation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AvatarRepresentationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AvatarRepresentation> get serializer =>
      _$AvatarRepresentationSerializer();
}

class _$AvatarRepresentationSerializer
    implements PrimitiveSerializer<AvatarRepresentation> {
  @override
  final Iterable<Type> types = const [
    AvatarRepresentation,
    _$AvatarRepresentation,
  ];

  @override
  final String wireName = r'AvatarRepresentation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AvatarRepresentation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AvatarRepresentationKindEnum),
    );
    yield r'avatarId';
    yield serializers.serialize(
      object.avatarId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AvatarRepresentation object, {
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
    required AvatarRepresentationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AvatarRepresentationKindEnum),
                  )
                  as AvatarRepresentationKindEnum;
          result.kind = valueDes;
          break;
        case r'avatarId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.avatarId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AvatarRepresentation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AvatarRepresentationBuilder();
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

class AvatarRepresentationKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'AVATAR')
  static const AvatarRepresentationKindEnum AVATAR =
      _$avatarRepresentationKindEnum_AVATAR;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AvatarRepresentationKindEnum unknownDefaultOpenApi =
      _$avatarRepresentationKindEnum_unknownDefaultOpenApi;

  static Serializer<AvatarRepresentationKindEnum> get serializer =>
      _$avatarRepresentationKindEnumSerializer;

  const AvatarRepresentationKindEnum._(String name) : super(name);

  static BuiltSet<AvatarRepresentationKindEnum> get values =>
      _$avatarRepresentationKindEnumValues;
  static AvatarRepresentationKindEnum valueOf(String name) =>
      _$avatarRepresentationKindEnumValueOf(name);
}
