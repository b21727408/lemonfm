//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'blank_representation.g.dart';

/// BlankRepresentation
///
/// Properties:
/// * [kind]
@BuiltValue()
abstract class BlankRepresentation
    implements Built<BlankRepresentation, BlankRepresentationBuilder> {
  @BuiltValueField(wireName: r'kind')
  BlankRepresentationKindEnum get kind;
  // enum kindEnum {  BLANK,  };

  BlankRepresentation._();

  factory BlankRepresentation([void updates(BlankRepresentationBuilder b)]) =
      _$BlankRepresentation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BlankRepresentationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BlankRepresentation> get serializer =>
      _$BlankRepresentationSerializer();
}

class _$BlankRepresentationSerializer
    implements PrimitiveSerializer<BlankRepresentation> {
  @override
  final Iterable<Type> types = const [
    BlankRepresentation,
    _$BlankRepresentation,
  ];

  @override
  final String wireName = r'BlankRepresentation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BlankRepresentation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(BlankRepresentationKindEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BlankRepresentation object, {
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
    required BlankRepresentationBuilder result,
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
                    specifiedType: const FullType(BlankRepresentationKindEnum),
                  )
                  as BlankRepresentationKindEnum;
          result.kind = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BlankRepresentation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BlankRepresentationBuilder();
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

class BlankRepresentationKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'BLANK')
  static const BlankRepresentationKindEnum BLANK =
      _$blankRepresentationKindEnum_BLANK;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const BlankRepresentationKindEnum unknownDefaultOpenApi =
      _$blankRepresentationKindEnum_unknownDefaultOpenApi;

  static Serializer<BlankRepresentationKindEnum> get serializer =>
      _$blankRepresentationKindEnumSerializer;

  const BlankRepresentationKindEnum._(String name) : super(name);

  static BuiltSet<BlankRepresentationKindEnum> get values =>
      _$blankRepresentationKindEnumValues;
  static BlankRepresentationKindEnum valueOf(String name) =>
      _$blankRepresentationKindEnumValueOf(name);
}
