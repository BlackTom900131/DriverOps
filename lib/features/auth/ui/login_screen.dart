import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../app/navigation/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final VideoPlayerController _videoController;
  static final Map<Locale, String> _languageLabels = {
    Locale('en'): 'English',
    Locale('es'): 'Español',
    Locale('ja'): '日本語',
    Locale('fr'): 'Français',
    Locale('de'): 'Deutsch',
    Locale('pt'): 'Português',
    Locale('it'): 'Italiano',
    Locale('zh'): '中文',
    Locale('ko'): '한국어',
    Locale('ar'): 'العربية',
    Locale('hi'): 'हिन्दी',
    Locale('ru'): 'Русский',
  };

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('Assets/Background.mp4')
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) return;
        _videoController.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_videoController.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            )
          else
            const DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/BackgroundImage.avif'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Container(color: Colors.black.withValues(alpha: 0.46)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: _LanguageSelector(
                      locale: locale,
                      onChanged: (value) {
                        if (value == null) return;
                        context.setLocale(value);
                      },
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      padding: const EdgeInsets.all(10),
                      // decoration: BoxDecoration(
                      //   color: Colors.white.withValues(alpha: 0.12),
                      //   borderRadius: BorderRadius.circular(20),
                      //   border: Border.all(
                      //     color: Colors.white.withValues(alpha: 0.28),
                      //   ),
                      // ),
                      child: const Image(
                        image: AssetImage('Assets/Logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Spacer(),
                  Text(
                    tr('login.welcome_title'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFEAF4FF),
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.3,
                      fontFamily: 'Georgia',
                      shadows: const [
                        Shadow(
                          color: Color(0x99000000),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tr('login.welcome_subtitle'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFDCEBFF),
                      height: 1.55,
                      letterSpacing: 0.15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    child: FilledButton.icon(
                      onPressed: () => context.go(AppRoutes.loginDetails),
                      icon: const Icon(Icons.login_rounded),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        side: const BorderSide(color: Colors.white, width: 1.4),
                        minimumSize: const Size.fromHeight(56),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      label: Text(
                        tr('login.login_button'),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final Locale locale;
  final ValueChanged<Locale?> onChanged;

  const _LanguageSelector({required this.locale, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final supported = context.supportedLocales;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
            value: supported.contains(locale) ? locale : supported.first,
            dropdownColor: const Color(0xFF1C1C1C),
            iconEnabledColor: Colors.white,
            items: supported
                .map(
                  (l) => DropdownMenuItem(
                    value: l,
                    child: Text(
                      _LoginScreenState._languageLabels[l] ?? l.languageCode,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
