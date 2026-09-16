//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_error_violations_inner.g.dart';

/// ApiErrorViolationsInner
///
/// Properties:
/// * [field]
/// * [reason]
@BuiltValue()
abstract class ApiErrorViolationsInner
    implements Built<ApiErrorViolationsInner, ApiErrorViolationsInnerBuilder> {
  @BuiltValueField(wireName: r'field')
  ApiErrorViolationsInnerFieldEnum get field;
  // enum fieldEnum {  body,  expectedRevision,  door,  keywordFilters,  refreshToken,  profileId,  changeId,  operationId,  idempotencyKey,  replacesChangeId,  changes,  changes.nickname,  changes.cityId,  changes.representation,  changes.bio,  changes.interestIds,  changes.promptAnswers,  nudgeToken,  targetProfileId,  contextToken,  text,  anchor,  anchorKind,  anchorId,  anchorRevision,  submissionId,  replacesSubmissionId,  cursor,  limit,  exchangeId,  operationKind,  expectedLifecycleRevision,  view,  folder,  blockId,  reportId,  messageId,  targetKind,  locale,  reasonId,  reasonCatalogRevision,  context,  hidden,  privateLabel,  };

  @BuiltValueField(wireName: r'reason')
  ApiErrorViolationsInnerReasonEnum get reason;
  // enum reasonEnum {  REQUIRED,  INVALID,  TOO_SHORT,  TOO_LONG,  TOO_MANY,  UNEXPECTED_FIELD,  };

  ApiErrorViolationsInner._();

  factory ApiErrorViolationsInner([
    void updates(ApiErrorViolationsInnerBuilder b),
  ]) = _$ApiErrorViolationsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiErrorViolationsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiErrorViolationsInner> get serializer =>
      _$ApiErrorViolationsInnerSerializer();
}

