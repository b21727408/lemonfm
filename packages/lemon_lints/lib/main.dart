import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/rules.dart';

final Plugin plugin = LemonLintsPlugin();

final class LemonLintsPlugin extends Plugin {
  @override
  String get name => 'Lemon.fm architecture rules';

  @override
  void register(PluginRegistry registry) {
    registry
      ..registerWarningRule(LemonLayerBoundaryRule())
      ..registerWarningRule(LemonDesignTokenBoundaryRule())
      ..registerWarningRule(LemonWidgetTextBoundaryRule())
      ..registerWarningRule(LemonVendorBoundaryRule())
      ..registerWarningRule(LemonDeterminismBoundaryRule());
  }
}
