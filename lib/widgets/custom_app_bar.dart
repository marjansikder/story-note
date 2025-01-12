import 'package:flutter/material.dart';
import 'package:date_calculator/utils/colors.dart';

class CustomSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final Color backgroundColor;
  final TextStyle titleTextStyle;
  final TextStyle searchTextStyle;
  final TextStyle hintTextStyle;

  const CustomSearchAppBar({
    super.key,
    required this.title,
    required this.searchController,
    required this.onSearchChanged,
    this.backgroundColor = Colors.transparent,
    this.titleTextStyle = const TextStyle(color: Colors.black, fontSize: 18),
    this.searchTextStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.hintTextStyle = const TextStyle(color: Colors.grey, fontSize: 14),
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  _CustomSearchAppBarState createState() => _CustomSearchAppBarState();
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appBarColor, // Match the background color
        boxShadow: [
          BoxShadow(
            blurRadius: 2, // Match the shadow blur
            color: Colors.grey.withOpacity(0.1), // Match the shadow color
            offset: const Offset(0, 3.0), // Match the shadow offset
          ),
        ],
      ),
      child: AppBar(
        titleSpacing: 15,
        centerTitle: false,
        title: isSearching
            ? TextField(
          controller: widget.searchController,
          onChanged: widget.onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search notes...',
            hintStyle: widget.hintTextStyle,
            border: InputBorder.none,
          ),
          style: widget.searchTextStyle,
        )
            : Text(
          widget.title,
          style: widget.titleTextStyle,
        ),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Disable default shadow
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: AppColors.kBrown,
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  widget.searchController.clear();
                  widget.onSearchChanged('');
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
    );
  }
}
