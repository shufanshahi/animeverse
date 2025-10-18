import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileForm extends StatefulWidget {
  final ProfileEntity profile;
  final Function(ProfileEntity) onSave;
  final VoidCallback? onCancel;

  const ProfileForm({
    super.key,
    required this.profile,
    required this.onSave,
    this.onCancel,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _streetController;
  late TextEditingController _zipController;
  late TextEditingController _stateController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _emailController = TextEditingController(text: widget.profile.email);
    _firstNameController = TextEditingController(text: widget.profile.firstName);
    _lastNameController = TextEditingController(text: widget.profile.lastName);
    _streetController = TextEditingController(text: widget.profile.street);
    _zipController = TextEditingController(text: widget.profile.zip);
    _stateController = TextEditingController(text: widget.profile.state);
    _phoneController = TextEditingController(text: widget.profile.phone);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _streetController.dispose();
    _zipController.dispose();
    _stateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // Check if user is authenticated before saving
      if (widget.profile.userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to save your profile'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final updatedProfile = widget.profile.copyWith(
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        street: _streetController.text.trim(),
        zip: _zipController.text.trim(),
        state: _stateController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      widget.onSave(updatedProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.profile.firstName.isEmpty ? 'Create Profile' : 'Edit Profile',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.profile.userId.isEmpty)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You can fill out your profile information, but you\'ll need to sign in to save it.',
                        style: TextStyle(color: Colors.orange.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            _buildPersonalInfoSection(),
            const SizedBox(height: 24),
            _buildAddressSection(),
            const SizedBox(height: 24),
            _buildContactSection(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: widget.profile.userId.isEmpty 
                    ? 'Enter your email address' 
                    : null,
                prefixIcon: const Icon(Icons.email),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email address is required';
                }
                // Basic email validation
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      hintText: 'Enter your first name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      hintText: 'Enter your last name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _streetController,
              decoration: const InputDecoration(
                labelText: 'Street Address',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Street address is required';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'State is required';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _zipController,
                    decoration: const InputDecoration(
                      labelText: 'ZIP Code',
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'ZIP code is required';
                      }
                      if (value.trim().length < 5) {
                        return 'ZIP code must be at least 5 characters';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                hintText: '(123) 456-7890',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Phone number is required';
                }
                // Basic phone validation
                final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
                if (!phoneRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-\(\)\+]')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (widget.onCancel != null) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onCancel,
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: ElevatedButton(
            onPressed: _handleSave,
            child: Text(widget.profile.firstName.isEmpty ? 'Create Profile' : 'Save Changes'),
          ),
        ),
      ],
    );
  }
}