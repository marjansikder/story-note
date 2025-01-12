import 'dart:io';

import 'package:date_calculator/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/colors.dart';
import 'bottom_navigation_item.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  final int currentIndex;
  final List<BottomNavBarItem> items;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  Widget _buildItem(
      final BottomNavBarItem item, final bool isSelected, final double height) {
    //final authInfo = ref.watch(authInfoProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.ease,
      alignment: Alignment.center,
      height: height / 1.0,
      //color: AppColors.appBarColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: isSelected && item.label != NavigationLabel.profile
                ? ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [
                          AppColors.selectedBottomNavBarIconColor,
                          AppColors.selectedBottomNavBarIconColor
                        ],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcIn,
                    child: item.icon,
                  )
                : item.label == NavigationLabel.profile
                    ? const Icon(Icons.person_rounded, size: 26)
                    : item.icon,
          ),
          Material(
            type: MaterialType.transparency,
            child: DefaultTextStyle.merge(
              //style: isSelected ? FontUtil.primaryW400S10 : FontUtil.grey400S10,
              child: FittedBox(
                  child: Text(
                item.label.name,
                style: getCustomTextStyle(
                  fontSize: 12.5,
                  color: isSelected ? AppColors.selectedBottomNavBarIconColor : AppColors.bottomNavBarIconColor,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kohinoor'
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    const double navBarHeight = 75;
    final double itemWidth =
        MediaQuery.of(context).size.width / widget.items.length;
    return Container(
      width: double.infinity,
      height: navBarHeight,
      padding: Platform.isIOS
          ? const EdgeInsets.only(bottom: navBarHeight * 0.15)
          : const EdgeInsets.only(bottom: navBarHeight * 0.25),
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.grey.withOpacity(0.15),
            offset: const Offset(0, -2.0),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
                color: Colors.transparent,
                width: itemWidth * (widget.currentIndex + 0.25),
                height: 2,
              ),
              /*Flexible(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                  width: itemWidth * 0.5,
                  height: 1,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.kBlackColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),*/
            ],
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: widget.items.map((final item) {
                  final int index = widget.items.indexOf(item);
                  return Flexible(
                    child: GestureDetector(
                      onTap: () => widget.onTap(index),
                      child: Container(
                        color: Colors.transparent,
                        child: _buildItem(
                            item, widget.currentIndex == index, navBarHeight),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
