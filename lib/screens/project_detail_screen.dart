import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final otherLink = project.otherLink;
    final hasOtherLink = otherLink != null && otherLink.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Proyek',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
            ),
            const SizedBox(height: 8.0),

            Row(
              children: [
                Expanded(child: Text(project.timeRangeStr)),
                if (project.isOngoing)
                  const Chip(
                    label: Text('Sedang berjalan'),
                    avatar: Icon(Icons.timelapse, size: 18),
                  ),
              ],
            ),

            const SizedBox(height: 16.0),

            Card(
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      project.isStarred ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${project.starCount} star',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (project.starredByNames.isNotEmpty)
                            Text('Dibintangi oleh ${project.starredByNames}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(project.description),

            const SizedBox(height: 16.0),

            const Text(
              'Tautan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            _LinkTile(label: 'GitHub', url: project.gitLink, icon: Icons.code),
            if (hasOtherLink)
              _LinkTile(label: 'Website', url: otherLink, icon: Icons.language),
          ],
        ),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.label, required this.url, required this.icon});

  final String label;
  final String url;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.copy, size: 18),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: url));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tautan $label disalin.')),
          );
        },
      ),
    );
  }
}
