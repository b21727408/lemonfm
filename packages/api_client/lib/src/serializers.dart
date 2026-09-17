//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:api_client/src/date_serializer.dart';
import 'package:api_client/src/model/acknowledge_profile_change.dart';
import 'package:api_client/src/model/api_error.dart';
import 'package:api_client/src/model/api_error_violations_inner.dart';
import 'package:api_client/src/model/avatar_representation.dart';
import 'package:api_client/src/model/blank_representation.dart';
import 'package:api_client/src/model/latest_profile_change.dart';
import 'package:api_client/src/model/member_profile.dart';
import 'package:api_client/src/model/my_profile.dart';
import 'package:api_client/src/model/photo_representation.dart';
import 'package:api_client/src/model/profile_change.dart';
import 'package:api_client/src/model/profile_change_fields.dart';
import 'package:api_client/src/model/profile_change_fields_prompt_answers_inner.dart';
import 'package:api_client/src/model/profile_change_nudge.dart';
import 'package:api_client/src/model/profile_change_problem.dart';
import 'package:api_client/src/model/profile_photo_change.dart';
import 'package:api_client/src/model/profile_prompt_answers_inner.dart';
import 'package:api_client/src/model/profile_representation.dart';
import 'package:api_client/src/model/profile_representation_change.dart';
import 'package:api_client/src/model/submit_profile_change.dart';

part 'serializers.g.dart';

@SerializersFor([
  AcknowledgeProfileChange,
  ApiError,
  ApiErrorViolationsInner,
  AvatarRepresentation,
  BlankRepresentation,
  LatestProfileChange,
  MemberProfile,
  MyProfile,
  PhotoRepresentation,
  ProfileChange,
  ProfileChangeFields,
  ProfileChangeFieldsPromptAnswersInner,
  ProfileChangeNudge,
  ProfileChangeProblem,
  ProfilePhotoChange,
  ProfilePromptAnswersInner,
  ProfileRepresentation,
  ProfileRepresentationChange,
  SubmitProfileChange,
])
Serializers serializers =
    (_$serializers.toBuilder()
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ApiErrorViolationsInner)]),
            () => ListBuilder<ApiErrorViolationsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, [FullType(String)]),
            () => SetBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ProfilePromptAnswersInner)]),
            () => ListBuilder<ProfilePromptAnswersInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, [FullType(String)]),
            () => SetBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ProfilePromptAnswersInner)]),
            () => ListBuilder<ProfilePromptAnswersInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, [FullType(String)]),
            () => SetBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [
              FullType(ProfileChangeFieldsPromptAnswersInner),
            ]),
            () => ListBuilder<ProfileChangeFieldsPromptAnswersInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, [FullType(ProfileChangeNudgeFieldsEnum)]),
            () => SetBuilder<ProfileChangeNudgeFieldsEnum>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltSet, [
              FullType(ProfileChangeProblemFieldsEnum),
            ]),
            () => SetBuilder<ProfileChangeProblemFieldsEnum>(),
          )
          ..add(ProfileChangeNudgeFieldsEnum.serializer)
          ..add(ProfileChangeProblemFieldsEnum.serializer)
          ..add(const OneOfSerializer())
          ..add(const AnyOfSerializer())
          ..add(const DateSerializer())
          ..add(Iso8601DateTimeSerializer()))
        .build();
Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(_PresenceJsonPlugin())).build();

// Preserve explicit nulls for model fields before Optional deserialization.
class _PresenceJsonPlugin extends StandardJsonPlugin {
  @override
  Object? beforeDeserialize(Object? object, FullType specifiedType) {
    const modelTypes = <Type>[
      AcknowledgeProfileChange,
      ApiError,
      ApiErrorViolationsInner,
      AvatarRepresentation,
      BlankRepresentation,
      LatestProfileChange,
      MemberProfile,
      MyProfile,
      PhotoRepresentation,
      ProfileChange,
      ProfileChangeFields,
      ProfileChangeFieldsPromptAnswersInner,
      ProfileChangeNudge,
      ProfileChangeProblem,
      ProfilePhotoChange,
      ProfilePromptAnswersInner,
      ProfileRepresentation,
      ProfileRepresentationChange,
      SubmitProfileChange,
    ];
    if (object is Map<String, dynamic> &&
        modelTypes.contains(specifiedType.root)) {
      return <Object?>[
        for (final entry in object.entries) ...[entry.key, entry.value],
      ];
    }
    return super.beforeDeserialize(object, specifiedType);
  }
}
