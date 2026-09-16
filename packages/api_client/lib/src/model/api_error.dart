//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/api_error_violations_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:api_client/src/optional.dart';

part 'api_error.g.dart';

/// ApiError
///
/// Properties:
/// * [code]
/// * [requestId] - Nonpersonal diagnostic correlation identifier.
/// * [violations] - Present only for INVALID_INPUT when safe field details are useful. Never echo submitted text, unknown property names or credentials.
/// * [retryAt] - Optional RFC 3339 UTC instant, only for a disclosed technical rate limit, own accepted-request allowance or temporary service retry. Never a hidden enforcement or refusal expiry. Consistent with Retry-After when both appear.
@BuiltValue()
abstract class ApiError implements Built<ApiError, ApiErrorBuilder> {
  @BuiltValueField(wireName: r'code')
  ApiErrorCodeEnum get code;
  // enum codeEnum {  EXCHANGE_UNAVAILABLE,  EXCHANGE_CONTEXT_CHANGED,  EXCHANGE_OPERATION_UNAVAILABLE,  HISTORY_CURSOR_RESET_REQUIRED,  INVALID_INPUT,  AUTHENTICATION_REQUIRED,  ACCESS_UNAVAILABLE,  REVISION_CONFLICT,  RATE_LIMITED,  SERVICE_UNAVAILABLE,  AUTH_REFRESH_INVALID,  PROFILE_UNAVAILABLE,  CONTACT_UNAVAILABLE,  CONTACT_CONTEXT_CHANGED,  QUIZ_REQUIRED,  REQUEST_LIMIT_REACHED,  FIRST_MESSAGE_UNAVAILABLE,  FIRST_MESSAGE_CONFLICT,  PROFILE_CHANGE_UNAVAILABLE,  PROFILE_CHANGE_CONFLICT,  MODERATION_CONTEXT_CHANGED,  OPERATION_CONFLICT,  BLOCK_UNAVAILABLE,  REPORT_UNAVAILABLE,  REPORT_TARGET_UNAVAILABLE,  REPORT_REASON_CHANGED,  };

  /// Nonpersonal diagnostic correlation identifier.
  @BuiltValueField(wireName: r'requestId')
  String get requestId;

  /// Present only for INVALID_INPUT when safe field details are useful. Never echo submitted text, unknown property names or credentials.
  @BuiltValueField(wireName: r'violations')
  Optional<BuiltList<ApiErrorViolationsInner>?> get violations;

  /// Optional RFC 3339 UTC instant, only for a disclosed technical rate limit, own accepted-request allowance or temporary service retry. Never a hidden enforcement or refusal expiry. Consistent with Retry-After when both appear.
  @BuiltValueField(wireName: r'retryAt')
  Optional<DateTime?> get retryAt;

  ApiError._();

  factory ApiError([void updates(ApiErrorBuilder b)]) = _$ApiError;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiErrorBuilder b) => b
    ..violations = Optional.absent()
    ..retryAt = Optional.absent();

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiError> get serializer => _$ApiErrorSerializer();
}

class _$ApiErrorSerializer implements PrimitiveSerializer<ApiError> {
  @override
  final Iterable<Type> types = const [ApiError, _$ApiError];

  @override
  final String wireName = r'ApiError';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiError object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(ApiErrorCodeEnum),
    );
    yield r'requestId';
    yield serializers.serialize(
      object.requestId,
      specifiedType: const FullType(String),
    );
    if (object.violations.isPresent) {
      yield r'violations';
      final optionalValue = object.violations.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType(BuiltList, [
            FullType(ApiErrorViolationsInner),
          ]),
        );
      }
    }
    if (object.retryAt.isPresent) {
      yield r'retryAt';
      final optionalValue = object.retryAt.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(DateTime),
        );
      }
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiError object, {
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
    required ApiErrorBuilder result,
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
                    specifiedType: const FullType(ApiErrorCodeEnum),
                  )
                  as ApiErrorCodeEnum;
          result.code = valueDes;
          break;
        case r'requestId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.requestId = valueDes;
          break;
        case r'violations':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(ApiErrorViolationsInner),
                    ]),
                  )
                  as BuiltList<ApiErrorViolationsInner>?;
          result.violations = Optional.present(valueDes);
          break;
        case r'retryAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          result.retryAt = Optional.present(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiError deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiErrorBuilder();
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

class ApiErrorCodeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'EXCHANGE_UNAVAILABLE')
  static const ApiErrorCodeEnum EXCHANGE_UNAVAILABLE =
      _$apiErrorCodeEnum_EXCHANGE_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'EXCHANGE_CONTEXT_CHANGED')
  static const ApiErrorCodeEnum EXCHANGE_CONTEXT_CHANGED =
      _$apiErrorCodeEnum_EXCHANGE_CONTEXT_CHANGED;
  @BuiltValueEnumConst(wireName: r'EXCHANGE_OPERATION_UNAVAILABLE')
  static const ApiErrorCodeEnum EXCHANGE_OPERATION_UNAVAILABLE =
      _$apiErrorCodeEnum_EXCHANGE_OPERATION_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'HISTORY_CURSOR_RESET_REQUIRED')
  static const ApiErrorCodeEnum HISTORY_CURSOR_RESET_REQUIRED =
      _$apiErrorCodeEnum_HISTORY_CURSOR_RESET_REQUIRED;
  @BuiltValueEnumConst(wireName: r'INVALID_INPUT')
  static const ApiErrorCodeEnum INVALID_INPUT =
      _$apiErrorCodeEnum_INVALID_INPUT;
  @BuiltValueEnumConst(wireName: r'AUTHENTICATION_REQUIRED')
  static const ApiErrorCodeEnum AUTHENTICATION_REQUIRED =
      _$apiErrorCodeEnum_AUTHENTICATION_REQUIRED;
  @BuiltValueEnumConst(wireName: r'ACCESS_UNAVAILABLE')
  static const ApiErrorCodeEnum ACCESS_UNAVAILABLE =
      _$apiErrorCodeEnum_ACCESS_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'REVISION_CONFLICT')
  static const ApiErrorCodeEnum REVISION_CONFLICT =
      _$apiErrorCodeEnum_REVISION_CONFLICT;
  @BuiltValueEnumConst(wireName: r'RATE_LIMITED')
  static const ApiErrorCodeEnum RATE_LIMITED = _$apiErrorCodeEnum_RATE_LIMITED;
  @BuiltValueEnumConst(wireName: r'SERVICE_UNAVAILABLE')
  static const ApiErrorCodeEnum SERVICE_UNAVAILABLE =
      _$apiErrorCodeEnum_SERVICE_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'AUTH_REFRESH_INVALID')
  static const ApiErrorCodeEnum AUTH_REFRESH_INVALID =
      _$apiErrorCodeEnum_AUTH_REFRESH_INVALID;
  @BuiltValueEnumConst(wireName: r'PROFILE_UNAVAILABLE')
  static const ApiErrorCodeEnum PROFILE_UNAVAILABLE =
      _$apiErrorCodeEnum_PROFILE_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'CONTACT_UNAVAILABLE')
  static const ApiErrorCodeEnum CONTACT_UNAVAILABLE =
      _$apiErrorCodeEnum_CONTACT_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'CONTACT_CONTEXT_CHANGED')
  static const ApiErrorCodeEnum CONTACT_CONTEXT_CHANGED =
      _$apiErrorCodeEnum_CONTACT_CONTEXT_CHANGED;
  @BuiltValueEnumConst(wireName: r'QUIZ_REQUIRED')
  static const ApiErrorCodeEnum QUIZ_REQUIRED =
      _$apiErrorCodeEnum_QUIZ_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REQUEST_LIMIT_REACHED')
  static const ApiErrorCodeEnum REQUEST_LIMIT_REACHED =
      _$apiErrorCodeEnum_REQUEST_LIMIT_REACHED;
  @BuiltValueEnumConst(wireName: r'FIRST_MESSAGE_UNAVAILABLE')
  static const ApiErrorCodeEnum FIRST_MESSAGE_UNAVAILABLE =
      _$apiErrorCodeEnum_FIRST_MESSAGE_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'FIRST_MESSAGE_CONFLICT')
  static const ApiErrorCodeEnum FIRST_MESSAGE_CONFLICT =
      _$apiErrorCodeEnum_FIRST_MESSAGE_CONFLICT;
  @BuiltValueEnumConst(wireName: r'PROFILE_CHANGE_UNAVAILABLE')
  static const ApiErrorCodeEnum PROFILE_CHANGE_UNAVAILABLE =
      _$apiErrorCodeEnum_PROFILE_CHANGE_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'PROFILE_CHANGE_CONFLICT')
  static const ApiErrorCodeEnum PROFILE_CHANGE_CONFLICT =
      _$apiErrorCodeEnum_PROFILE_CHANGE_CONFLICT;
  @BuiltValueEnumConst(wireName: r'MODERATION_CONTEXT_CHANGED')
  static const ApiErrorCodeEnum MODERATION_CONTEXT_CHANGED =
      _$apiErrorCodeEnum_MODERATION_CONTEXT_CHANGED;
  @BuiltValueEnumConst(wireName: r'OPERATION_CONFLICT')
  static const ApiErrorCodeEnum OPERATION_CONFLICT =
      _$apiErrorCodeEnum_OPERATION_CONFLICT;
  @BuiltValueEnumConst(wireName: r'BLOCK_UNAVAILABLE')
  static const ApiErrorCodeEnum BLOCK_UNAVAILABLE =
      _$apiErrorCodeEnum_BLOCK_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'REPORT_UNAVAILABLE')
  static const ApiErrorCodeEnum REPORT_UNAVAILABLE =
      _$apiErrorCodeEnum_REPORT_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'REPORT_TARGET_UNAVAILABLE')
  static const ApiErrorCodeEnum REPORT_TARGET_UNAVAILABLE =
      _$apiErrorCodeEnum_REPORT_TARGET_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'REPORT_REASON_CHANGED')
  static const ApiErrorCodeEnum REPORT_REASON_CHANGED =
      _$apiErrorCodeEnum_REPORT_REASON_CHANGED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ApiErrorCodeEnum unknownDefaultOpenApi =
      _$apiErrorCodeEnum_unknownDefaultOpenApi;

  static Serializer<ApiErrorCodeEnum> get serializer =>
      _$apiErrorCodeEnumSerializer;

  const ApiErrorCodeEnum._(String name) : super(name);

  static BuiltSet<ApiErrorCodeEnum> get values => _$apiErrorCodeEnumValues;
  static ApiErrorCodeEnum valueOf(String name) =>
      _$apiErrorCodeEnumValueOf(name);
}
