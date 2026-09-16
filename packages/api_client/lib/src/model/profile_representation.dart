//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/blank_representation.dart';
import 'package:api_client/src/model/photo_representation.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/avatar_representation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'profile_representation.g.dart';

/// Current member-visible representation, unrelated to an exchange's anonymity mode. Unknown variants use a neutral unavailable visual, never a guessed photo/profile association or a submitted replacement.
///
/// Properties:
/// * [kind]
/// * [avatarId] - Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
/// * [mediaId] - Approved published media reference, never a storage key, original upload grant, external URL or unreviewed upload. Delivery must independently enforce the media feature's current authorization.
@BuiltValue()
abstract class ProfileRepresentation
    implements Built<ProfileRepresentation, ProfileRepresentationBuilder> {
  /// One Of [AvatarRepresentation], [BlankRepresentation], [PhotoRepresentation]
  OneOf get oneOf;

  static const String discriminatorFieldName = r'kind';

  static const Map<String, Type> discriminatorMapping = {
    r'AVATAR': AvatarRepresentation,
    r'BLANK': BlankRepresentation,
    r'PHOTO': PhotoRepresentation,
  };

  ProfileRepresentation._();

  factory ProfileRepresentation([
    void updates(ProfileRepresentationBuilder b),
  ]) = _$ProfileRepresentation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfileRepresentationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfileRepresentation> get serializer =>
      _$ProfileRepresentationSerializer();
}

extension ProfileRepresentationDiscriminatorExt on ProfileRepresentation {
  String? get discriminatorValue {
    if (this is AvatarRepresentation) {
      return r'AVATAR';
    }
    if (this is BlankRepresentation) {
      return r'BLANK';
    }
    if (this is PhotoRepresentation) {
      return r'PHOTO';
    }
    return null;
  }
}

extension ProfileRepresentationBuilderDiscriminatorExt
    on ProfileRepresentationBuilder {
  String? get discriminatorValue {
    if (this is AvatarRepresentationBuilder) {
      return r'AVATAR';
    }
    if (this is BlankRepresentationBuilder) {
      return r'BLANK';
    }
    if (this is PhotoRepresentationBuilder) {
      return r'PHOTO';
    }
    return null;
  }
}

class _$ProfileRepresentationSerializer
    implements PrimitiveSerializer<ProfileRepresentation> {
  @override
  final Iterable<Type> types = const [
    ProfileRepresentation,
    _$ProfileRepresentation,
  ];

  @override
  final String wireName = r'ProfileRepresentation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfileRepresentation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    ProfileRepresentation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(
      oneOf.value,
      specifiedType: FullType(oneOf.valueType),
    )!;
  }

  @override
  ProfileRepresentation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfileRepresentationBuilder();
    Object? oneOfDataSrc;
    final serializedList = (serialized as Iterable<Object?>).toList();
    final discIndex =
        serializedList.indexOf(ProfileRepresentation.discriminatorFieldName) +
        1;
    final discValue =
        serializers.deserialize(
              serializedList[discIndex],
              specifiedType: FullType(String),
            )
            as String;
    oneOfDataSrc = serialized;
    final oneOfTypes = [
      AvatarRepresentation,
      BlankRepresentation,
      PhotoRepresentation,
    ];
    Object oneOfResult;
    Type oneOfType;
    switch (discValue) {
      case r'AVATAR':
        oneOfResult =
            serializers.deserialize(
                  oneOfDataSrc,
                  specifiedType: FullType(AvatarRepresentation),
                )
                as AvatarRepresentation;
        oneOfType = AvatarRepresentation;
        break;
      case r'BLANK':
        oneOfResult =
            serializers.deserialize(
                  oneOfDataSrc,
                  specifiedType: FullType(BlankRepresentation),
                )
                as BlankRepresentation;
        oneOfType = BlankRepresentation;
        break;
      case r'PHOTO':
        oneOfResult =
            serializers.deserialize(
                  oneOfDataSrc,
                  specifiedType: FullType(PhotoRepresentation),
                )
                as PhotoRepresentation;
        oneOfType = PhotoRepresentation;
        break;
      default:
        throw UnsupportedError(
          "Couldn't deserialize oneOf for the discriminator value: ${discValue}",
        );
    }
    result.oneOf = OneOfDynamic(
      typeIndex: oneOfTypes.indexOf(oneOfType),
      types: oneOfTypes,
      value: oneOfResult,
    );
    return result.build();
  }
}

class ProfileRepresentationKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PHOTO')
  static const ProfileRepresentationKindEnum PHOTO =
      _$profileRepresentationKindEnum_PHOTO;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ProfileRepresentationKindEnum unknownDefaultOpenApi =
      _$profileRepresentationKindEnum_unknownDefaultOpenApi;

  static Serializer<ProfileRepresentationKindEnum> get serializer =>
      _$profileRepresentationKindEnumSerializer;

  const ProfileRepresentationKindEnum._(String name) : super(name);

  static BuiltSet<ProfileRepresentationKindEnum> get values =>
      _$profileRepresentationKindEnumValues;
  static ProfileRepresentationKindEnum valueOf(String name) =>
      _$profileRepresentationKindEnumValueOf(name);
}
