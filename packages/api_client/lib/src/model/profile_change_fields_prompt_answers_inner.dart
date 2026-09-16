//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'profile_change_fields_prompt_answers_inner.g.dart';

/// ProfileChangeFieldsPromptAnswersInner
///
/// Properties:
/// * [promptId] - Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
/// * [answer]
@BuiltValue()
abstract class ProfileChangeFieldsPromptAnswersInner
    implements
        Built<
          ProfileChangeFieldsPromptAnswersInner,
          ProfileChangeFieldsPromptAnswersInnerBuilder
        > {
  /// Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
  @BuiltValueField(wireName: r'promptId')
  String get promptId;

  @BuiltValueField(wireName: r'answer')
  String get answer;

  ProfileChangeFieldsPromptAnswersInner._();

  factory ProfileChangeFieldsPromptAnswersInner([
    void updates(ProfileChangeFieldsPromptAnswersInnerBuilder b),
  ]) = _$ProfileChangeFieldsPromptAnswersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfileChangeFieldsPromptAnswersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfileChangeFieldsPromptAnswersInner> get serializer =>
      _$ProfileChangeFieldsPromptAnswersInnerSerializer();
}

class _$ProfileChangeFieldsPromptAnswersInnerSerializer
    implements PrimitiveSerializer<ProfileChangeFieldsPromptAnswersInner> {
  @override
  final Iterable<Type> types = const [
    ProfileChangeFieldsPromptAnswersInner,
    _$ProfileChangeFieldsPromptAnswersInner,
  ];

  @override
  final String wireName = r'ProfileChangeFieldsPromptAnswersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfileChangeFieldsPromptAnswersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'promptId';
    yield serializers.serialize(
      object.promptId,
      specifiedType: const FullType(String),
    );
    yield r'answer';
    yield serializers.serialize(
      object.answer,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProfileChangeFieldsPromptAnswersInner object, {
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
    required ProfileChangeFieldsPromptAnswersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'promptId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.promptId = valueDes;
          break;
        case r'answer':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.answer = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProfileChangeFieldsPromptAnswersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfileChangeFieldsPromptAnswersInnerBuilder();
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
