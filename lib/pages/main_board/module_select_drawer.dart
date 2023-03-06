import 'package:flutter/material.dart';
import 'package:test_flutter_cmd/pages/main_board/module_select_item.dart';

import '../../consts/module_consts.dart';

class ModuleSelectDrawer extends StatefulWidget {
  final int current_id;

  const ModuleSelectDrawer(this.current_id, {Key? key}) : super(key: key);

  @override
  State<ModuleSelectDrawer> createState() => _ModuleSelectDrawerState();
}

class _ModuleSelectDrawerState extends State<ModuleSelectDrawer> {
  final List<int> _moduleIds = [
    ModuleId.launcher,
    ModuleId.settings,
    ModuleId.vod_widget,
    ModuleId.system_ui
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (ctx, index) {
        return Container(
          height: 15,
        );
      },
      itemBuilder: (ctx, index) {
        if (index == 0) {
          return Container(
            color: Colors.black,
            margin: const EdgeInsets.only(bottom: 10),
            padding:
                const EdgeInsets.only(top: 30, bottom: 15, left: 10, right: 10),
            child: const Text(
              "Select a module",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          );
        } else {
          return ModuleSelectItem(_moduleIds[index - 1],
              _moduleIds[index - 1] == widget.current_id);
        }
      },
      itemCount: _moduleIds.length + 1,
    );
  }
}
