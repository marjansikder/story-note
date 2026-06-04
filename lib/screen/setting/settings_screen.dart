import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:story_notes/providers/auth_provider.dart';
import 'package:story_notes/utils/colors.dart';
import 'package:story_notes/utils/text_style.dart';
import 'package:story_notes/widgets/app_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgColor.withValues(alpha: .3),
      appBar: CustomAppBarWithShadow(title: 'Settings'),
      body: authState.when(
        data: (user) => Column(
          children: [
            _buildSettingsContent(context, ref, user),
            Spacer(),
            Text(
              ' 🜲 Developed by M a r j a n',
              style: getCustomTextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.normal,
                fontSize: 8,
                fontFamily: 'Jost',
              ),
            ),
          ],
        ),
        loading: () => Center(
          child: SpinKitFadingCircle(color: AppColors.kBrown),
        ),
        error: (err, _) => Center(
          child: Text(
            'Failed to load account: $err',
            style: getCustomTextStyle(
              color: AppColors.kBrown,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.kWarningToastBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            icon: Image.asset(
              'assets/icons/shut-down.png',
              color: AppColors.kBrown,
              width: 18,
            ),
            label: Text(
              'Logout',
              style: getCustomTextStyle(
                color: AppColors.kBrown,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                fontFamily: 'Kohinoor',
              ),
            ),
            onPressed: () async {
              try {
                await ref.read(authServiceProvider).signOut();
              } catch (error) {
                if (!context.mounted) return;
                final messenger = ScaffoldMessenger.of(context);
                messenger
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(content: Text('Logout failed: $error')),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContent(
      BuildContext context, WidgetRef ref, User? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (user != null) ...[
            _accountCard(context, user),
            const SizedBox(height: 8),
          ],
          if (user == null) ...[
            _anonymousBanner(context),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _accountCard(BuildContext context, User user) {
    final name = (user.displayName ?? '').trim();
    final email = user.email ?? 'No email linked';
    final initials = _initialsFor(user);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.kBrown.withValues(alpha: .03),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor:
                AppColors.kWarningToastBgColor.withValues(alpha: .8),
            backgroundImage:
                user.photoURL != null ? NetworkImage(user.photoURL!) : null,
            child: user.photoURL == null
                ? Text(
                    initials,
                    style: getCustomTextStyle(
                      color: AppColors.kBrown,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      fontFamily: 'Kohinoor',
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Signed in user' : name,
                  style: getCustomTextStyle(
                    color: AppColors.kBrown,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    fontFamily: 'Kohinoor',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.kBrown.withOpacity(.7),
                    fontFamily: 'Kohinoor',
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/img_google.png',
                      width: 16,
                      height: 16,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.account_circle,
                        size: 16,
                        color: AppColors.kBrown,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Signed in with Google',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.kBrown.withOpacity(.6),
                        fontFamily: 'Kohinoor',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _anonymousBanner(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWarningToastBgColor.withOpacity(.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.kBrown,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No Google account information found.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.kBrown,
                fontFamily: 'Kohinoor',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initialsFor(User user) {
    final displayName = user.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      final parts =
          displayName.split(RegExp(r'\s+')).where((part) => part.isNotEmpty);
      final letters = parts.take(2).map((part) => part[0]);
      final initials = letters.join();
      if (initials.isNotEmpty) {
        return initials.toUpperCase();
      }
    }
    final email = user.email;
    if (email != null && email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return '?';
  }
}
