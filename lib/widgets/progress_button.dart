import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:story_notes/utils/colors.dart';
import 'package:story_notes/utils/text_style.dart';

typedef PressedCallback = Future<void> Function();

class ProgressButton extends StatefulWidget {
  final Widget? label;
  final Widget? icon;
  final Widget? loadingLabel;
  final Color surfaceColor;
  final bool isDisabled;
  final bool useSurfaceColor;
  final bool useSafeArea;
  final PressedCallback onPressed;

  const ProgressButton({
    super.key,
    this.label,
    this.icon,
    this.loadingLabel,
    this.isDisabled = false,
    this.useSafeArea = true,
    this.useSurfaceColor = true,
    this.surfaceColor = Colors.white,
    required this.onPressed,
  });

  @override
  State<ProgressButton> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Widget child = ElevatedButton.icon(
      icon: _isLoading
          ? Transform.scale(
              scale: 0.5,
              child: SpinKitFadingCircle(color: AppColors.kBrown),
            )
          : widget.icon,
      label: _isLoading
          ? widget.loadingLabel ??
              Text(
                'Saving...',
                style: getCustomTextStyle(
                  color: AppColors.kBrown,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: 'Kohinoor',
                ),
              )
          : widget.label ??
              Text(
                'Save',
                style: getCustomTextStyle(
                  color: AppColors.kBrown,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: 'Kohinoor',
                ),
              ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.kWarningToastBgColor.withValues(alpha: 0.9),
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: widget.isDisabled
          ? null
          : () async {
              if (_isLoading) return;
              setState(() => _isLoading = true);
              final result = widget.onPressed();
              result.whenComplete(() {
                setState(() => _isLoading = false);
              });
            },
    );

    if (widget.useSurfaceColor) {
      child = Container(
        padding: const EdgeInsets.all(16),
        color: widget.surfaceColor,
        child: child,
      );
    }

    if (widget.useSafeArea) {
      child = SafeArea(child: child);
    }

    return child;
  }
}
