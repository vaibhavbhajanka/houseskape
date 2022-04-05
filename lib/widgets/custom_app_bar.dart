import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData leading;
  final IconData actions;
  final double elevation;

  const CustomAppBar(
      {Key? key,
      this.title='',
      this.elevation=4,
      this.leading = Icons.arrow_back_ios_new_rounded,
      required this.actions})
      : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      leading: IconButton(
        icon: Icon(
          leading,
          color: const Color(0xff25262b),
        ),
        onPressed: () {},
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xff25262b),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            actions,
            size: 25,
            color: const Color(0xff25262b),
          ),
        ),
      ],
      centerTitle: true,
      backgroundColor: const Color(0xfffcf9f4),
    );
  }
}