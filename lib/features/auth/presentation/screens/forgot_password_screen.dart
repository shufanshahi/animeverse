// lib/features/auth/presentation/screens/forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localization.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/language_toggle.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    await ref.read(authProvider.notifier).forgotPassword(
          _emailController.text.trim(),
        );

    final authState = ref.read(authProvider);
    if (authState.error == null) {
      setState(() {
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    final lang = locale.languageCode;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                const LanguageToggle(),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _emailSent ? Icons.mark_email_read_outlined : Icons.lock_reset,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                AppLocalizations.translate('reset_password', lang),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),

              // Description or Success Message
              Text(
                _emailSent
                    ? AppLocalizations.translate('reset_email_sent', lang)
                    : AppLocalizations.translate('reset_instructions', lang),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 40),
              if (!_emailSent) ...[
                // Email TextField
                CustomTextField(
                  controller: _emailController,
                  label: AppLocalizations.translate('email', lang),
                  keyboardType: TextInputType.emailAddress, hint: '', icon: Icons.email,
                ),
                const SizedBox(height: 20),

                // Reset Password Button
                CustomButton(
                  text: AppLocalizations.translate('reset_password', lang),
                  isLoading: authState.isLoading,
                  onPressed: _handleResetPassword,
                ),
              ],
              if (_emailSent) ...[
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.translate('back_to_login', lang)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}