//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contract_fixture_response.g.dart';

/// ContractFixtureResponse
///
/// Properties:
/// * [fixture]
@BuiltValue()
abstract class ContractFixtureResponse
    implements Built<ContractFixtureResponse, ContractFixtureResponseBuilder> {
  @BuiltValueField(wireName: r'fixture')
  ContractFixtureResponseFixtureEnum get fixture;
  // enum fixtureEnum {  admin-v1,  };

  ContractFixtureResponse._();

  factory ContractFixtureResponse([
    void updates(ContractFixtureResponseBuilder b),
  ]) = _$ContractFixtureResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContractFixtureResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContractFixtureResponse> get serializer =>
      _$ContractFixtureResponseSerializer();
}

class _$ContractFixtureResponseSerializer
    implements PrimitiveSerializer<ContractFixtureResponse> {
  @override
  final Iterable<Type> types = const [
    ContractFixtureResponse,
    _$ContractFixtureResponse,
  ];

  @override
  final String wireName = r'ContractFixtureResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContractFixtureResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fixture';
    yield serializers.serialize(
      object.fixture,
      specifiedType: const FullType(ContractFixtureResponseFixtureEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContractFixtureResponse object, {
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
    required ContractFixtureResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fixture':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContractFixtureResponseFixtureEnum),
          ) as ContractFixtureResponseFixtureEnum;
          result.fixture = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContractFixtureResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContractFixtureResponseBuilder();
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

class ContractFixtureResponseFixtureEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'admin-v1')
  static const ContractFixtureResponseFixtureEnum adminV1 =
      _$contractFixtureResponseFixtureEnum_adminV1;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ContractFixtureResponseFixtureEnum unknownDefaultOpenApi =
      _$contractFixtureResponseFixtureEnum_unknownDefaultOpenApi;

  static Serializer<ContractFixtureResponseFixtureEnum> get serializer =>
      _$contractFixtureResponseFixtureEnumSerializer;

  const ContractFixtureResponseFixtureEnum._(String name) : super(name);

  static BuiltSet<ContractFixtureResponseFixtureEnum> get values =>
      _$contractFixtureResponseFixtureEnumValues;
  static ContractFixtureResponseFixtureEnum valueOf(String name) =>
      _$contractFixtureResponseFixtureEnumValueOf(name);
}
