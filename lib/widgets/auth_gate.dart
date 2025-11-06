import 'package:date_calculator/providers/auth_provider.dart';
import 'package:date_calculator/utils/colors.dart';
import 'package:date_calculator/utils/text_style.dart';
import 'package:date_calculator/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) => user == null ? const _LoginScreen() : child,
      loading: () => Scaffold(
        body: Center(
          child: SpinKitFadingCircle(color: AppColors.kBrown),
        ),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text('Auth error: $err')),
      ),
    );
  }
}

class _LoginScreen extends ConsumerWidget {
  const _LoginScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.kBgColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // soft radial glow behind the card
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 1.2,
            colors: [
              Colors.white.withOpacity(.85),
              AppColors.kBgColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: _FrostedCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _BrandLogo(),
                      const SizedBox(height: 16),
                      Text(
                        'Story Note',
                        style: getCustomTextStyle(
                          color: AppColors.kBrown,
                          fontWeight: FontWeight.w700,
                          fontSize: 29,
                          fontFamily: 'Kohinoor',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Capture thoughts. Make them story.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.kBrown.withOpacity(.7),
                          fontFamily: 'Kohinoor',
                        ),
                      ),
                      const SizedBox(height: 48),
                      _GoogleSignInButton(
                        onPressed: () async {
                          try {
                            await ref
                                .read(authServiceProvider)
                                .signInWithGoogle();
                          } catch (_) {
                            if (!context.mounted) return;
                            Toast.showErrorToast('Sign-in failed!');
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      /*Text(
                        'By continuing you agree to our Terms & Privacy Policy',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.kBrown.withOpacity(.55),
                          fontFamily: 'Kohinoor',
                        ),
                      ),*/
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FrostedCard extends StatelessWidget {
  const _FrostedCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: .8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 24,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF089),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.kBrown.withValues(alpha: .15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/icons/ic_logo.png',
            width: 56,
            height: 56,
            errorBuilder: (_, __, ___) => Text(
              '📝',
              style: TextStyle(fontSize: 40, color: AppColors.kBrown),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleSignInButton extends StatefulWidget {
  const _GoogleSignInButton({required this.onPressed});
  final Future<void> Function() onPressed;

  @override
  State<_GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<_GoogleSignInButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = getCustomTextStyle(
      color: AppColors.kBrown,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      fontFamily: 'Kohinoor',
    );

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _loading
            ? null
            : () async {
                setState(() => _loading = true);
                await widget.onPressed();
                if (mounted) setState(() => _loading = false);
              },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
          disabledBackgroundColor: Colors.white.withOpacity(.8),
          foregroundColor: AppColors.kBrown,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: AppColors.kBrown.withOpacity(.15)),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _loading
              ? Row(
                  key: const ValueKey('loading'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(
                      color: AppColors.kBrown,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text('Authenticating...', style: textStyle),
                  ],
                )
              : Row(
                  key: const ValueKey('ready'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/img_google.png',
                        height: 20, width: 20),
                    const SizedBox(width: 10),
                    Text('Sign in with Google', style: textStyle),
                  ],
                ),
        ),
      ),
    );
  }
}
