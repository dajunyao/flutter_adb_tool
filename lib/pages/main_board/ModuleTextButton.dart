import 'package:flutter/material.dart';

class ModuleTextButton extends StatelessWidget {
  final String title;
  final VoidCallback? press;

  const ModuleTextButton(this.title, {Key? key, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.black),
      child: TextButton(
          onPressed: () {
            press?.call();
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 20)),
            textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16)),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.grey;
              } else {
                return Colors.black;
              }
            }),
          ),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
    );
  }
}
