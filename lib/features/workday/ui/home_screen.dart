import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../../shared/widgets/app_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final VideoPlayerController _videoController;

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
    return AppScaffold(
      title: 'Driver Operations',
      showOfflineBanner: false,
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
            const Image(
              image: AssetImage('Assets/BackgroundImage.avif'),
              fit: BoxFit.cover,
            ),
          Container(color: Colors.black.withValues(alpha: 0.28)),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.62),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Text.rich(
                          const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'Drive smart. Deliver safely. Earn more with ',
                              ),
                              TextSpan(
                                text: 'Our Company.',
                                style: TextStyle(
                                  color: Color(0xFF7EC8FF),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFF2F7FF),
                            fontSize: 32,
                            height: 1.35,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            fontFamily: 'SF Pro Text',
                            shadows: [
                              Shadow(
                                color: Color(0x88000000),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 52),
                      FilledButton.icon(
                        onPressed: () => context.go('/home/start-workday'),
                        icon: const Icon(Icons.play_arrow_rounded, size: 24),
                        label: const Text('Start Workday'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
