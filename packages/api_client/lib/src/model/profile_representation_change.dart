//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/blank_representation.dart';
import 'package:api_client/src/model/profile_photo_change.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/avatar_representation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'profile_representation_change.g.dart';

/// Proposed representation. BLANK clears it; an avatar must be active. This value cannot set or change an exchange's anonymity mode.
///
/// Properties:
/// * [kind]
/// * [avatarId] - Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
/// * [mediaId] - Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
@BuiltValue()
abstract class ProfileRepresentationChange
    implements
        Built<ProfileRepresentationChange, ProfileRepresentationChangeBuilder> {
  /// One Of [AvatarRepresentation], [BlankRepresentation], [ProfilePhotoChange]
  OneOf get oneOf;

  static const String discriminatorFieldName = r'kind';

  static const Map<String, Type> discriminatorMapping = {
    r'AVATAR': AvatarRepresentation,
    r'BLANK': BlankRepresentation,
    r'PHOTO': ProfilePhotoChange,
  };

  ProfileRepresentationChange._();

  factory ProfileRepresentationChange([
    void updates(ProfileRepresentationChangeBuilder b),
  ]) = _$ProfileRepresentationChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfileRepresentationChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfileRepresentationChange> get serializer =>
      _$ProfileRepresentationChangeSerializer();
}

extension ProfileRepresentationChangeDiscriminatorExt
    on ProfileRepresentationChange {
  String? get discriminatorValue {
    if (this is AvatarRepresentation) {
      return r'AVATAR';
    }
    if (this is BlankRepresentation) {
      return r'BLANK';
    }
    if (this is ProfilePhotoChange) {
      return r'PHOTO';
    }
    return null;
  }
}

extension ProfileRepresentationChangeBuilderDiscriminatorExt
    on ProfileRepresentationChangeBuilder {
  String? get discriminatorValue {
    if (this is AvatarRepresentationBuilder) {
      return r'AVATAR';
    }
    if (this is BlankRepresentationBuilder) {
      return r'BLANK';
    }
    if (this is ProfilePhotoChangeBuilder) {
      return r'PHOTO';
    }
    return null;
  }
}

class _$ProfileRepresentationChangeSerializer
    implements PrimitiveSerializer<ProfileRepresentationChange> {
  @override
  final Iterable<Type> types = const [
    ProfileRepresentationChange,
    _$ProfileRepresentationChange,
  ];

  @override
  final String wireName = r'ProfileRepresentationChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfileRepresentationChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    ProfileRepresentationChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(
      oneOf.value,
      specifiedType: FullType(oneOf.valueType),
    )!;
  }

  @override
  ProfileRepresentationChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfileRepresentationChangeBuilder();
    Object? oneOfDataSrc;
    final serializedList = (serialized as Iterable<Object?>).toList();
    final discIndex =
        serializedList.indexOf(
          ProfileRepresentationChange.discriminatorFieldName,
        ) +
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
      ProfilePhotoChange,
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
                  specifiedType: FullType(ProfilePhotoChange),
                )
                as ProfilePhotoChange;
        oneOfType = ProfilePhotoChange;
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

class ProfileRepresentationChangeKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'PHOTO')
  static const ProfileRepresentationChangeKindEnum PHOTO =
      _$profileRepresentationChangeKindEnum_PHOTO;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ProfileRepresentationChangeKindEnum unknownDefaultOpenApi =
      _$profileRepresentationChangeKindEnum_unknownDefaultOpenApi;

  static Serializer<ProfileRepresentationChangeKindEnum> get serializer =>
      _$profileRepresentationChangeKindEnumSerializer;

  const ProfileRepresentationChangeKindEnum._(String name) : super(name);

  static BuiltSet<ProfileRepresentationChangeKindEnum> get values =>
      _$profileRepresentationChangeKindEnumValues;
  static ProfileRepresentationChangeKindEnum valueOf(String name) =>
      _$profileRepresentationChangeKindEnumValueOf(name);
}
