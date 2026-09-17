//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:api_client/src/optional.dart';

part 'profile_change_nudge.g.dart';

/// ProfileChangeNudge
///
/// Properties:
/// * [code]
/// * [reasonCode] - Safe policy-mapped category, never a raw provider label. CONTENT_CAUTION is the generic category; unknown categories render a generic caution, never automatic acknowledgement. Detailed mappings belong to D5.
/// * [nudgeToken] - Opaque challenge bound to the exact author, candidate, content and policy. Not a bearer credential. Requires owner authorization and current readable content; exclude from logs, analytics and URLs.
/// * [fields]
@BuiltValue()
abstract class ProfileChangeNudge
    implements Built<ProfileChangeNudge, ProfileChangeNudgeBuilder> {
  @BuiltValueField(wireName: r'code')
  ProfileChangeNudgeCodeEnum get code;
  // enum codeEnum {  CONTENT_NUDGE_REQUIRED,  };

  /// Safe policy-mapped category, never a raw provider label. CONTENT_CAUTION is the generic category; unknown categories render a generic caution, never automatic acknowledgement. Detailed mappings belong to D5.
  @BuiltValueField(wireName: r'reasonCode')
  String get reasonCode;

  /// Opaque challenge bound to the exact author, candidate, content and policy. Not a bearer credential. Requires owner authorization and current readable content; exclude from logs, analytics and URLs.
  @BuiltValueField(wireName: r'nudgeToken')
  String get nudgeToken;

  @BuiltValueField(wireName: r'fields')
  Optional<BuiltSet<ProfileChangeNudgeFieldsEnum>?> get fields;
  // enum fieldsEnum {  nickname,  bio,  promptAnswers,  };

  ProfileChangeNudge._();

  factory ProfileChangeNudge([void updates(ProfileChangeNudgeBuilder b)]) =
      _$ProfileChangeNudge;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfileChangeNudgeBuilder b) =>
      b..fields = Optional.absent();

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfileChangeNudge> get serializer =>
      _$ProfileChangeNudgeSerializer();
}

class _$ProfileChangeNudgeSerializer
    implements PrimitiveSerializer<ProfileChangeNudge> {
  @override
  final Iterable<Type> types = const [ProfileChangeNudge, _$ProfileChangeNudge];

  @override
  final String wireName = r'ProfileChangeNudge';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfileChangeNudge object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(ProfileChangeNudgeCodeEnum),
    );
    yield r'reasonCode';
    yield serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType(String),
    );
    yield r'nudgeToken';
    yield serializers.serialize(
      object.nudgeToken,
      specifiedType: const FullType(String),
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
            FullType(ProfileChangeNudgeFieldsEnum),
          ]),
        );
      }
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProfileChangeNudge object, {
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
    required ProfileChangeNudgeBuilder result,
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
                    specifiedType: const FullType(ProfileChangeNudgeCodeEnum),
                  )
                  as ProfileChangeNudgeCodeEnum;
          result.code = valueDes;
          break;
        case r'reasonCode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reasonCode = valueDes;
          break;
        case r'nudgeToken':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nudgeToken = valueDes;
          break;
        case r'fields':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltSet, [
                      FullType(ProfileChangeNudgeFieldsEnum),
                    ]),
                  )
                  as BuiltSet<ProfileChangeNudgeFieldsEnum>?;
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
  ProfileChangeNudge deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfileChangeNudgeBuilder();
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

class ProfileChangeNudgeCodeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'CONTENT_NUDGE_REQUIRED')
  static const ProfileChangeNudgeCodeEnum CONTENT_NUDGE_REQUIRED =
      _$profileChangeNudgeCodeEnum_CONTENT_NUDGE_REQUIRED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ProfileChangeNudgeCodeEnum unknownDefaultOpenApi =
      _$profileChangeNudgeCodeEnum_unknownDefaultOpenApi;

  static Serializer<ProfileChangeNudgeCodeEnum> get serializer =>
      _$profileChangeNudgeCodeEnumSerializer;

  const ProfileChangeNudgeCodeEnum._(String name) : super(name);

  static BuiltSet<ProfileChangeNudgeCodeEnum> get values =>
      _$profileChangeNudgeCodeEnumValues;
  static ProfileChangeNudgeCodeEnum valueOf(String name) =>
      _$profileChangeNudgeCodeEnumValueOf(name);
}

class ProfileChangeNudgeFieldsEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'nickname')
  static const ProfileChangeNudgeFieldsEnum nickname =
      _$profileChangeNudgeFieldsEnum_nickname;
  @BuiltValueEnumConst(wireName: r'bio')
  static const ProfileChangeNudgeFieldsEnum bio =
      _$profileChangeNudgeFieldsEnum_bio;
  @BuiltValueEnumConst(wireName: r'promptAnswers')
  static const ProfileChangeNudgeFieldsEnum promptAnswers =
      _$profileChangeNudgeFieldsEnum_promptAnswers;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ProfileChangeNudgeFieldsEnum unknownDefaultOpenApi =
      _$profileChangeNudgeFieldsEnum_unknownDefaultOpenApi;

  static Serializer<ProfileChangeNudgeFieldsEnum> get serializer =>
      _$profileChangeNudgeFieldsEnumSerializer;

  const ProfileChangeNudgeFieldsEnum._(String name) : super(name);

  static BuiltSet<ProfileChangeNudgeFieldsEnum> get values =>
      _$profileChangeNudgeFieldsEnumValues;
  static ProfileChangeNudgeFieldsEnum valueOf(String name) =>
      _$profileChangeNudgeFieldsEnumValueOf(name);
}
