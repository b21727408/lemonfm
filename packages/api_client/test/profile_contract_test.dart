import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:api_client/api_client.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

final fixtures =
    jsonDecode(File('../../test/fixtures/profile-wire.json').readAsStringSync())
        as Map<String, dynamic>;

Map<String, dynamic> fixture(String name) =>
    (jsonDecode(jsonEncode((fixtures[name] as Map<String, dynamic>)['payload']))
        as Map<String, dynamic>);

const types = <String, Type>{
  'MyProfile': MyProfile,
  'MemberProfile': MemberProfile,
  'SubmitProfileChange': SubmitProfileChange,
  'ProfileChangeFields': ProfileChangeFields,
  'ProfileChange': ProfileChange,
  'ProfileRepresentation': ProfileRepresentation,
  'ProfileRepresentationChange': ProfileRepresentationChange,
  'LatestProfileChange': LatestProfileChange,
  'ApiError': ApiError,
};

Object decode(String schema, Object json) => standardSerializers.deserialize(
  json,
  specifiedType: FullType(types[schema]!),
)!;

Object encode(String schema, Object value) => standardSerializers.serialize(
  value,
  specifiedType: FullType(types[schema]!),
)!;

void main() {
  for (final entry in fixtures.entries) {
    test('expected wire payload: ${entry.key}', () {
      final data = entry.value as Map<String, dynamic>;
      final schema = data['schema'] as String;
      final wire = data['payload'] as Map<String, dynamic>;
      expect(encode(schema, decode(schema, wire)), wire);
    });
  }

  test(
    'both representation unions dispatch every branch without inventing identity',
    () {
      for (final schema in [
        'ProfileRepresentation',
        'ProfileRepresentationChange',
      ]) {
        for (final wire in <Map<String, dynamic>>[
          {'kind': 'BLANK'},
          {'kind': 'AVATAR', 'avatarId': 'avatar-example'},
          {'kind': 'PHOTO', 'mediaId': 'media-example'},
        ]) {
          expect(encode(schema, decode(schema, wire)), wire);
        }
        expect(
          () => decode(schema, {'kind': 'FUTURE', 'mediaId': 'hidden'}),
          throwsA(anything),
        );
        expect(() => decode(schema, {'mediaId': 'hidden'}), throwsA(anything));
      }
    },
  );

  test(
    'unknown lifecycle, readiness and error values remain explicit sentinels',
    () {
      final change =
          decode(
                'ProfileChange',
                fixture('processing')..['state'] = 'FUTURE_ALLOWED',
              )
              as ProfileChange;
      expect(change.state, ProfileChangeStateEnum.unknownDefaultOpenApi);
      expect(change.state, isNot(ProfileChangeStateEnum.APPLIED));
      final profile =
          decode(
                'MyProfile',
                fixture('beforeSetup')..['readiness'] = 'FUTURE_READY',
              )
              as MyProfile;
      expect(profile.readiness, MyProfileReadinessEnum.unknownDefaultOpenApi);
      expect(profile.readiness, isNot(MyProfileReadinessEnum.READY));
      final error =
          decode('ApiError', {
                'code': 'FUTURE_ERROR',
                'requestId': 'req-synthetic',
              })
              as ApiError;
      expect(error.code, ApiErrorCodeEnum.unknownDefaultOpenApi);
      // Feature mapping must reconcile sentinels and never submit a guessed action.
    },
  );

  test(
    'timestamps, large decimal strings and additive response fields survive',
    () {
      final change =
          decode('ProfileChange', fixture('processing')..['futureField'] = true)
              as ProfileChange;
      expect(
        BigInt.parse(change.stateVersion),
        BigInt.parse('900719925474099312345678901234567890'),
      );
      expect(change.createdAt, DateTime.utc(2030, 1, 1, 12, 0, 0, 123, 456));
      expect(change.createdAt.isUtc, isTrue);
      expect(encode('ProfileChange', change), fixture('processing'));
      expect(
        () => decode(
          'ProfileChange',
          fixture('processing')..['stateVersion'] = 42,
        ),
        throwsA(anything),
      );
      expect(
        () => decode(
          'ProfileChange',
          fixture('processing')..['createdAt'] = 'not-a-date',
        ),
        throwsA(anything),
      );
    },
  );

  test(
    'generated models do not enforce JSON Schema conditional or semantic constraints',
    () {
      // Java's schema tests reject these same wire shapes. Decoding alone is not validation.
      final missingApplied = fixture('applied')..remove('appliedAt');
      expect(
        encode('ProfileChange', decode('ProfileChange', missingApplied)),
        missingApplied,
      );
      final nudgeWithoutChanges = fixture('nudge')..remove('changes');
      expect(
        encode('ProfileChange', decode('ProfileChange', nudgeWithoutChanges)),
        nudgeWithoutChanges,
      );
      final missingNudge = fixture('nudge')..remove('nudge');
      expect(
        encode('ProfileChange', decode('ProfileChange', missingNudge)),
        missingNudge,
      );
      final forbiddenProblem = fixture('processing')
        ..['problem'] = {'code': 'CONTENT_NOT_ALLOWED'};
      expect(
        encode('ProfileChange', decode('ProfileChange', forbiddenProblem)),
        forbiddenProblem,
      );
      final invalidVersion = fixture('processing')..['stateVersion'] = '01';
      expect(
        encode('ProfileChange', decode('ProfileChange', invalidVersion)),
        invalidVersion,
      );
      // Optional non-null properties also require server-side raw-input validation.
      expect(
        encode(
          'ProfileChangeFields',
          decode('ProfileChangeFields', {'nickname': null}),
        ),
        {'nickname': null},
      );
      expect(
        decode('MyProfile', fixture('beforeSetup')..['readiness'] = 'READY'),
        isA<MyProfile>(),
      );
    },
  );

  test(
    'wire transport keeps the clear patch, operation key and typed success response',
    () async {
      final transport = RecordingTransport(201, fixture('processing'));
      final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'))
        ..httpClientAdapter = transport;
      addTearDown(() => dio.close(force: true));
      final response = await ProfilesApi(dio, standardSerializers)
          .submitMyProfileChange(
            idempotencyKey: 'op_profile_example_01',
            submitProfileChange:
                decode('SubmitProfileChange', fixture('clearBio'))
                    as SubmitProfileChange,
          );
      expect(transport.request.method, 'POST');
      expect(transport.request.path, '/v1/me/profile/changes');
      expect(
        transport.request.headers['Idempotency-Key'],
        'op_profile_example_01',
      );
      expect(jsonDecode(transport.body), fixture('clearBio'));
      expect(response.statusCode, 201);
      expect(encode('ProfileChange', response.data!), fixture('processing'));
    },
  );

  test(
    'HTTP failures expose the error body and do not become successful changes',
    () async {
      final transport = RecordingTransport(409, fixture('conflict'));
      final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'))
        ..httpClientAdapter = transport;
      addTearDown(() => dio.close(force: true));
      try {
        await ProfilesApi(dio, standardSerializers).submitMyProfileChange(
          idempotencyKey: 'op_profile_example_01',
          submitProfileChange:
              decode('SubmitProfileChange', fixture('clearBio'))
                  as SubmitProfileChange,
        );
        fail('409 must remain an HTTP failure');
      } on DioException catch (error) {
        expect(error.type, DioExceptionType.badResponse);
        expect(error.response!.statusCode, 409);
        final typed =
            decode('ApiError', error.response!.data as Object) as ApiError;
        expect(typed.code, ApiErrorCodeEnum.REVISION_CONFLICT);
        expect(typed.requestId, 'req-synthetic-conflict');
      }
    },
  );
}

// Test seam at the HTTP boundary; no endpoint or business implementation.
class RecordingTransport implements HttpClientAdapter {
  RecordingTransport(this.status, this.response);
  final int status;
  final Map<String, dynamic> response;
  late RequestOptions request;
  String body = '';

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    if (requestStream != null) body = await utf8.decodeStream(requestStream);
    return ResponseBody.fromString(
      jsonEncode(response),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
