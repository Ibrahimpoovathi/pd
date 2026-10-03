import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/app/router.dart';
import 'package:pd/core/theme/theme_provider.dart';

class PdApp extends ConsumerWidget {
  const PdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variant = ref.watch(appThemeVariantProvider);
    final theme = appThemeFor(variant);
    return MaterialApp.router(
      title: 'PD — Personal Development',
      debugShowCheckedModeBanner: false,
      // The variant fully determines brightness (dark = GitHub Dark,
      // sepiaLight = Sepia Light), so a single theme suffices.
      theme: theme,
      darkTheme: theme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
