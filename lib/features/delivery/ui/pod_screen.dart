import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../shared/widgets/app_scaffold.dart';

class PodScreen extends StatefulWidget {
  final String routeId;
  final String stopId;

  const PodScreen({super.key, required this.routeId, required this.stopId});

  @override
  State<PodScreen> createState() => _PodScreenState();
}

class _PodScreenState extends State<PodScreen> {
  bool photoAdded = false;
  bool signatureAdded = false;

  @override
  Widget build(BuildContext context) {
    final canSubmit = photoAdded && signatureAdded;
    return AppScaffold(
      title: tr('pod.title'),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text(tr('pod.evidence_title')),
              subtitle: Text(
                tr('pod.route_stop', namedArgs: {
                  'routeId': widget.routeId,
                  'stopId': widget.stopId,
                }),
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text(tr('pod.photo_required')),
                  trailing: OutlinedButton(
                    onPressed: () => setState(() => photoAdded = true),
                    child: Text(
                      photoAdded ? tr('pod.added') : tr('pod.capture'),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.draw_outlined),
                  title: Text(tr('pod.signature_required')),
                  trailing: OutlinedButton(
                    onPressed: () => setState(() => signatureAdded = true),
                    child: Text(
                      signatureAdded ? tr('pod.added') : tr('pod.sign'),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: tr('pod.recipient_id'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: tr('pod.notes_optional'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              onPressed: !canSubmit
                  ? null
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(tr('pod.submitted_mock')),
                        ),
                      ),
              child: Text(tr('pod.submit')),
            ),
          ),
        ],
      ),
    );
  }
}
