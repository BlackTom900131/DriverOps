import 'package:flutter/material.dart';
import 'document_upload_screen.dart';

/// Multi-step registration screen that guides the user through
/// personal info, vehicle info, and document upload.
class RegistrationStepperScreen extends StatefulWidget {
  const RegistrationStepperScreen({super.key});

  @override
  State<RegistrationStepperScreen> createState() =>
      _RegistrationStepperScreenState();
}

class _RegistrationStepperScreenState extends State<RegistrationStepperScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Registration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: [
          Step(
            title: const Text('Personal Information'),
            content: _PersonalInfoStep(
              onNext: () => setState(() => _currentStep++),
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Vehicle Information'),
            content: _VehicleInfoStep(
              onNext: () => setState(() => _currentStep++),
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Documents & Photo'),
            content: _DocumentStep(
              onNext: () {
                if (mounted) Navigator.of(context).pop(true);
              },
            ),
            isActive: _currentStep >= 2,
            state: StepState.indexed,
          ),
        ],
      ),
    );
  }
}

class _PersonalInfoStep extends StatefulWidget {
  final VoidCallback onNext;

  const _PersonalInfoStep({required this.onNext});

  @override
  State<_PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<_PersonalInfoStep> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'Government ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.onNext,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class _VehicleInfoStep extends StatefulWidget {
  final VoidCallback onNext;

  const _VehicleInfoStep({required this.onNext});

  @override
  State<_VehicleInfoStep> createState() => _VehicleInfoStepState();
}

class _VehicleInfoStepState extends State<_VehicleInfoStep> {
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();
  String _vehicleType = 'Car';

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            value: _vehicleType,
            decoration: const InputDecoration(
              labelText: 'Vehicle Type',
              border: OutlineInputBorder(),
            ),
            items: ['Car', 'Truck', 'Van', 'Motorcycle', 'Bus', 'SUV']
                .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                .toList(),
            onChanged: (v) => setState(() => _vehicleType = v ?? 'Car'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _brandController,
            decoration: const InputDecoration(
              labelText: 'Brand',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _modelController,
            decoration: const InputDecoration(
              labelText: 'Model',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _plateController,
            decoration: const InputDecoration(
              labelText: 'License Plate',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.onNext,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class _DocumentStep extends StatelessWidget {
  final VoidCallback onNext;

  const _DocumentStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Upload your documents and photo in the next screen.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const DocumentUploadScreen(),
              ),
            );
          },
          icon: const Icon(Icons.upload_file),
          label: const Text('Open Document Upload'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onNext,
          child: const Text('Finish Registration'),
        ),
      ],
    );
  }
}
