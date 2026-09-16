//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'profile_photo_change.g.dart';

/// Reference to this author's ready, inspected media, independently checked again at application. Registering the candidate does not publish that media. Never accept an upload grant, storage key or arbitrary URL here.
///
/// Properties:
/// * [kind]
/// * [mediaId] - Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
@BuiltValue()
abstract class ProfilePhotoChange
    implements Built<ProfilePhotoChange, ProfilePhotoChangeBuilder> {
  @BuiltValueField(wireName: r'kind')
  ProfilePhotoChangeKindEnum get kind;
  // enum kindEnum {  PHOTO,  };

  /// Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
  @BuiltValueField(wireName: r'mediaId')
  String get mediaId;

  ProfilePhotoChange._();

  factory ProfilePhotoChange([void updates(ProfilePhotoChangeBuilder b)]) =
      _$ProfilePhotoChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfilePhotoChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfilePhotoChange> get serializer =>
      _$ProfilePhotoChangeSerializer();
}

class _$ProfilePhotoChangeSerializer
    implements PrimitiveSerializer<ProfilePhotoChange> {
  @override
  final Iterable<Type> types = const [ProfilePhotoChange, _$ProfilePhotoChange];

  @override
  final String wireName = r'ProfilePhotoChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfilePhotoChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(ProfilePhotoChangeKindEnum),
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
    ProfilePhotoChange object, {
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
    required ProfilePhotoChangeBuilder result,
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
                    specifiedType: const FullType(ProfilePhotoChangeKindEnum),
                  )
                  as ProfilePhotoChangeKindEnum;
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
  ProfilePhotoChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfilePhotoChangeBuilder();
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

class ProfilePhotoChangeKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PHOTO')
  static const ProfilePhotoChangeKindEnum PHOTO =
      _$profilePhotoChangeKindEnum_PHOTO;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ProfilePhotoChangeKindEnum unknownDefaultOpenApi =
      _$profilePhotoChangeKindEnum_unknownDefaultOpenApi;

  static Serializer<ProfilePhotoChangeKindEnum> get serializer =>
      _$profilePhotoChangeKindEnumSerializer;

  const ProfilePhotoChangeKindEnum._(String name) : super(name);

  static BuiltSet<ProfilePhotoChangeKindEnum> get values =>
      _$profilePhotoChangeKindEnumValues;
  static ProfilePhotoChangeKindEnum valueOf(String name) =>
      _$profilePhotoChangeKindEnumValueOf(name);
}
