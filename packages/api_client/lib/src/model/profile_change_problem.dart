//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:api_client/src/optional.dart';

part 'profile_change_problem.g.dart';

/// Safe terminal candidate outcome, not an HTTP failure to read the resource. Never include raw provider errors, private input, staff evidence or trust labels. SERVICE_UNAVAILABLE is a failed content check, not content rejection.
///
/// Properties:
/// * [code]
/// * [fields]
@BuiltValue()
abstract class ProfileChangeProblem
    implements Built<ProfileChangeProblem, ProfileChangeProblemBuilder> {
  @BuiltValueField(wireName: r'code')
  ProfileChangeProblemCodeEnum get code;
  // enum codeEnum {  CONTENT_NOT_ALLOWED,  REVISION_CONFLICT,  NICKNAME_UNAVAILABLE,  CATALOG_UNAVAILABLE,  MEDIA_UNAVAILABLE,  SERVICE_UNAVAILABLE,  PROFILE_CHANGE_UNAVAILABLE,  };

  @BuiltValueField(wireName: r'fields')
  Optional<BuiltSet<ProfileChangeProblemFieldsEnum>?> get fields;
  // enum fieldsEnum {  nickname,  cityId,  representation,  bio,  interestIds,  promptAnswers,  };

  ProfileChangeProblem._();

  factory ProfileChangeProblem([void updates(ProfileChangeProblemBuilder b)]) =
      _$ProfileChangeProblem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfileChangeProblemBuilder b) =>
      b..fields = Optional.absent();

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfileChangeProblem> get serializer =>
      _$ProfileChangeProblemSerializer();
}

class _$ProfileChangeProblemSerializer
    implements PrimitiveSerializer<ProfileChangeProblem> {
  @override
  final Iterable<Type> types = const [
    ProfileChangeProblem,
    _$ProfileChangeProblem,
  ];

  @override
  final String wireName = r'ProfileChangeProblem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfileChangeProblem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(ProfileChangeProblemCodeEnum),
    );
    if (object.fields.isPresent) {
      yield r'fields';
      final optionalValue = object.fields.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType(BuiltSet, [
            FullType(ProfileChangeProblemFieldsEnum),
          ]),
        );
      }
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProfileChangeProblem object, {
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
    required ProfileChangeProblemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(ProfileChangeProblemCodeEnum),
                  )
                  as ProfileChangeProblemCodeEnum;
          result.code = valueDes;
          break;
        case r'fields':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltSet, [
                      FullType(ProfileChangeProblemFieldsEnum),
                    ]),
                  )
                  as BuiltSet<ProfileChangeProblemFieldsEnum>?;
          result.fields = Optional.present(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProfileChangeProblem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfileChangeProblemBuilder();
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

class ProfileChangeProblemCodeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'CONTENT_NOT_ALLOWED')
  static const ProfileChangeProblemCodeEnum CONTENT_NOT_ALLOWED =
      _$profileChangeProblemCodeEnum_CONTENT_NOT_ALLOWED;
  @BuiltValueEnumConst(wireName: r'REVISION_CONFLICT')
  static const ProfileChangeProblemCodeEnum REVISION_CONFLICT =
      _$profileChangeProblemCodeEnum_REVISION_CONFLICT;
  @BuiltValueEnumConst(wireName: r'NICKNAME_UNAVAILABLE')
  static const ProfileChangeProblemCodeEnum NICKNAME_UNAVAILABLE =
      _$profileChangeProblemCodeEnum_NICKNAME_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'CATALOG_UNAVAILABLE')
  static const ProfileChangeProblemCodeEnum CATALOG_UNAVAILABLE =
      _$profileChangeProblemCodeEnum_CATALOG_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'MEDIA_UNAVAILABLE')
  static const ProfileChangeProblemCodeEnum MEDIA_UNAVAILABLE =
      _$profileChangeProblemCodeEnum_MEDIA_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'SERVICE_UNAVAILABLE')
  static const ProfileChangeProblemCodeEnum SERVICE_UNAVAILABLE =
      _$profileChangeProblemCodeEnum_SERVICE_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'PROFILE_CHANGE_UNAVAILABLE')
  static const ProfileChangeProblemCodeEnum PROFILE_CHANGE_UNAVAILABLE =
      _$profileChangeProblemCodeEnum_PROFILE_CHANGE_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ProfileChangeProblemCodeEnum unknownDefaultOpenApi =
      _$profileChangeProblemCodeEnum_unknownDefaultOpenApi;

  static Serializer<ProfileChangeProblemCodeEnum> get serializer =>
      _$profileChangeProblemCodeEnumSerializer;

  const ProfileChangeProblemCodeEnum._(String name) : super(name);

  static BuiltSet<ProfileChangeProblemCodeEnum> get values =>
      _$profileChangeProblemCodeEnumValues;
  static ProfileChangeProblemCodeEnum valueOf(String name) =>
      _$profileChangeProblemCodeEnumValueOf(name);
}

class ProfileChangeProblemFieldsEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'nickname')
  static const ProfileChangeProblemFieldsEnum nickname =
      _$profileChangeProblemFieldsEnum_nickname;
  @BuiltValueEnumConst(wireName: r'cityId')
  static const ProfileChangeProblemFieldsEnum cityId =
      _$profileChangeProblemFieldsEnum_cityId;
  @BuiltValueEnumConst(wireName: r'representation')
  static const ProfileChangeProblemFieldsEnum representation =
      _$profileChangeProblemFieldsEnum_representation;
  @BuiltValueEnumConst(wireName: r'bio')
  static const ProfileChangeProblemFieldsEnum bio =
      _$profileChangeProblemFieldsEnum_bio;
  @BuiltValueEnumConst(wireName: r'interestIds')
  static const ProfileChangeProblemFieldsEnum interestIds =
      _$profileChangeProblemFieldsEnum_interestIds;
  @BuiltValueEnumConst(wireName: r'promptAnswers')
  static const ProfileChangeProblemFieldsEnum promptAnswers =
      _$profileChangeProblemFieldsEnum_promptAnswers;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ProfileChangeProblemFieldsEnum unknownDefaultOpenApi =
      _$profileChangeProblemFieldsEnum_unknownDefaultOpenApi;

  static Serializer<ProfileChangeProblemFieldsEnum> get serializer =>
      _$profileChangeProblemFieldsEnumSerializer;

  const ProfileChangeProblemFieldsEnum._(String name) : super(name);

  static BuiltSet<ProfileChangeProblemFieldsEnum> get values =>
      _$profileChangeProblemFieldsEnumValues;
  static ProfileChangeProblemFieldsEnum valueOf(String name) =>
      _$profileChangeProblemFieldsEnumValueOf(name);
}
