import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/profile_entity.dart';
import 'profile_avatar_generator.dart';

class ProfileDisplay extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileDisplay({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(context),
          const SizedBox(height: 20),
          _buildInfoCard(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Random profile avatar based on email
                ProfileAvatarGenerator.generateConsistentAvatar(
                  email: profile.email,
                  size: 60,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
              AppLocalizations.of(context)!.profileWelcomeBack,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
                      Text(
                        profile.fullName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
          AppLocalizations.of(context)!.profilePersonalInformation,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
            const SizedBox(height: 16),
            _buildInfoRow(context, Icons.person, AppLocalizations.of(context)!.profileFullName, profile.fullName),
            _buildInfoRow(context, Icons.email, AppLocalizations.of(context)!.profileEmailAddress, profile.email),
            _buildInfoRow(context, Icons.home, AppLocalizations.of(context)!.profileStreetAddress, profile.street),
            _buildInfoRow(context, Icons.location_city, AppLocalizations.of(context)!.profileState, profile.state),
            _buildInfoRow(context, Icons.mail, AppLocalizations.of(context)!.profileZipCode, profile.zip),
            _buildInfoRow(context, Icons.phone, AppLocalizations.of(context)!.profilePhone, profile.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? AppLocalizations.of(context)!.profileNotProvided : value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: value.isEmpty 
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Theme.of(context).colorScheme.onSurface,
                    fontStyle: value.isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}