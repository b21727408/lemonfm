//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ContractFixtureResponse {
  /// Returns a new [ContractFixtureResponse] instance.
  ContractFixtureResponse({
    required this.fixture,
  });

  ContractFixtureResponseFixtureEnum fixture;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ContractFixtureResponse &&
    other.fixture == fixture;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fixture.hashCode);

  @override
  String toString() => 'ContractFixtureResponse[fixture=$fixture]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fixture'] = this.fixture;
    return json;
  }

  /// Returns a new [ContractFixtureResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ContractFixtureResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'fixture'), 'Required key "ContractFixtureResponse[fixture]" is missing from JSON.');
        assert(json[r'fixture'] != null, 'Required key "ContractFixtureResponse[fixture]" has a null value in JSON.');
        return true;
      }());

      return ContractFixtureResponse(
        fixture: ContractFixtureResponseFixtureEnum.fromJson(json[r'fixture'])!,
      );
    }
    return null;
  }

  static List<ContractFixtureResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ContractFixtureResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ContractFixtureResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ContractFixtureResponse> mapFromJson(dynamic json) {
    final map = <String, ContractFixtureResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ContractFixtureResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ContractFixtureResponse-objects as value to a dart map
  static Map<String, List<ContractFixtureResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ContractFixtureResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ContractFixtureResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fixture',
  };
}


enum ContractFixtureResponseFixtureEnum {
  publicV1._(r'public-v1'),
  unknownDefaultOpenApi._(r'unknown_default_open_api'),
  ;

  /// Instantiate a new enum with the provided value.
  const ContractFixtureResponseFixtureEnum._(this._value);

  /// The underlying value of this enum member.
  final String _value;

  @override
  String toString() => _value;

  /// Encodes this enum as a value suitable for JSON.
  String toJson() => _value;

  /// Returns the instance of [ContractFixtureResponseFixtureEnum] that was successfully decoded
  /// from the passed [value] on success, null otherwise.
  static ContractFixtureResponseFixtureEnum? fromJson(dynamic value) => ContractFixtureResponseFixtureEnumTypeTransformer().decode(value);

  /// Returns a [List] containing instances of [ContractFixtureResponseFixtureEnum]
  /// that were successfully decoded from the passed [JSON][json].
  static List<ContractFixtureResponseFixtureEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ContractFixtureResponseFixtureEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ContractFixtureResponseFixtureEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ContractFixtureResponseFixtureEnum] to String,
/// and [decode] dynamic data back to [ContractFixtureResponseFixtureEnum].
class ContractFixtureResponseFixtureEnumTypeTransformer {
  factory ContractFixtureResponseFixtureEnumTypeTransformer() => _instance ??= const ContractFixtureResponseFixtureEnumTypeTransformer._();

  const ContractFixtureResponseFixtureEnumTypeTransformer._();

  String encode(ContractFixtureResponseFixtureEnum data) => data._value;

  /// Returns the instance of [ContractFixtureResponseFixtureEnum] that was successfully decoded
  /// from the passed [data] value on success, null otherwise.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ContractFixtureResponseFixtureEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data is ContractFixtureResponseFixtureEnum) {
      return data;
    }
    if (data != null) {
      switch (data) {
        case r'public-v1': return ContractFixtureResponseFixtureEnum.publicV1;
        case r'unknown_default_open_api': return ContractFixtureResponseFixtureEnum.unknownDefaultOpenApi;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// The singleton instance of this transformer.
  static ContractFixtureResponseFixtureEnumTypeTransformer? _instance;
}


