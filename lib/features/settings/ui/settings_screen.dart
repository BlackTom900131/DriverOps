import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Map<String, String> _languageLabels = {
    'en': 'English',
    'es': 'Español',
    'ja': '日本語',
    'fr': 'Français',
    'de': 'Deutsch',
    'pt': 'Português',
    'it': 'Italian',
    'zh': '中文',
    'ko': '한국어',
    'ar': 'العربية',
    'hi': 'हिन्दी',
    'ru': 'Русский',
  };

  @override
  Widget build(BuildContext context) {
    final supported = context.supportedLocales;
    final selected = supported.contains(context.locale)
        ? context.locale
        : supported.first;

    return AppScaffold(
      title: tr('menu.settings'),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.language_outlined),
              title: Text(tr('profile.language_section_title')),
              subtitle: Text(tr('profile.language_label')),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: selected,
                  items: supported
                      .map(
                        (l) => DropdownMenuItem(
                          value: l,
                          child: Text(
                            _languageLabels[l.languageCode] ?? l.languageCode,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    context.setLocale(value);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
