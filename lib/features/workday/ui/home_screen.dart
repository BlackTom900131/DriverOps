import 'package:flutter/material.dart';
import 'start_workday_screen.dart';
import '../state/workday_state.dart';

/// Workday home: shows current status and entry point to start a workday.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Workday? _currentWorkday;
  final List<Workday> _recentWorkdays = [];

  Future<void> _openStartWorkday() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => const StartWorkdayScreen(),
      ),
    );
    if (result == true && mounted) {
      setState(() {
        _currentWorkday = Workday(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: DateTime.now(),
          clockIn: DateTime.now(),
          status: WorkdayStatus.inProgress,
        );
      });
    }
  }

  void _endWorkday() {
    if (_currentWorkday == null) return;
    setState(() {
      _recentWorkdays.insert(
        0,
        _currentWorkday!.copyWith(
          clockOut: DateTime.now(),
          status: WorkdayStatus.completed,
        ),
      );
      _currentWorkday = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveWorkday = _currentWorkday != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workday'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    hasActiveWorkday ? 'Workday in progress' : 'No active workday',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (hasActiveWorkday && _currentWorkday!.clockIn != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Clocked in at ${_formatTime(_currentWorkday!.clockIn!)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _endWorkday,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.errorContainer,
                        foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      child: const Text('End workday'),
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _openStartWorkday,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start workday'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_recentWorkdays.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Recent workdays',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ..._recentWorkdays.take(5).map((w) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(_formatDate(w.date)),
                    subtitle: Text(
                      '${_formatTime(w.clockIn)} – ${w.clockOut != null ? _formatTime(w.clockOut!) : "—"}',
                    ),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
