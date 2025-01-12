import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/font_util.dart';
import '../../dashboard_screen.dart';

class MenuAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MenuAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(106);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final authInfo = ref.watch(authInfoProvider);
    return AppBar(
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
            children: [
              const Row(
                children: [
                  //loadProfileImage(radius: 22, gender: authInfo.gender),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '',
                          overflow: TextOverflow.ellipsis,
                          style: FontUtil.blackW600S16,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'ID: ',
                          overflow: TextOverflow.ellipsis,
                          style: FontUtil.grey400S12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              TextButton(
                style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text('View Profile',
                    semanticsLabel: 'viewProfile',
                    style: FontUtil.primaryW500S14),
                onPressed: () {
                  Navigator.pushNamed(context, DashboardScreen.route);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
