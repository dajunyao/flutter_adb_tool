import 'package:flutter/material.dart';

class ElevatedButtonCommon extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const ElevatedButtonCommon({Key? key, required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTap?.call();
      },
      style: ButtonStyle(iconSize: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.hovered)) {
          return 22;
        }
        return 18;
      }), backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.hovered)) {
          return Colors.blue;
        }
        return Colors.black;
      })),
      child: child,
    );
  }
}
