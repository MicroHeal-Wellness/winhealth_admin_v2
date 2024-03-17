import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winhealth_admin_v2/provider/sidebar_provvider.dart';
import 'package:winhealth_admin_v2/screens/auth/login_screen.dart';
import 'package:winhealth_admin_v2/services/auth_service.dart';
import 'package:winhealth_admin_v2/utils/constants.dart';

class SideBarItem extends StatelessWidget {
  final int pageKey;
  final IconData iconData;
  final String title;
  final bool isDisabled;
  const SideBarItem(
      {super.key,
      required this.pageKey,
      required this.iconData,
      required this.title,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isDisabled) {
          await AuthService.logOut(context);
          // logout
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          context.read<SideBarProvider>().changePage(pageKey);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.watch<SideBarProvider>().currentPage == pageKey
              ? Colors.white
              : primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Row(
            mainAxisAlignment: MediaQuery.of(context).size.width > 1200
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: context.watch<SideBarProvider>().currentPage == pageKey
                    ? Colors.black
                    : Colors.white,
              ),
              MediaQuery.of(context).size.width > 1200
                  ? const SizedBox(
                      width: 16,
                    )
                  : const SizedBox(),
              MediaQuery.of(context).size.width > 1200
                  ? Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        color: context.watch<SideBarProvider>().currentPage ==
                                pageKey
                            ? Colors.black
                            : Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
