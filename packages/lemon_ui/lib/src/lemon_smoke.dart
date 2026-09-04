import 'package:flutter/widgets.dart';

import 'generated/tokens.dart';

/// The sole Phase 0 widget, used only to prove Flutter target wiring.
final class LemonSmoke extends StatelessWidget {
  const LemonSmoke({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: LemonColors.bg0, child: SizedBox.expand());
  }
}
