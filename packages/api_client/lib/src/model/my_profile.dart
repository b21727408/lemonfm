//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/profile_representation.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/profile_prompt_answers_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'my_profile.g.dart';

/// Owner-only view. Nullable setup fields distinguish missing values from a read failure. READY must agree with saved nickname, supported city and an allocated public profileId; verify this semantic invariant in runtime tests. Reading readiness does not grant access to another API.
///
/// Properties:
/// * [revision] - Opaque revision of this member's saved Profile-owned fields only. It is not a contact-preference, collection or admission revision.
/// * [readiness]
/// * [profileId] - null until a public profile resource exists; not the private accountId.
/// * [nickname] - Accepted NFC-normalized nickname. Domain and Contracts also require Unicode letters/digits with single dot/underscore/hyphen separators, none at either end, and case-folded uniqueness. Length validation alone does not implement those Unicode-category or database rules.
/// * [cityId] - Self-selected coarse city catalog identity, or null before selection.
/// * [representation]
/// * [bio] - Accepted bio, or null when none is displayed.
/// * [interestIds] - Currently selected active catalog identities, not arbitrary labels or inferred traits.
/// * [promptAnswers] - Accepted answers to active authored prompts. Each promptId occurs at most once; the server enforces uniqueness by that property rather than treating two different answers to the same prompt as different items.
@BuiltValue()
abstract class MyProfile implements Built<MyProfile, MyProfileBuilder> {
  /// Opaque revision of this member's saved Profile-owned fields only. It is not a contact-preference, collection or admission revision.
  @BuiltValueField(wireName: r'revision')
  String get revision;

  @BuiltValueField(wireName: r'readiness')
  MyProfileReadinessEnum get readiness;
  // enum readinessEnum {  INCOMPLETE,  READY,  };

  /// null until a public profile resource exists; not the private accountId.
  @BuiltValueField(wireName: r'profileId')
  String? get profileId;

  /// Accepted NFC-normalized nickname. Domain and Contracts also require Unicode letters/digits with single dot/underscore/hyphen separators, none at either end, and case-folded uniqueness. Length validation alone does not implement those Unicode-category or database rules.
  @BuiltValueField(wireName: r'nickname')
  String? get nickname;

  /// Self-selected coarse city catalog identity, or null before selection.
  @BuiltValueField(wireName: r'cityId')
  String? get cityId;

  @BuiltValueField(wireName: r'representation')
  ProfileRepresentation get representation;

  /// Accepted bio, or null when none is displayed.
  @BuiltValueField(wireName: r'bio')
  String? get bio;

  /// Currently selected active catalog identities, not arbitrary labels or inferred traits.
  @BuiltValueField(wireName: r'interestIds')
  BuiltSet<String> get interestIds;

  /// Accepted answers to active authored prompts. Each promptId occurs at most once; the server enforces uniqueness by that property rather than treating two different answers to the same prompt as different items.
  @BuiltValueField(wireName: r'promptAnswers')
  BuiltList<ProfilePromptAnswersInner> get promptAnswers;

  MyProfile._();

  factory MyProfile([void updates(MyProfileBuilder b)]) = _$MyProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MyProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MyProfile> get serializer => _$MyProfileSerializer();
}

class _$MyProfileSerializer implements PrimitiveSerializer<MyProfile> {
  @override
  final Iterable<Type> types = const [MyProfile, _$MyProfile];

  @override
  final String wireName = r'MyProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MyProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(String),
    );
    yield r'readiness';
    yield serializers.serialize(
      object.readiness,
      specifiedType: const FullType(MyProfileReadinessEnum),
    );
    yield r'profileId';
    yield object.profileId == null
        ? null
        : serializers.serialize(
            object.profileId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'nickname';
    yield object.nickname == null
        ? null
        : serializers.serialize(
            object.nickname,
            specifiedType: const FullType.nullable(String),
          );
    yield r'cityId';
    yield object.cityId == null
        ? null
        : serializers.serialize(
            object.cityId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'representation';
    yield serializers.serialize(
      object.representation,
      specifiedType: const FullType(ProfileRepresentation),
    );
    yield r'bio';
    yield object.bio == null
        ? null
        : serializers.serialize(
            object.bio,
            specifiedType: const FullType.nullable(String),
          );
    yield r'interestIds';
    yield serializers.serialize(
      object.interestIds,
      specifiedType: const FullType(BuiltSet, [FullType(String)]),
    );
    yield r'promptAnswers';
    yield serializers.serialize(
      object.promptAnswers,
      specifiedType: const FullType(BuiltList, [
        FullType(ProfilePromptAnswersInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MyProfile object, {
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
    required MyProfileBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'revision':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.revision = valueDes;
          break;
        case r'readiness':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(MyProfileReadinessEnum),
                  )
                  as MyProfileReadinessEnum;
          result.readiness = valueDes;
          break;
        case r'profileId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.profileId = valueDes;
          break;
        case r'nickname':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.nickname = valueDes;
          break;
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.cityId = valueDes;
          break;
        case r'representation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(ProfileRepresentation),
                  )
                  as ProfileRepresentation;
          result.representation.replace(valueDes);
          break;
        case r'bio':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.bio = valueDes;
          break;
        case r'interestIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltSet, [FullType(String)]),
                  )
                  as BuiltSet<String>;
          result.interestIds.replace(valueDes);
          break;
        case r'promptAnswers':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(ProfilePromptAnswersInner),
                    ]),
                  )
                  as BuiltList<ProfilePromptAnswersInner>;
          result.promptAnswers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MyProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MyProfileBuilder();
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

class MyProfileReadinessEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'INCOMPLETE')
  static const MyProfileReadinessEnum INCOMPLETE =
      _$myProfileReadinessEnum_INCOMPLETE;
  @BuiltValueEnumConst(wireName: r'READY')
  static const MyProfileReadinessEnum READY = _$myProfileReadinessEnum_READY;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const MyProfileReadinessEnum unknownDefaultOpenApi =
      _$myProfileReadinessEnum_unknownDefaultOpenApi;

  static Serializer<MyProfileReadinessEnum> get serializer =>
      _$myProfileReadinessEnumSerializer;

  const MyProfileReadinessEnum._(String name) : super(name);

  static BuiltSet<MyProfileReadinessEnum> get values =>
      _$myProfileReadinessEnumValues;
  static MyProfileReadinessEnum valueOf(String name) =>
      _$myProfileReadinessEnumValueOf(name);
}
