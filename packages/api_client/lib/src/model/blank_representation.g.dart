// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blank_representation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BlankRepresentationKindEnum _$blankRepresentationKindEnum_BLANK =
    const BlankRepresentationKindEnum._('BLANK');
const BlankRepresentationKindEnum
_$blankRepresentationKindEnum_unknownDefaultOpenApi =
    const BlankRepresentationKindEnum._('unknownDefaultOpenApi');

BlankRepresentationKindEnum _$blankRepresentationKindEnumValueOf(String name) {
  switch (name) {
    case 'BLANK':
      return _$blankRepresentationKindEnum_BLANK;
    case 'unknownDefaultOpenApi':
      return _$blankRepresentationKindEnum_unknownDefaultOpenApi;
    default:
      return _$blankRepresentationKindEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<BlankRepresentationKindEnum>
_$blankRepresentationKindEnumValues =
    BuiltSet<BlankRepresentationKindEnum>(const <BlankRepresentationKindEnum>[
      _$blankRepresentationKindEnum_BLANK,
      _$blankRepresentationKindEnum_unknownDefaultOpenApi,
    ]);

Serializer<BlankRepresentationKindEnum>
_$blankRepresentationKindEnumSerializer =
    _$BlankRepresentationKindEnumSerializer();

class _$BlankRepresentationKindEnumSerializer
    implements PrimitiveSerializer<BlankRepresentationKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BLANK': 'BLANK',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BLANK': 'BLANK',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[BlankRepresentationKindEnum];
  @override
  final String wireName = 'BlankRepresentationKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    BlankRepresentationKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  BlankRepresentationKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => BlankRepresentationKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$BlankRepresentation extends BlankRepresentation {
  @override
  final BlankRepresentationKindEnum kind;

  factory _$BlankRepresentation([
    void Function(BlankRepresentationBuilder)? updates,
  ]) => (BlankRepresentationBuilder()..update(updates))._build();

  _$BlankRepresentation._({required this.kind}) : super._();
  @override
  BlankRepresentation rebuild(
    void Function(BlankRepresentationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  BlankRepresentationBuilder toBuilder() =>
      BlankRepresentationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlankRepresentation && kind == other.kind;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'BlankRepresentation',
    )..add('kind', kind)).toString();
  }
}

class BlankRepresentationBuilder
    implements Builder<BlankRepresentation, BlankRepresentationBuilder> {
  _$BlankRepresentation? _$v;

  BlankRepresentationKindEnum? _kind;
  BlankRepresentationKindEnum? get kind => _$this._kind;
  set kind(BlankRepresentationKindEnum? kind) => _$this._kind = kind;

  BlankRepresentationBuilder() {
    BlankRepresentation._defaults(this);
  }

  BlankRepresentationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BlankRepresentation other) {
    _$v = other as _$BlankRepresentation;
  }

  @override
  void update(void Function(BlankRepresentationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BlankRepresentation build() => _build();

  _$BlankRepresentation _build() {
    final _$result =
        _$v ??
        _$BlankRepresentation._(
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'BlankRepresentation',
            'kind',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
