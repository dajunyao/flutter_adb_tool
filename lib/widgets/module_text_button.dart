import 'package:flutter/material.dart';
import 'package:test_flutter_cmd/widgets/elevated_button_common.dart';

class ModuleTextButton extends StatelessWidget {
  final String title;
  final VoidCallback? press;

  const ModuleTextButton(this.title, {Key? key, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButtonCommon(
          onTap: () {
            press?.call();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )),
    );
  }
}
