//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'profile_prompt_answers_inner.g.dart';

/// ProfilePromptAnswersInner
///
/// Properties:
/// * [promptId] - Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
/// * [answer] - Accepted normalized member text; not an unreviewed submission.
@BuiltValue()
abstract class ProfilePromptAnswersInner
    implements
        Built<ProfilePromptAnswersInner, ProfilePromptAnswersInnerBuilder> {
  /// Nonpersonal opaque resource identifier. Resource-specific ownership and authorization still apply; IDs are not interchangeable credentials.
  @BuiltValueField(wireName: r'promptId')
  String get promptId;

  /// Accepted normalized member text; not an unreviewed submission.
  @BuiltValueField(wireName: r'answer')
  String get answer;

  ProfilePromptAnswersInner._();

  factory ProfilePromptAnswersInner([
    void updates(ProfilePromptAnswersInnerBuilder b),
  ]) = _$ProfilePromptAnswersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfilePromptAnswersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfilePromptAnswersInner> get serializer =>
      _$ProfilePromptAnswersInnerSerializer();
}

class _$ProfilePromptAnswersInnerSerializer
    implements PrimitiveSerializer<ProfilePromptAnswersInner> {
  @override
  final Iterable<Type> types = const [
    ProfilePromptAnswersInner,
    _$ProfilePromptAnswersInner,
  ];

  @override
  final String wireName = r'ProfilePromptAnswersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfilePromptAnswersInner object, {
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
    ProfilePromptAnswersInner object, {
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
    required ProfilePromptAnswersInnerBuilder result,
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
  ProfilePromptAnswersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfilePromptAnswersInnerBuilder();
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
