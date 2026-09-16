//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:api_client/src/api_util.dart';
import 'package:api_client/src/model/acknowledge_profile_change.dart';
import 'package:api_client/src/model/api_error.dart';
import 'package:api_client/src/model/latest_profile_change.dart';
import 'package:api_client/src/model/member_profile.dart';
import 'package:api_client/src/model/my_profile.dart';
import 'package:api_client/src/model/profile_change.dart';
import 'package:api_client/src/model/submit_profile_change.dart';

class ProfilesApi {
  final Dio _dio;

  final Serializers _serializers;

  const ProfilesApi(this._dio, this._serializers);

  /// Explicitly acknowledge the current warning for my immutable submission
  /// Require the owner, currently readable candidate content, AWAITING_ACKNOWLEDGEMENT state and the exact current nudgeToken, bound to this candidate&#39;s content, author and policy. No edited text is accepted here. Replaced/canceled/otherwise ineligible state uses PROFILE_CHANGE_CONFLICT; an obsolete or mismatched challenge uses MODERATION_CONTEXT_CHANGED. Read current state and explicitly act on a usable prompt or submit a replacement; never auto-acknowledge a new one. Record acknowledgement and required continuation work atomically under the account guard. Then continue checks outside the transaction as needed; acknowledgement is not publication and cannot bypass a rejection, human review or current publication predicates. No second Save is needed when the still-current candidate becomes fully eligible for application. Bind Idempotency-Key to author, this operation kind, changeId and token. A known committed replay resolves before current prompt/state checks and returns the candidate&#39;s permitted current projection without acknowledging again. For uncertain results, read this known candidate; if still pending, only retry the same action identity and body within the replay rules.
  ///
  /// Parameters:
  /// * [changeId] - An immutable profile-submission identity; ownership is checked separately.
  /// * [idempotencyKey] - Nonpersonal random action identity, retained across retries of this exact action. A different user action gets a new key. Never an access credential.
  /// * [acknowledgeProfileChange]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ProfileChange] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ProfileChange>> acknowledgeMyProfileChange({
    required String changeId,
    required String idempotencyKey,
    required AcknowledgeProfileChange acknowledgeProfileChange,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/me/profile/changes/{changeId}/acknowledge'.replaceAll(
      '{'
      r'changeId'
      '}',
      encodeQueryParameter(
        _serializers,
        changeId,
        const FullType(String),
      ).toString(),
    );
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'Idempotency-Key': idempotencyKey,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'memberBearer'},
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(AcknowledgeProfileChange);
      _bodyData = _serializers.serialize(
        acknowledgeProfileChange,
        specifiedType: _type,
      );
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(_dio.options, _path),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ProfileChange? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
                  rawResponse,
                  specifiedType: const FullType(ProfileChange),
                )
                as ProfileChange;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ProfileChange>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Cancel my still-pending profile change
  /// Require the candidate owner; reject a nonempty body with 400 INVALID_INPUT. Under the account guard, a current PROCESSING, AWAITING_ACKNOWLEDGEMENT or AWAITING_REVIEW candidate becomes CANCELED. Repeated cancellation of an already CANCELED candidate returns that state. APPLIED, REJECTED, NOT_APPLIED or SUPERSEDED yields 409 PROFILE_CHANGE_CONFLICT without a cancellation claim. This targets an immutable candidate ID, never the account&#39;s latest candidate implicitly; a newer replacement is unaffected. Bind Idempotency-Key to author, this operation kind and changeId. Cancellation, replacement and application have one guarded outcome. If cancellation commits first, late results cannot apply it. If application commits first, return conflict and let the owner read the actual outcome. Resolve a known committed action replay before current state checks, returning the same candidate&#39;s currently permitted projection. Reconcile a lost response by the known candidate ID; keep the original action key on retries. Cancellation is not deletion of case evidence; D4 governs any retained content and references.
  ///
  /// Parameters:
  /// * [changeId] - An immutable profile-submission identity; ownership is checked separately.
  /// * [idempotencyKey] - Nonpersonal random action identity, retained across retries of this exact action. A different user action gets a new key. Never an access credential.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ProfileChange] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ProfileChange>> cancelMyProfileChange({
    required String changeId,
    required String idempotencyKey,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/me/profile/changes/{changeId}/cancel'.replaceAll(
      '{'
      r'changeId'
      '}',
      encodeQueryParameter(
        _serializers,
        changeId,
        const FullType(String),
      ).toString(),
    );
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'Idempotency-Key': idempotencyKey,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'memberBearer'},
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ProfileChange? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
                  rawResponse,
                  specifiedType: const FullType(ProfileChange),
                )
                as ProfileChange;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ProfileChange>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Read member-visible fields of an accessible profile
  /// Require the caller&#39;s active verified account and browsing-ready profile. Authorize the target&#39;s current member-visible profile under Domain; possession of profileId is not authorization. Missing, unpublished or otherwise inaccessible targets share 404 PROFILE_UNAVAILABLE with no private reason. A caller lacking browsing access receives 403 independently of whether the target exists. No public unauthenticated profile lookup. Return only accepted, currently visible Profile-owned content. Remove retired catalog items and unavailable media references from the current view without rewriting historical exchange snapshots. Never expose private account/session IDs, self-edit revision, readiness, keyword filters, refusal state, an existing exchange ID, or a hidden association between this profile and an anonymous participant. This read grants no contact permission and does not replace an admission check. Quiz collections are composed through their own approved contract; absence of a collection field here must not display an empty collection. Catalog and media references require their feature&#39;s authorized resolver. This operation alone does not constitute the complete profile screen.
  ///
  /// Parameters:
  /// * [profileId] - Public profile resource ID, never a private account or conversation handle.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [MemberProfile] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<MemberProfile>> getMemberProfile({
    required String profileId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/profiles/{profileId}'.replaceAll(
      '{'
      r'profileId'
      '}',
      encodeQueryParameter(
        _serializers,
        profileId,
        const FullType(String),
      ).toString(),
    );
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'memberBearer'},
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    MemberProfile? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
                  rawResponse,
                  specifiedType: const FullType(MemberProfile),
                )
                as MemberProfile;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<MemberProfile>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Read my latest retained profile submission, including its completed outcome
  /// Use the same owner access as getMyProfile, including before setup. Select by server registration order under the account guard, not device time or last status-update time. Return the latest retained candidate even when terminal; a live candidate is PROCESSING, AWAITING_ACKNOWLEDGEMENT or AWAITING_REVIEW. change is null when no candidate is retained. This is neither a history list nor evidence that a particular timed-out submission failed; reconcile that operation by ID. Reading does not submit, acknowledge, cancel, publish or extend retention.
  ///
  /// Parameters:
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [LatestProfileChange] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<LatestProfileChange>> getMyLatestProfileChange({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/me/profile/changes/latest';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'memberBearer'},
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    LatestProfileChange? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
                  rawResponse,
                  specifiedType: const FullType(LatestProfileChange),
                )
                as LatestProfileChange;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<LatestProfileChange>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Read my saved profile fields and setup readiness
  /// Resolve the owner from the active verified member session, including before profile setup or quiz completion. Return 200 INCOMPLETE for an account with no saved profile: profileId, nickname, cityId and bio are null; representation is BLANK; interestIds and promptAnswers are empty. Supply an opaque self-profile revision without publishing or allocating a public profile merely because it was read. Return the current saved profile values, not unapproved moderation submissions or another device&#39;s unsaved edits. READY requires the accepted nickname and a supported selected city. Photo, avatar, bio, interests, prompts and quiz completion are not readiness requirements. The server computes readiness; a client cannot submit it as permission. This view contains Profile-owned fields only. Quiz collection and completion views belong to the quiz contract and are not fabricated as empty or false here. Catalog IDs identify authored city, interest, prompt and representation content; localized catalog reads and media delivery are supplied with those features. No phone or trust data.
  ///
  /// Parameters:
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [MyProfile] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<MyProfile>> getMyProfile({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/me/profile';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'memberBearer'},
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    MyProfile? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
                  rawResponse,
                  specifiedType: const FullType(MyProfile),
                )
                as MyProfile;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<MyProfile>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Read the current state of my submitted change
  /// Authorize the candidate owner independently of identifier possession. Another member, staff credentials on the consumer route and an anonymous request participant cannot read it. A foreign/missing/removed candidate has the same 404 PROFILE_CHANGE_UNAVAILABLE. Return current state; APPLIED records a historical commit, not the current profile snapshot. Retention or safety may omit changes without allowing replay to restore withheld text. The response never includes staff evidence or trust state.
  ///
  /// Parameters:
  /// * [changeId] - An immutable profile-submission identity; ownership is checked separately.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ProfileChange] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ProfileChange>> getMyProfileChange({
    required String changeId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/me/profile/changes/{changeId}'.replaceAll(
      '{'
      r'changeId'
      '}',
      encodeQueryParameter(
        _serializers,
        changeId,
        const FullType(String),
      ).toString(),
    );
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'memberBearer'},
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ProfileChange? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
                  rawResponse,
                  specifiedType: const FullType(ProfileChange),
                )
                as ProfileChange;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ProfileChange>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Recover a profile submission when its creation response was lost
  /// Lookup only the authenticated author&#39;s submitMyProfileChange operation namespace. operationId is the Idempotency-Key used for that creation, not a diagnostic requestId, cancellation or acknowledgement operation. Return the same current authorized projection as getMyProfileChange. Missing, inaccessible and no-longer-retained results share 404 PROFILE_CHANGE_UNAVAILABLE. A 404 while creation may be running is inconclusive; do not silently mint a new submission key.
  ///
  /// Parameters:
  /// * [operationId]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ProfileChange] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ProfileChange>> getMyProfileChangeByOperation({
    required String operationId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/me/profile/changes/by-operation/{operationId}'
        .replaceAll(
          '{'
          r'operationId'
          '}',
          encodeQueryParameter(
            _serializers,
            operationId,
            const FullType(String),
          ).toString(),
        );
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'memberBearer'},
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ProfileChange? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
                  rawResponse,
                  specifiedType: const FullType(ProfileChange),
                )
                as ProfileChange;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ProfileChange>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Submit an immutable profile change, optionally replacing a pending one
  /// Require the author&#39;s active verified account; profile readiness and quiz completion are not prerequisites. Resolve ownership from the bearer. Validate and normalize the input, then under the account guard compare expectedRevision with the current saved profile revision and check any pending replacement. Register the candidate, operation digest and durable processing work atomically. No provider call runs inside that transaction. A pending candidate can be replaced only by explicitly naming its owned replacesChangeId. Omitting it while another candidate is active, or naming an owned candidate that is no longer the current pending one, yields 409 PROFILE_CHANGE_CONFLICT. A foreign or missing replacement target yields 404 PROFILE_CHANGE_UNAVAILABLE. A successful registration marks the old candidate SUPERSEDED in the same commit. Failure before this registration leaves it intact. Later rejection or check failure of the replacement cannot reactivate the old candidate. changes is a complete new patch relative to the saved profile revision, not an overlay on the previous candidate. Omitted fields preserve saved values; include pending edits the author intends to keep. null clears bio only; empty arrays clear interests or prompts; BLANK clears the representation. No caller-supplied publication, ownership or trust fields. Return 201 for a newly registered candidate, not proof of publication. Processing may finish before the response or continue durably afterwards; state determines the outcome. A current valid automatically allowed save is applied without another Save; human review and nudges have the states defined by ProfileChange. Exact published fields still come from getMyProfile. Idempotency scope is author plus this operation kind. Bind the digest to expectedRevision, replacesChangeId and the normalized patch including omission/null/list semantics. A known committed replay returns 200 with the same changeId and its currently permitted state before checking stale revisions or current pending work; changed payload uses OPERATION_CONFLICT. After a lost response, use getMyProfileChangeByOperation. A lookup miss while registration is in flight is not proof of failure. Retain domain operation uniqueness with the candidate; D4 governs its record lifetime.
  ///
  /// Parameters:
  /// * [idempotencyKey] - Nonpersonal random action identity, retained across retries of this exact action. A different user action gets a new key. Never an access credential.
  /// * [submitProfileChange]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ProfileChange] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ProfileChange>> submitMyProfileChange({
    required String idempotencyKey,
    required SubmitProfileChange submitProfileChange,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/me/profile/changes';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'Idempotency-Key': idempotencyKey,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'memberBearer'},
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(SubmitProfileChange);
      _bodyData = _serializers.serialize(
        submitProfileChange,
        specifiedType: _type,
      );
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(_dio.options, _path),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ProfileChange? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
                  rawResponse,
                  specifiedType: const FullType(ProfileChange),
                )
                as ProfileChange;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ProfileChange>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }
}
