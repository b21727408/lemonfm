import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import 'generated/module_policy.dart';

String _path(RuleContext context) =>
    context.definingUnit.file.path.replaceAll('\\', '/');

String? _layerName(String path) {
  final match = RegExp(r'/lib/src/(domain|application|data|presentation)/')
      .firstMatch(path);
  return match?.group(1);
}

String? _featureName(String path) {
  final match = RegExp(r'/packages/features/([^/]+)/').firstMatch(path);
  return match?.group(1);
}

String? _packageName(String uri) {
  if (!uri.startsWith('package:')) return null;
  return uri.substring('package:'.length).split('/').first;
}

abstract base class _LemonRule extends AnalysisRule {
  _LemonRule({required super.name, required super.description});
}

final class LemonLayerBoundaryRule extends _LemonRule {
  static const LintCode code = LintCode(
    'lemon_layer_boundary',
    '{0}',
    uniqueName: 'LintCode.lemon_layer_boundary',
  );

  LemonLayerBoundaryRule()
    : super(
        name: 'lemon_layer_boundary',
        description: 'Enforces feature and pure-domain import boundaries.',
      );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final path = _path(context);
    final feature = _featureName(path);
    if (feature == null) return;
    final layer = _layerName(path);
    if (layer == null) return;
    registry.addImportDirective(
      this,
      _LayerImportVisitor(this, feature, layer, path),
    );
  }
}

final class _LayerImportVisitor extends SimpleAstVisitor<void> {
  _LayerImportVisitor(this.rule, this.feature, this.layer, this.sourcePath);

  final AnalysisRule rule;
  final String feature;
  final String layer;
  final String sourcePath;

  @override
  void visitImportDirective(ImportDirective node) {
    final uri = node.uri.stringValue;
    if (uri == null) return;
    if (directIoDartForbiddenImports.contains(uri) &&
        !directIoDartOwnerLayers.contains(layer)) {
      rule.reportAtNode(
        node,
        arguments: ['$uri direct platform/network I/O belongs in data'],
      );
      return;
    }
    final importedPackage = _packageName(uri);
    final analyzerResolvedPath = node
        .libraryImport
        ?.importedLibrary
        ?.firstFragment
        .source
        .fullName
        .replaceAll('\\', '/');
    final resolvedPath = _relativeTargetPath(uri) ?? analyzerResolvedPath;
    final resolvedFeature = resolvedPath == null
        ? importedPackage
        : _featureName(resolvedPath) ?? importedPackage;
    if (resolvedFeature != null &&
        resolvedFeature != feature &&
        featurePackages.contains(resolvedFeature)) {
      rule.reportAtNode(
        node,
        arguments: [
          '$feature cannot import another feature package: $resolvedFeature ($uri)',
        ],
      );
      return;
    }

    final ownTargetLayer = _ownTargetLayer(uri, resolvedPath);
    if (ownTargetLayer != null &&
        !allowedOwnLayerImports[layer]!.contains(ownTargetLayer)) {
      rule.reportAtNode(
        node,
        arguments: ['$layer cannot import the $ownTargetLayer layer: $uri'],
      );
      return;
    }

    if (importedPackage == null || importedPackage == feature) return;
    if (workspacePackages.contains(importedPackage)) {
      if (!allowedLayerWorkspacePackages[layer]!.contains(importedPackage) ||
          !allowedPackageDependencies[feature]!.contains(importedPackage)) {
        rule.reportAtNode(
          node,
          arguments: [
            '$layer cannot import workspace package $importedPackage',
          ],
        );
      }
      return;
    }
    if (!allowedLayerExternalPackages[layer]!.contains(importedPackage)) {
      rule.reportAtNode(
        node,
        arguments: ['$layer cannot import external package $importedPackage'],
      );
    }
  }

  String? _relativeTargetPath(String uri) {
    if (uri.startsWith('package:') || uri.startsWith('dart:')) return null;
    return Uri.file(sourcePath).resolve(uri).toFilePath().replaceAll('\\', '/');
  }

  String? _ownTargetLayer(String uri, String? resolvedPath) {
    if (resolvedPath != null && _featureName(resolvedPath) == feature) {
      return _layerName(resolvedPath);
    }
    if (uri.startsWith('package:$feature/')) {
      return _layerName('/lib/${uri.substring('package:$feature/'.length)}');
    }
    if (uri.startsWith('package:') || uri.startsWith('dart:')) return null;
    final resolved = Uri.file(sourcePath).resolve(uri).path;
    return _layerName(resolved);
  }
}

final class _FrameworkAppearanceImportVisitor extends SimpleAstVisitor<void> {
  _FrameworkAppearanceImportVisitor(this.rule);

  final AnalysisRule rule;

  @override
  void visitImportDirective(ImportDirective node) {
    final uri = node.uri.stringValue;
    if (uri != null && forbiddenFeatureVisualImports.contains(uri)) {
      rule.reportAtNode(
        node,
        arguments: ['$uri visual components belong behind lemon_ui'],
      );
    }
  }
}

final class LemonDesignTokenBoundaryRule extends _LemonRule {
  static const LintCode code = LintCode(
    'lemon_design_token_boundary',
    'Raw design value outside lemon_ui: {0}',
    uniqueName: 'LintCode.lemon_design_token_boundary',
  );

  LemonDesignTokenBoundaryRule()
    : super(
        name: 'lemon_design_token_boundary',
        description: 'Requires generated Lemon design tokens outside lemon_ui.',
      );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final path = _path(context);
    if (path.contains('/packages/lemon_ui/')) return;
    registry
      ..addInstanceCreationExpression(this, _DesignValueVisitor(this))
      ..addImportDirective(this, _FrameworkAppearanceImportVisitor(this));
  }
}

