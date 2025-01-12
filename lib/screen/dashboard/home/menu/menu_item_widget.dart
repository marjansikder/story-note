import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';

class MenuItem extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? description;
  final Widget? trailing;
  final VoidCallback onPressed;

  const MenuItem({
    super.key,
    this.leading,
    required this.title,
    this.description,
    this.trailing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            leading ?? Container(),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                if (description != null) ...[description!]
              ],
            ),
            const Spacer(),
            Padding(
                padding: const EdgeInsets.only(right: 6),
                child: trailing ??
                    const Icon(Icons.pentagon,
                        color: AppColors.kPrimaryColor, size: 14)),
          ],
        ),
      ),
    );
  }
}

class SvgImage {}
