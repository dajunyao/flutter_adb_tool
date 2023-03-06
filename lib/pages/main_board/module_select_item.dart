import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../../consts/module_consts.dart';
import '../../events/module_select_event.dart';

class ModuleSelectItem extends StatelessWidget {
  final int id;
  final bool selected;

  const ModuleSelectItem(this.id, this.selected, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.black),
      child: TextButton(
          onPressed: () {
            EventBus().fire(ModuleSelectEvent(id));
            Navigator.pop(context);
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
            ModuleName.getNameById(id),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
    );
  }
}
