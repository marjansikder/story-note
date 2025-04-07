import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImage extends StatelessWidget {
  final Widget child;

  const SvgImage._({super.key, required this.child});

  factory SvgImage.asset(String assetName, {Key? key, Color? color, double? size}) {
    return _SvgImageAsset(assetName, key: key, color: color, size: size);
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class _SvgImageAsset extends SvgImage {
  _SvgImageAsset(
    String assetName, {
    super.key,
    Color? color,
    double? size,
  }) : super._(
          child: SvgPicture.asset(
            assetName,
            colorFilter: _getColorFilter(color),
            height: size,
            width: size,
          ),
        );
}

ColorFilter? _getColorFilter(Color? color) => color == null
    ? null : ColorFilter.mode(color, BlendMode.srcIn);
