import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart'; // sesuaikan path model Project
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_guard.dart'; // sesuaikan path ensureLoggedIn
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart'; // sesuaikan path LeftDrawer
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _gitLink = '';
  String _otherLink = '';
  DateTime? _startedAt;
  DateTime? _endedAt;
  bool _isSubmitting = false;

  String _formatDate(DateTime date) => date.toIso8601String().split('T').first;

  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Future<void> _pickDate({
    required bool isStart,
    FormFieldState<DateTime>? field,
  }) async {
    final initial = isStart
        ? (_startedAt ?? DateTime.now())
        : (_endedAt ?? _startedAt ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startedAt = picked;
        field?.didChange(picked);
        if (_endedAt != null && _endedAt!.isBefore(picked)) {
          _endedAt = null;
        }
      } else {
        _endedAt = picked;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null) return;

    final newProject = Project(
      title: _title.trim(),
      description: _description.trim(),
      gitLink: _gitLink.trim(),
      otherLink: _otherLink.trim().isEmpty ? null : _otherLink.trim(),
      startedAt: _startedAt!,
      endedAt: _endedAt,
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      await context.read<ApiClient>().createProject(newProject, token: token);
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Project Created'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Title: ${newProject.title}'),
                Text('Description: ${newProject.description}'),
                Text('Git Link: ${newProject.gitLink}'),
                if (newProject.otherLink != null)
                  Text('Other Link: ${newProject.otherLink}'),
                Text('Started At: ${_formatDate(newProject.startedAt)}'),
                if (newProject.endedAt != null)
                  Text('Ended At: ${_formatDate(newProject.endedAt!)}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MyHomePage()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;

      if (e.statusCode == 401) {
        await context.read<AuthState>().logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired (401). Please log in again.'),
          ),
        );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create project (status ${e.statusCode})'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Project',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _title = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => _description = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Git Link',
                  hintText: 'https://github.com/username/repo',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) => _gitLink = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Git link cannot be empty';
                  }
                  if (!_isValidUrl(value.trim())) {
                    return 'Enter a valid http/https URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Other Link (Optional)',
                  hintText: 'https://example.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) => _otherLink = value,
                validator: (value) {
                  if (value != null &&
                      value.trim().isNotEmpty &&
                      !_isValidUrl(value.trim())) {
                    return 'Enter a valid http/https URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FormField<DateTime>(
                validator: (_) =>
                    _startedAt == null ? 'Start date is required' : null,
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: field.hasError
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        _startedAt == null
                            ? 'Started At (Required)'
                            : 'Started At: ${_formatDate(_startedAt!)}',
                      ),
                      onTap: () => _pickDate(isStart: true, field: field),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 6),
                        child: Text(
                          field.errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                leading: const Icon(Icons.event),
                title: Text(
                  _endedAt == null
                      ? 'Ended At (Optional - leave empty if ongoing)'
                      : 'Ended At: ${_formatDate(_endedAt!)}',
                ),
                trailing: _endedAt != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _endedAt = null),
                      )
                    : null,
                onTap: () => _pickDate(isStart: false),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
