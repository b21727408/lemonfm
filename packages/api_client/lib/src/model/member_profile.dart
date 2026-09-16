//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/profile_representation.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/profile_prompt_answers_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_profile.g.dart';

/// Public-to-eligible-members projection, never an account DTO or an anonymous-exchange participant view. Self-only fields cannot be added merely because the caller happens to own the requested profile.
///
/// Properties:
/// * [profileId] - Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
/// * [nickname] - Accepted NFC-normalized nickname. Domain and Contracts also require Unicode letters/digits with single dot/underscore/hyphen separators, none at either end, and case-folded uniqueness. Length validation alone does not implement those Unicode-category or database rules.
/// * [cityId] - Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
/// * [representation]
/// * [bio]
/// * [interestIds] - Currently selected active catalog identities, not arbitrary labels or inferred traits.
/// * [promptAnswers] - Accepted answers to active authored prompts. Each promptId occurs at most once; the server enforces uniqueness by that property rather than treating two different answers to the same prompt as different items.
@BuiltValue()
abstract class MemberProfile
    implements Built<MemberProfile, MemberProfileBuilder> {
  /// Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
  @BuiltValueField(wireName: r'profileId')
  String get profileId;

  /// Accepted NFC-normalized nickname. Domain and Contracts also require Unicode letters/digits with single dot/underscore/hyphen separators, none at either end, and case-folded uniqueness. Length validation alone does not implement those Unicode-category or database rules.
  @BuiltValueField(wireName: r'nickname')
  String get nickname;

  /// Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'representation')
  ProfileRepresentation get representation;

  @BuiltValueField(wireName: r'bio')
  String? get bio;

  /// Currently selected active catalog identities, not arbitrary labels or inferred traits.
  @BuiltValueField(wireName: r'interestIds')
  BuiltSet<String> get interestIds;

  /// Accepted answers to active authored prompts. Each promptId occurs at most once; the server enforces uniqueness by that property rather than treating two different answers to the same prompt as different items.
  @BuiltValueField(wireName: r'promptAnswers')
  BuiltList<ProfilePromptAnswersInner> get promptAnswers;

  MemberProfile._();

  factory MemberProfile([void updates(MemberProfileBuilder b)]) =
      _$MemberProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberProfile> get serializer =>
      _$MemberProfileSerializer();
}

class _$MemberProfileSerializer implements PrimitiveSerializer<MemberProfile> {
  @override
  final Iterable<Type> types = const [MemberProfile, _$MemberProfile];

  @override
  final String wireName = r'MemberProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'profileId';
    yield serializers.serialize(
      object.profileId,
      specifiedType: const FullType(String),
    );
    yield r'nickname';
    yield serializers.serialize(
      object.nickname,
      specifiedType: const FullType(String),
    );
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
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
    MemberProfile object, {
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
    required MemberProfileBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'profileId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.profileId = valueDes;
          break;
        case r'nickname':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nickname = valueDes;
          break;
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
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
  MemberProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberProfileBuilder();
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
