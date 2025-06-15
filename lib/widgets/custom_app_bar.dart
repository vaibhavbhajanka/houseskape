import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leading;
  final double elevation;
  final Widget widget;
  final VoidCallback? onPressed;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.elevation = 4,
    this.leading = Icons.arrow_back_ios_new_rounded,
    required this.widget,
    this.onPressed,
  });
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      automaticallyImplyLeading: false,
      leading: leading != null
          ? IconButton(
              icon: Icon(
                leading,
                color: const Color(0xff25262b),
              ),
              onPressed: onPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xff25262b),
        ),
      ),
      actions: [
        widget
      ],
      centerTitle: true,
      backgroundColor: const Color(0xfffcf9f4),
    );
  }
}
