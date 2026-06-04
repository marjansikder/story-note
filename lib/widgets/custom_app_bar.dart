import 'package:flutter/material.dart';
import 'package:story_notes/utils/colors.dart';

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
    this.titleTextStyle = const TextStyle(
        color: Colors.black, fontSize: 18, fontFamily: 'Watford'),
    this.searchTextStyle = const TextStyle(
        color: Colors.black, fontSize: 16, fontFamily: 'Watford'),
    this.hintTextStyle = const TextStyle(
        color: Colors.grey, fontSize: 14, fontFamily: 'Watford'),
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  CustomSearchAppBarState createState() => CustomSearchAppBarState();
}

class CustomSearchAppBarState extends State<CustomSearchAppBar> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.grey.withValues(alpha: 0.1),
            offset: const Offset(0, 3.0),
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
                    border: Theme.of(context).inputDecorationTheme.border),
                style: widget.searchTextStyle,
              )
            : Text(
                widget.title,
                style: widget.titleTextStyle,
              ),
        backgroundColor: Colors.transparent,
        elevation: 0, // Disable default shadow
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search_outlined,
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
