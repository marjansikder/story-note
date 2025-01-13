import 'package:flutter/material.dart';

class BlankPage extends StatelessWidget {
  final Widget children;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const BlankPage({super.key, required this.children, this.margin, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        /*image: const DecorationImage(
          image: AssetImage("assets/icons/note_list.png"),
          fit: BoxFit.cover,
        ),*/
      ),
      child: children,
    );
  }
}