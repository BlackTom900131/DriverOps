import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('ja'),
        Locale('fr'),
        Locale('de'),
        Locale('pt'),
        Locale('it'),
        Locale('zh'),
        Locale('ko'),
        Locale('ar'),
        Locale('hi'),
        Locale('ru'),
      ],
      path: 'Assets/translations',
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true,
      useFallbackTranslations: true,
      useFallbackTranslationsForEmptyResources: true,
      saveLocale: true,
      child: const ProviderScope(child: DriverOpsApp()),
    ),
  );
}