final class _DesignValueVisitor extends SimpleAstVisitor<void> {
  _DesignValueVisitor(this.rule);

  static const tokenOwnedTypes = {
    'Color',
    'TextStyle',
    'Radius',
    'BorderRadius',
    'EdgeInsets',
    'EdgeInsetsDirectional',
    'Duration',
  };

  final AnalysisRule rule;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final type = node.constructorName.type.name.lexeme;
    if (tokenOwnedTypes.contains(type)) {
      rule.reportAtNode(node, arguments: ['$type constructor']);
      return;
    }
    if (type == 'SizedBox' &&
        node.argumentList.arguments.any(_containsNumericLiteral)) {
      rule.reportAtNode(node, arguments: ['numeric SizedBox spacing']);
    }
  }

  static bool _containsNumericLiteral(Argument argument) {
    final value = argument.argumentExpression;
    return value is IntegerLiteral || value is DoubleLiteral;
  }
}

final class LemonWidgetTextBoundaryRule extends _LemonRule {
  static const LintCode code = LintCode(
    'lemon_widget_text_boundary',
    'User-facing widget text must come from slang, not a string literal.',
    uniqueName: 'LintCode.lemon_widget_text_boundary',
  );

  LemonWidgetTextBoundaryRule()
    : super(
        name: 'lemon_widget_text_boundary',
        description: 'Forbids user-facing string literals in widgets.',
      );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addSimpleStringLiteral(this, _WidgetTextVisitor(this));
  }
}

final class _WidgetTextVisitor extends SimpleAstVisitor<void> {
  _WidgetTextVisitor(this.rule);

  static const textConstructors = {
    'Text',
    'TextSpan',
    'SelectableText',
    'InputDecoration',
    'Semantics',
    'Tooltip',
    'BottomNavigationBarItem',
  };

  final AnalysisRule rule;

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    AstNode? ancestor = node.parent;
    while (ancestor != null && ancestor is! FunctionBody) {
      if (ancestor is InstanceCreationExpression &&
          textConstructors.contains(
            ancestor.constructorName.type.name.lexeme,
          )) {
        rule.reportAtNode(node);
        return;
      }
      ancestor = ancestor.parent;
    }
  }
}

final class LemonVendorBoundaryRule extends _LemonRule {
  static const LintCode code = LintCode(
    'lemon_vendor_boundary',
    'Feature package {0} cannot import vendor package {1}; use its declared technical boundary.',
    uniqueName: 'LintCode.lemon_vendor_boundary',
  );

  LemonVendorBoundaryRule()
    : super(
        name: 'lemon_vendor_boundary',
        description: 'Keeps vendor SDKs behind declared technical packages.',
      );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final feature = _featureName(_path(context));
    if (feature == null) return;
    registry.addImportDirective(this, _VendorImportVisitor(this, feature));
  }
}

final class _VendorImportVisitor extends SimpleAstVisitor<void> {
  _VendorImportVisitor(this.rule, this.feature);

  static const frameworkPackages = {'flutter', 'flutter_riverpod', 'riverpod'};

  final AnalysisRule rule;
  final String feature;

  @override
  void visitImportDirective(ImportDirective node) {
    final package = _packageName(node.uri.stringValue ?? '');
    if (package == null ||
        package == feature ||
        frameworkPackages.contains(package) ||
        allowedPackageDependencies[feature]!.contains(package)) {
      return;
    }
    rule.reportAtNode(node, arguments: [feature, package]);
  }
}

final class LemonDeterminismBoundaryRule extends _LemonRule {
  static const LintCode code = LintCode(
    'lemon_determinism_boundary',
    'Ambient non-determinism is forbidden in domain/application: {0}.',
    uniqueName: 'LintCode.lemon_determinism_boundary',
  );

  LemonDeterminismBoundaryRule()
    : super(
        name: 'lemon_determinism_boundary',
        description:
            'Requires injected clocks, random sources, and platform data.',
      );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final path = _path(context);
    final layer = _layerName(path);
    if (layer == null || !ambientDartLayers.contains(layer)) return;
    final visitor = _DeterminismVisitor(this);
    registry
      ..addInstanceCreationExpression(this, visitor)
      ..addMethodInvocation(this, visitor)
      ..addPrefixedIdentifier(this, visitor);
  }
}

final class _DeterminismVisitor extends SimpleAstVisitor<void> {
  _DeterminismVisitor(this.rule);

  final AnalysisRule rule;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final constructor = node.constructorName;
    final type = constructor.type.name.lexeme.split('.').last;
    final name = constructor.name?.name;
    final identifier = name == null ? type : '$type.$name';
    if (forbiddenAmbientDartIdentifiers.contains(type) ||
        forbiddenAmbientDartIdentifiers.contains(identifier)) {
      rule.reportAtNode(node, arguments: ['$identifier()']);
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final target = node.target?.toSource();
    if (target == null) return;
    final identifier = '${target.split('.').last}.${node.methodName.name}';
    if (forbiddenAmbientDartIdentifiers.contains(identifier)) {
      rule.reportAtNode(node, arguments: ['$identifier()']);
    }
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    final prefix = node.prefix.name;
    final identifier = '$prefix.${node.identifier.name}';
    if (forbiddenAmbientDartIdentifiers.contains(prefix) ||
        forbiddenAmbientDartIdentifiers.contains(identifier)) {
      rule.reportAtNode(node, arguments: [identifier]);
    }
  }
}
