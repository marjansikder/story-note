import 'package:date_calculator/utils/colors.dart';
import 'package:date_calculator/utils/font_util.dart';
import 'package:flutter/material.dart';

class CustomAppBarWithShadow extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBarWithShadow({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appBarColor, // AppBar background color
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.grey.withOpacity(0.1),
            offset: const Offset(0, 3.0),
          ),
        ],
      ),
      child: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Center(
          child: Text(title, style: FontUtil.appBarTitleTextStyle),
        ),
        backgroundColor: Colors.transparent, // Make the AppBar itself transparent
        elevation: 0, // Disable the default AppBar shadow
        leading: showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
    );
  }
}
