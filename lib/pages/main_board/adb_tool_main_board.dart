import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../../events/module_select_event.dart';
import 'cmd_log_item.dart';
import 'module_select_drawer.dart';

class AdbToolMainBoard extends StatefulWidget {
  final String path;

  const AdbToolMainBoard(this.path, {Key? key}) : super(key: key);

  @override
  State<AdbToolMainBoard> createState() => _AdbToolMainBoardState();
}

class _AdbToolMainBoardState extends State<AdbToolMainBoard> {
  bool _registerListener = false;
  StreamSubscription<ModuleSelectEvent>? _eventListener;

  void _registerEventListener() {
    _eventListener = EventBus().on<ModuleSelectEvent>().listen((event) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(event.id.toString())));
    });
    _registerListener = true;
  }

  @override
  void dispose() {
    super.dispose();
    _eventListener?.cancel();
  }

  final List<String> _logList = [];

  int currentModule = -1;

  @override
  Widget build(BuildContext context) {
    if (!_registerListener) {
      _registerEventListener();
    }
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      endDrawer: Drawer(
        child: ModuleSelectDrawer(currentModule),
      ),
      appBar: AppBar(
        title: const Text("Adb Tools"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Command Line Logs",
                    style: TextStyle(fontSize: 20),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListView.builder(
                        reverse: true,
                        itemBuilder: ((ctx, index) {
                          return CmdLogItem(_logList[index]);
                        }),
                        itemCount: _logList.length,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Module",
                    style: TextStyle(fontSize: 20),
                  ),
                  Expanded(
                      child: currentModule == -1
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                              alignment: Alignment.topLeft,
                              child: Builder(
                                  builder: (ctx) => GestureDetector(
                                        child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              color: Colors.lightBlueAccent,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Text(
                                            "Choose target module",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        onTap: () {
                                          Scaffold.of(ctx).openEndDrawer();
                                        },
                                      )),
                            )
                          : Row(
                              children: [Text("push"), Text("reboot")],
                            ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _addLog(String content) {
    setState(() {
      _logList.insert(0, content);
    });
  }
}
