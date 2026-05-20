import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/trip.dart';
import '../../providers/trip_provider.dart';
import '../../providers/database_provider.dart';

class AddEditTripScreen extends ConsumerStatefulWidget {
  final int? tripId;
  final String? initialDestination;
  const AddEditTripScreen({super.key, this.tripId, this.initialDestination});

  @override
  ConsumerState<AddEditTripScreen> createState() => _AddEditTripScreenState();
}

class _AddEditTripScreenState extends ConsumerState<AddEditTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _destinationController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  bool _isShared = false;
  bool _isLoading = false;
  Trip? _existingTrip;

  bool get _isEditing => widget.tripId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadExistingTrip();
    } else if (widget.initialDestination != null) {
      _destinationController.text = widget.initialDestination!;
    }
  }

  Future<void> _loadExistingTrip() async {
    final repo = ref.read(tripRepositoryProvider);
    final trip = await repo.getTripById(widget.tripId!);
    if (trip != null && mounted) {
      setState(() {
        _existingTrip = trip;
        _titleController.text = trip.title;
        _destinationController.text = trip.destination;
        _descriptionController.text = trip.description ?? '';
        _startDate = trip.startDate;
        _endDate = trip.endDate;
        _isShared = trip.isShared;
      });
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;
    final firstDate = isStart ? DateTime.now() : _startDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 1825)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final notifier = ref.read(tripNotifierProvider.notifier);

    final trip = Trip(
      id: _existingTrip?.id,
      title: _titleController.text.trim(),
      destination: _destinationController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      isShared: _isShared,
      firestoreId: _existingTrip?.firestoreId,
    );

    if (_isEditing) {
      await notifier.updateTrip(trip);
    } else {
      await notifier.addTrip(trip);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      context.pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Trip' : 'New Trip'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save',
                    style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Trip Title *',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Title is required' : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Destination
            TextFormField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination *',
                prefixIcon: Icon(Icons.location_on),
                hintText: 'e.g. Paris, France',
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Destination is required'
                  : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Date range
            Row(
              children: [
                Expanded(
                  child: _DatePickerField(
                    label: 'Start Date',
                    date: _startDate,
                    onTap: () => _pickDate(isStart: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DatePickerField(
                    label: 'End Date',
                    date: _endDate,
                    onTap: () => _pickDate(isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                prefixIcon: Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Share toggle
            Card(
              child: SwitchListTile(
                title: const Text('Share with friends'),
                subtitle: const Text('Visible in Collaborative tab'),
                secondary: const Icon(Icons.people),
                value: _isShared,
                onChanged: (v) => setState(() => _isShared = v),
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _save,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Icon(_isEditing ? Icons.save : Icons.add),
              label: Text(_isEditing ? 'Update Trip' : 'Create Trip'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_month, size: 18),
        ),
        child: Text(
          DateFormatter.formatDate(date),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