class _$ApiErrorViolationsInnerSerializer
    implements PrimitiveSerializer<ApiErrorViolationsInner> {
  @override
  final Iterable<Type> types = const [
    ApiErrorViolationsInner,
    _$ApiErrorViolationsInner,
  ];

  @override
  final String wireName = r'ApiErrorViolationsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiErrorViolationsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'field';
    yield serializers.serialize(
      object.field,
      specifiedType: const FullType(ApiErrorViolationsInnerFieldEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(ApiErrorViolationsInnerReasonEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiErrorViolationsInner object, {
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
    required ApiErrorViolationsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'field':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      ApiErrorViolationsInnerFieldEnum,
                    ),
                  )
                  as ApiErrorViolationsInnerFieldEnum;
          result.field = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      ApiErrorViolationsInnerReasonEnum,
                    ),
                  )
                  as ApiErrorViolationsInnerReasonEnum;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiErrorViolationsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiErrorViolationsInnerBuilder();
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

class ApiErrorViolationsInnerFieldEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'body')
  static const ApiErrorViolationsInnerFieldEnum body =
      _$apiErrorViolationsInnerFieldEnum_body;
  @BuiltValueEnumConst(wireName: r'expectedRevision')
  static const ApiErrorViolationsInnerFieldEnum expectedRevision =
      _$apiErrorViolationsInnerFieldEnum_expectedRevision;
  @BuiltValueEnumConst(wireName: r'door')
  static const ApiErrorViolationsInnerFieldEnum door =
      _$apiErrorViolationsInnerFieldEnum_door;
  @BuiltValueEnumConst(wireName: r'keywordFilters')
  static const ApiErrorViolationsInnerFieldEnum keywordFilters =
      _$apiErrorViolationsInnerFieldEnum_keywordFilters;
  @BuiltValueEnumConst(wireName: r'refreshToken')
  static const ApiErrorViolationsInnerFieldEnum refreshToken =
      _$apiErrorViolationsInnerFieldEnum_refreshToken;
  @BuiltValueEnumConst(wireName: r'profileId')
  static const ApiErrorViolationsInnerFieldEnum profileId =
      _$apiErrorViolationsInnerFieldEnum_profileId;
  @BuiltValueEnumConst(wireName: r'changeId')
  static const ApiErrorViolationsInnerFieldEnum changeId =
      _$apiErrorViolationsInnerFieldEnum_changeId;
  @BuiltValueEnumConst(wireName: r'operationId')
  static const ApiErrorViolationsInnerFieldEnum operationId =
      _$apiErrorViolationsInnerFieldEnum_operationId;
  @BuiltValueEnumConst(wireName: r'idempotencyKey')
  static const ApiErrorViolationsInnerFieldEnum idempotencyKey =
      _$apiErrorViolationsInnerFieldEnum_idempotencyKey;
  @BuiltValueEnumConst(wireName: r'replacesChangeId')
  static const ApiErrorViolationsInnerFieldEnum replacesChangeId =
      _$apiErrorViolationsInnerFieldEnum_replacesChangeId;
  @BuiltValueEnumConst(wireName: r'changes')
  static const ApiErrorViolationsInnerFieldEnum changes =
      _$apiErrorViolationsInnerFieldEnum_changes;
  @BuiltValueEnumConst(wireName: r'changes.nickname')
  static const ApiErrorViolationsInnerFieldEnum changesPeriodNickname =
      _$apiErrorViolationsInnerFieldEnum_changesPeriodNickname;
  @BuiltValueEnumConst(wireName: r'changes.cityId')
  static const ApiErrorViolationsInnerFieldEnum changesPeriodCityId =
      _$apiErrorViolationsInnerFieldEnum_changesPeriodCityId;
  @BuiltValueEnumConst(wireName: r'changes.representation')
  static const ApiErrorViolationsInnerFieldEnum changesPeriodRepresentation =
      _$apiErrorViolationsInnerFieldEnum_changesPeriodRepresentation;
  @BuiltValueEnumConst(wireName: r'changes.bio')
  static const ApiErrorViolationsInnerFieldEnum changesPeriodBio =
      _$apiErrorViolationsInnerFieldEnum_changesPeriodBio;
  @BuiltValueEnumConst(wireName: r'changes.interestIds')
  static const ApiErrorViolationsInnerFieldEnum changesPeriodInterestIds =
      _$apiErrorViolationsInnerFieldEnum_changesPeriodInterestIds;
  @BuiltValueEnumConst(wireName: r'changes.promptAnswers')
  static const ApiErrorViolationsInnerFieldEnum changesPeriodPromptAnswers =
      _$apiErrorViolationsInnerFieldEnum_changesPeriodPromptAnswers;
  @BuiltValueEnumConst(wireName: r'nudgeToken')
  static const ApiErrorViolationsInnerFieldEnum nudgeToken =
      _$apiErrorViolationsInnerFieldEnum_nudgeToken;
  @BuiltValueEnumConst(wireName: r'targetProfileId')
  static const ApiErrorViolationsInnerFieldEnum targetProfileId =
      _$apiErrorViolationsInnerFieldEnum_targetProfileId;
  @BuiltValueEnumConst(wireName: r'contextToken')
  static const ApiErrorViolationsInnerFieldEnum contextToken =
      _$apiErrorViolationsInnerFieldEnum_contextToken;
  @BuiltValueEnumConst(wireName: r'text')
  static const ApiErrorViolationsInnerFieldEnum text =
      _$apiErrorViolationsInnerFieldEnum_text;
  @BuiltValueEnumConst(wireName: r'anchor')
  static const ApiErrorViolationsInnerFieldEnum anchor =
      _$apiErrorViolationsInnerFieldEnum_anchor;
  @BuiltValueEnumConst(wireName: r'anchorKind')
  static const ApiErrorViolationsInnerFieldEnum anchorKind =
      _$apiErrorViolationsInnerFieldEnum_anchorKind;
  @BuiltValueEnumConst(wireName: r'anchorId')
  static const ApiErrorViolationsInnerFieldEnum anchorId =
      _$apiErrorViolationsInnerFieldEnum_anchorId;
  @BuiltValueEnumConst(wireName: r'anchorRevision')
  static const ApiErrorViolationsInnerFieldEnum anchorRevision =
      _$apiErrorViolationsInnerFieldEnum_anchorRevision;
  @BuiltValueEnumConst(wireName: r'submissionId')
  static const ApiErrorViolationsInnerFieldEnum submissionId =
      _$apiErrorViolationsInnerFieldEnum_submissionId;
  @BuiltValueEnumConst(wireName: r'replacesSubmissionId')
  static const ApiErrorViolationsInnerFieldEnum replacesSubmissionId =
      _$apiErrorViolationsInnerFieldEnum_replacesSubmissionId;
  @BuiltValueEnumConst(wireName: r'cursor')
  static const ApiErrorViolationsInnerFieldEnum cursor =
      _$apiErrorViolationsInnerFieldEnum_cursor;
  @BuiltValueEnumConst(wireName: r'limit')
  static const ApiErrorViolationsInnerFieldEnum limit =
      _$apiErrorViolationsInnerFieldEnum_limit;
  @BuiltValueEnumConst(wireName: r'exchangeId')
  static const ApiErrorViolationsInnerFieldEnum exchangeId =
      _$apiErrorViolationsInnerFieldEnum_exchangeId;
  @BuiltValueEnumConst(wireName: r'operationKind')
  static const ApiErrorViolationsInnerFieldEnum operationKind =
      _$apiErrorViolationsInnerFieldEnum_operationKind;
  @BuiltValueEnumConst(wireName: r'expectedLifecycleRevision')
  static const ApiErrorViolationsInnerFieldEnum expectedLifecycleRevision =
      _$apiErrorViolationsInnerFieldEnum_expectedLifecycleRevision;
  @BuiltValueEnumConst(wireName: r'view')
  static const ApiErrorViolationsInnerFieldEnum view =
      _$apiErrorViolationsInnerFieldEnum_view;
  @BuiltValueEnumConst(wireName: r'folder')
  static const ApiErrorViolationsInnerFieldEnum folder =
      _$apiErrorViolationsInnerFieldEnum_folder;
  @BuiltValueEnumConst(wireName: r'blockId')
  static const ApiErrorViolationsInnerFieldEnum blockId =
      _$apiErrorViolationsInnerFieldEnum_blockId;
  @BuiltValueEnumConst(wireName: r'reportId')
  static const ApiErrorViolationsInnerFieldEnum reportId =
      _$apiErrorViolationsInnerFieldEnum_reportId;
  @BuiltValueEnumConst(wireName: r'messageId')
  static const ApiErrorViolationsInnerFieldEnum messageId =
      _$apiErrorViolationsInnerFieldEnum_messageId;
  @BuiltValueEnumConst(wireName: r'targetKind')
  static const ApiErrorViolationsInnerFieldEnum targetKind =
      _$apiErrorViolationsInnerFieldEnum_targetKind;
  @BuiltValueEnumConst(wireName: r'locale')
  static const ApiErrorViolationsInnerFieldEnum locale =
      _$apiErrorViolationsInnerFieldEnum_locale;
  @BuiltValueEnumConst(wireName: r'reasonId')
  static const ApiErrorViolationsInnerFieldEnum reasonId =
      _$apiErrorViolationsInnerFieldEnum_reasonId;
  @BuiltValueEnumConst(wireName: r'reasonCatalogRevision')
  static const ApiErrorViolationsInnerFieldEnum reasonCatalogRevision =
      _$apiErrorViolationsInnerFieldEnum_reasonCatalogRevision;
  @BuiltValueEnumConst(wireName: r'context')
  static const ApiErrorViolationsInnerFieldEnum context =
      _$apiErrorViolationsInnerFieldEnum_context;
  @BuiltValueEnumConst(wireName: r'hidden')
  static const ApiErrorViolationsInnerFieldEnum hidden =
      _$apiErrorViolationsInnerFieldEnum_hidden;
  @BuiltValueEnumConst(wireName: r'privateLabel')
  static const ApiErrorViolationsInnerFieldEnum privateLabel =
      _$apiErrorViolationsInnerFieldEnum_privateLabel;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ApiErrorViolationsInnerFieldEnum unknownDefaultOpenApi =
      _$apiErrorViolationsInnerFieldEnum_unknownDefaultOpenApi;

  static Serializer<ApiErrorViolationsInnerFieldEnum> get serializer =>
      _$apiErrorViolationsInnerFieldEnumSerializer;

  const ApiErrorViolationsInnerFieldEnum._(String name) : super(name);

  static BuiltSet<ApiErrorViolationsInnerFieldEnum> get values =>
      _$apiErrorViolationsInnerFieldEnumValues;
  static ApiErrorViolationsInnerFieldEnum valueOf(String name) =>
      _$apiErrorViolationsInnerFieldEnumValueOf(name);
}

class ApiErrorViolationsInnerReasonEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'REQUIRED')
  static const ApiErrorViolationsInnerReasonEnum REQUIRED =
      _$apiErrorViolationsInnerReasonEnum_REQUIRED;
  @BuiltValueEnumConst(wireName: r'INVALID')
  static const ApiErrorViolationsInnerReasonEnum INVALID =
      _$apiErrorViolationsInnerReasonEnum_INVALID;
  @BuiltValueEnumConst(wireName: r'TOO_SHORT')
  static const ApiErrorViolationsInnerReasonEnum TOO_SHORT =
      _$apiErrorViolationsInnerReasonEnum_TOO_SHORT;
  @BuiltValueEnumConst(wireName: r'TOO_LONG')
  static const ApiErrorViolationsInnerReasonEnum TOO_LONG =
      _$apiErrorViolationsInnerReasonEnum_TOO_LONG;
  @BuiltValueEnumConst(wireName: r'TOO_MANY')
  static const ApiErrorViolationsInnerReasonEnum TOO_MANY =
      _$apiErrorViolationsInnerReasonEnum_TOO_MANY;
  @BuiltValueEnumConst(wireName: r'UNEXPECTED_FIELD')
  static const ApiErrorViolationsInnerReasonEnum UNEXPECTED_FIELD =
      _$apiErrorViolationsInnerReasonEnum_UNEXPECTED_FIELD;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ApiErrorViolationsInnerReasonEnum unknownDefaultOpenApi =
      _$apiErrorViolationsInnerReasonEnum_unknownDefaultOpenApi;

  static Serializer<ApiErrorViolationsInnerReasonEnum> get serializer =>
      _$apiErrorViolationsInnerReasonEnumSerializer;

  const ApiErrorViolationsInnerReasonEnum._(String name) : super(name);

  static BuiltSet<ApiErrorViolationsInnerReasonEnum> get values =>
      _$apiErrorViolationsInnerReasonEnumValues;
  static ApiErrorViolationsInnerReasonEnum valueOf(String name) =>
      _$apiErrorViolationsInnerReasonEnumValueOf(name);
}
