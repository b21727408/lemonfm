//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/profile_change_fields_prompt_answers_inner.dart';
import 'package:api_client/src/model/profile_representation_change.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:api_client/src/optional.dart';

part 'profile_change_fields.g.dart';

/// Proposed patch, not a public profile DTO. Omission preserves the saved field. Normalize member text with NFC and outer trimming before length validation; an empty normalized bio means null. Catalog IDs and media references are opaque and are not text-normalized. Lists replace whole lists and do not implicitly merge a previous pending patch.
///
/// Properties:
/// * [nickname] - Proposed nickname, not yet moderated or reserved. Runtime validation enforces Contracts' Unicode letter/digit and separator rules; database uniqueness is checked again at application. Cannot be cleared with null.
/// * [cityId] - Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
/// * [representation]
/// * [bio] - null or normalized empty text clears the bio; omission preserves it.
/// * [interestIds] - Proposed catalog selections, rechecked for availability at application.
/// * [promptAnswers] - Proposed complete prompt-answer list; [] clears it. Each promptId must occur only once and identify an active authored prompt.
@BuiltValue()
abstract class ProfileChangeFields
    implements Built<ProfileChangeFields, ProfileChangeFieldsBuilder> {
  /// Proposed nickname, not yet moderated or reserved. Runtime validation enforces Contracts' Unicode letter/digit and separator rules; database uniqueness is checked again at application. Cannot be cleared with null.
  @BuiltValueField(wireName: r'nickname')
  Optional<String?> get nickname;

  /// Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
  @BuiltValueField(wireName: r'cityId')
  Optional<String?> get cityId;

  @BuiltValueField(wireName: r'representation')
  Optional<ProfileRepresentationChange?> get representation;

  /// null or normalized empty text clears the bio; omission preserves it.
  @BuiltValueField(wireName: r'bio')
  Optional<String?> get bio;

  /// Proposed catalog selections, rechecked for availability at application.
  @BuiltValueField(wireName: r'interestIds')
  Optional<BuiltSet<String>?> get interestIds;

  /// Proposed complete prompt-answer list; [] clears it. Each promptId must occur only once and identify an active authored prompt.
  @BuiltValueField(wireName: r'promptAnswers')
  Optional<BuiltList<ProfileChangeFieldsPromptAnswersInner>?> get promptAnswers;

  ProfileChangeFields._();

  factory ProfileChangeFields([void updates(ProfileChangeFieldsBuilder b)]) =
      _$ProfileChangeFields;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfileChangeFieldsBuilder b) => b
    ..nickname = Optional.absent()
    ..cityId = Optional.absent()
    ..representation = Optional.absent()
    ..bio = Optional.absent()
    ..interestIds = Optional.absent()
    ..promptAnswers = Optional.absent();

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfileChangeFields> get serializer =>
      _$ProfileChangeFieldsSerializer();
}

class _$ProfileChangeFieldsSerializer
    implements PrimitiveSerializer<ProfileChangeFields> {
  @override
  final Iterable<Type> types = const [
    ProfileChangeFields,
    _$ProfileChangeFields,
  ];

  @override
  final String wireName = r'ProfileChangeFields';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfileChangeFields object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.nickname.isPresent) {
      yield r'nickname';
      final optionalValue = object.nickname.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(String),
        );
      }
    }
    if (object.cityId.isPresent) {
      yield r'cityId';
      final optionalValue = object.cityId.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(String),
        );
      }
    }
    if (object.representation.isPresent) {
      yield r'representation';
      final optionalValue = object.representation.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(ProfileRepresentationChange),
        );
      }
    }
    if (object.bio.isPresent) {
      yield r'bio';
      final optionalValue = object.bio.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(String),
        );
      }
    }
    if (object.interestIds.isPresent) {
      yield r'interestIds';
      final optionalValue = object.interestIds.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType(BuiltSet, [FullType(String)]),
        );
      }
    }
    if (object.promptAnswers.isPresent) {
      yield r'promptAnswers';
      final optionalValue = object.promptAnswers.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType(BuiltList, [
            FullType(ProfileChangeFieldsPromptAnswersInner),
          ]),
        );
      }
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProfileChangeFields object, {
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
    required ProfileChangeFieldsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nickname':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          result.nickname = Optional.present(valueDes);
          break;
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          result.cityId = Optional.present(valueDes);
          break;
        case r'representation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      ProfileRepresentationChange,
                    ),
                  )
                  as ProfileRepresentationChange?;
          result.representation = Optional.present(valueDes);
          break;
        case r'bio':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          result.bio = Optional.present(valueDes);
          break;
        case r'interestIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltSet, [FullType(String)]),
                  )
                  as BuiltSet<String>?;
          result.interestIds = Optional.present(valueDes);
          break;
        case r'promptAnswers':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(ProfileChangeFieldsPromptAnswersInner),
                    ]),
                  )
                  as BuiltList<ProfileChangeFieldsPromptAnswersInner>?;
          result.promptAnswers = Optional.present(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProfileChangeFields deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfileChangeFieldsBuilder();
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
