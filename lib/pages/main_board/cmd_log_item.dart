import 'package:flutter/material.dart';

class CmdLogItem extends StatelessWidget {
  final String content;

  const CmdLogItem(this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        content,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
