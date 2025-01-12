import 'package:date_calculator/utils/colors.dart';
import 'package:date_calculator/utils/font_util.dart';
import 'package:flutter/material.dart';

class HomeItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onPressed;

  const HomeItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        children: [
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.kHomeItemBorderColor, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: icon,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(title, style: FontUtil.blackW400S12),
        ],
      ),
    );
  }
}
