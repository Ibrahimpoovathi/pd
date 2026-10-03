import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/app/router.dart';
import 'package:pd/core/theme/theme_provider.dart';

class PdApp extends ConsumerWidget {
  const PdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variant = ref.watch(appThemeVariantProvider);
    return MaterialApp.router(
      title: 'PD — Personal Development',
      debugShowCheckedModeBanner: false,
      theme: appThemeFor(variant),
      darkTheme: appThemeFor(variant),
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
