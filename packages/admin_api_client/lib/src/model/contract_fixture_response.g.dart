// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_fixture_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ContractFixtureResponseFixtureEnum
_$contractFixtureResponseFixtureEnum_adminV1 =
    const ContractFixtureResponseFixtureEnum._('adminV1');
const ContractFixtureResponseFixtureEnum
_$contractFixtureResponseFixtureEnum_unknownDefaultOpenApi =
    const ContractFixtureResponseFixtureEnum._('unknownDefaultOpenApi');

ContractFixtureResponseFixtureEnum _$contractFixtureResponseFixtureEnumValueOf(
  String name,
) {
  switch (name) {
    case 'adminV1':
      return _$contractFixtureResponseFixtureEnum_adminV1;
    case 'unknownDefaultOpenApi':
      return _$contractFixtureResponseFixtureEnum_unknownDefaultOpenApi;
    default:
      return _$contractFixtureResponseFixtureEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<ContractFixtureResponseFixtureEnum>
_$contractFixtureResponseFixtureEnumValues =
    BuiltSet<ContractFixtureResponseFixtureEnum>(
      const <ContractFixtureResponseFixtureEnum>[
        _$contractFixtureResponseFixtureEnum_adminV1,
        _$contractFixtureResponseFixtureEnum_unknownDefaultOpenApi,
      ],
    );

Serializer<ContractFixtureResponseFixtureEnum>
_$contractFixtureResponseFixtureEnumSerializer =
    _$ContractFixtureResponseFixtureEnumSerializer();

class _$ContractFixtureResponseFixtureEnumSerializer
    implements PrimitiveSerializer<ContractFixtureResponseFixtureEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'adminV1': 'admin-v1',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'admin-v1': 'adminV1',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[ContractFixtureResponseFixtureEnum];
  @override
  final String wireName = 'ContractFixtureResponseFixtureEnum';

  @override
  Object serialize(
    Serializers serializers,
    ContractFixtureResponseFixtureEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ContractFixtureResponseFixtureEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ContractFixtureResponseFixtureEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$ContractFixtureResponse extends ContractFixtureResponse {
  @override
  final ContractFixtureResponseFixtureEnum fixture;

  factory _$ContractFixtureResponse([
    void Function(ContractFixtureResponseBuilder)? updates,
  ]) => (ContractFixtureResponseBuilder()..update(updates))._build();

  _$ContractFixtureResponse._({required this.fixture}) : super._();
  @override
  ContractFixtureResponse rebuild(
    void Function(ContractFixtureResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ContractFixtureResponseBuilder toBuilder() =>
      ContractFixtureResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContractFixtureResponse && fixture == other.fixture;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fixture.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ContractFixtureResponse',
    )..add('fixture', fixture)).toString();
  }
}

class ContractFixtureResponseBuilder
    implements
        Builder<ContractFixtureResponse, ContractFixtureResponseBuilder> {
  _$ContractFixtureResponse? _$v;

  ContractFixtureResponseFixtureEnum? _fixture;
  ContractFixtureResponseFixtureEnum? get fixture => _$this._fixture;
  set fixture(ContractFixtureResponseFixtureEnum? fixture) =>
      _$this._fixture = fixture;

  ContractFixtureResponseBuilder() {
    ContractFixtureResponse._defaults(this);
  }

  ContractFixtureResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fixture = $v.fixture;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContractFixtureResponse other) {
    _$v = other as _$ContractFixtureResponse;
  }

  @override
  void update(void Function(ContractFixtureResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContractFixtureResponse build() => _build();

  _$ContractFixtureResponse _build() {
    final _$result =
        _$v ??
        _$ContractFixtureResponse._(
          fixture: BuiltValueNullFieldError.checkNotNull(
            fixture,
            r'ContractFixtureResponse',
            'fixture',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
