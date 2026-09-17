//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'photo_representation.g.dart';

/// PhotoRepresentation
///
/// Properties:
/// * [kind]
/// * [mediaId] - Approved published media reference, never a storage key, original upload grant, external URL or unreviewed upload. Delivery must independently enforce the media feature's current authorization.
@BuiltValue()
abstract class PhotoRepresentation
    implements Built<PhotoRepresentation, PhotoRepresentationBuilder> {
  @BuiltValueField(wireName: r'kind')
  PhotoRepresentationKindEnum get kind;
  // enum kindEnum {  PHOTO,  };

  /// Approved published media reference, never a storage key, original upload grant, external URL or unreviewed upload. Delivery must independently enforce the media feature's current authorization.
  @BuiltValueField(wireName: r'mediaId')
  String get mediaId;

  PhotoRepresentation._();

  factory PhotoRepresentation([void updates(PhotoRepresentationBuilder b)]) =
      _$PhotoRepresentation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PhotoRepresentationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PhotoRepresentation> get serializer =>
      _$PhotoRepresentationSerializer();
}

class _$PhotoRepresentationSerializer
    implements PrimitiveSerializer<PhotoRepresentation> {
  @override
  final Iterable<Type> types = const [
    PhotoRepresentation,
    _$PhotoRepresentation,
  ];

  @override
  final String wireName = r'PhotoRepresentation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PhotoRepresentation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(PhotoRepresentationKindEnum),
    );
    yield r'mediaId';
    yield serializers.serialize(
      object.mediaId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PhotoRepresentation object, {
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
    required PhotoRepresentationBuilder result,
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
                    specifiedType: const FullType(PhotoRepresentationKindEnum),
                  )
                  as PhotoRepresentationKindEnum;
          result.kind = valueDes;
          break;
        case r'mediaId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.mediaId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PhotoRepresentation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PhotoRepresentationBuilder();
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

class PhotoRepresentationKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PHOTO')
  static const PhotoRepresentationKindEnum PHOTO =
      _$photoRepresentationKindEnum_PHOTO;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const PhotoRepresentationKindEnum unknownDefaultOpenApi =
      _$photoRepresentationKindEnum_unknownDefaultOpenApi;

  static Serializer<PhotoRepresentationKindEnum> get serializer =>
      _$photoRepresentationKindEnumSerializer;

  const PhotoRepresentationKindEnum._(String name) : super(name);

  static BuiltSet<PhotoRepresentationKindEnum> get values =>
      _$photoRepresentationKindEnumValues;
  static PhotoRepresentationKindEnum valueOf(String name) =>
      _$photoRepresentationKindEnumValueOf(name);
}
