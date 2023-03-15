import 'package:flutter/material.dart';
import 'package:test_flutter_cmd/widgets/module_text_button.dart';

import '../../consts/module_consts.dart';

class ModuleSelectItem extends StatelessWidget {
  final int id;
  final bool selected;
  final Function(int) result;

  const ModuleSelectItem(this.id, this.selected, this.result, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModuleTextButton(
      ModuleName.getNameById(id),
      press: () {
        result.call(id);
        Navigator.pop(context);
      },
    );
  }
}
