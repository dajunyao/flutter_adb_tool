import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:process_run/shell_run.dart';
import 'package:test_flutter_cmd/consts/module_consts.dart';
import 'package:test_flutter_cmd/pages/main_board/ModuleTextButton.dart';
import 'package:test_flutter_cmd/pages/main_board/module_settings.dart';
import 'package:test_flutter_cmd/utils/AdbUtil.dart';
import 'package:test_flutter_cmd/utils/ShadowUtil.dart';
import 'package:test_flutter_cmd/utils/SharedPreferenceUtil.dart';
import 'package:test_flutter_cmd/utils/ShellUtil.dart';

import 'cmd_log_item.dart';
import 'device_button.dart';
import 'module_select_drawer.dart';

class AdbToolMainBoard extends StatefulWidget {
  const AdbToolMainBoard({Key? key}) : super(key: key);

  @override
  State<AdbToolMainBoard> createState() => _AdbToolMainBoardState();
}

class _AdbToolMainBoardState extends State<AdbToolMainBoard>
    with SharedPreferenceUtil {
  final List<String> _logList = [];
  final _shell = ShellUtil.newInstance();

  static const double _titleHeight = 50;

  int _currentModuleId = -1;
  String _currentModuleTarget = "";
  String _currentModuleSource = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      endDrawer: Drawer(
        child: ModuleSelectDrawer(_currentModuleId, (id) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              _currentModuleId = id;
              _getPathByModuleId();
            });
          });
        }),
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
                  const SizedBox(
                    height: _titleHeight,
                    child: Text(
                      "Command Line Logs",
                      style: TextStyle(fontSize: 20),
                    ),
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
                  DeviceButton(_titleHeight, (log) {
                    _addLog(log);
                  }),
                  Expanded(
                      child: _currentModuleId == -1
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                              alignment: Alignment.topLeft,
                              child: Builder(
                                  builder: (ctx) => GestureDetector(
                                        child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Text(
                                            "Choose target module",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                        onTap: () {
                                          Scaffold.of(ctx).openEndDrawer();
                                        },
                                      )),
                            )
                          : _selectedModule())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getPathByModuleId() async {
    String sourceKey =
        "${SharedPreferenceUtil.module_setting_source}#$_currentModuleId";
    _currentModuleSource = await getSharedString(sourceKey);
    String targetKey =
        "${SharedPreferenceUtil.module_setting_target}#$_currentModuleId";
    _currentModuleTarget = await getSharedString(targetKey);
  }

  _addLog(String content) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _logList.insert(0, content);
      });
    });
  }

  Widget _selectedModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: ShadowUtil.getCommonShadow(),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                ModuleName.getNameById(_currentModuleId),
                style: const TextStyle(color: Colors.black, fontSize: 16),
              )),
              Builder(
                  builder: (ctx) => GestureDetector(
                        onTap: () {
                          Scaffold.of(ctx).openEndDrawer();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child:
                              const Icon(Icons.edit_note, color: Colors.black),
                        ),
                      ))
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        _moduleButton("PUSH"),
        _moduleButton("REBOOT"),
        _moduleButton("Module Setting"),
      ],
    );
  }

  Widget _moduleButton(String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ModuleTextButton(title, press: () {
        switch (title) {
          case "PUSH":
            _checkAndPush();
            break;
          case "REBOOT":
            _reboot();
            break;
          case "Module Setting":
            _showModuleSettingsDialog();
            break;
        }
      }),
    );
  }

  void _checkAndPush() {
    if (_currentModuleSource.isEmpty || _currentModuleSource.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Source / Target Apk Path not found, please click 'Module Setting'",
        style: TextStyle(fontSize: 16, color: Colors.white),
      )));
      return;
    }
  }

  void _reboot() async {
    try {
      String cmd = AdbUtil.generateCmd("reboot");
      _addLog(cmd);
      await _shell.run(cmd);
    } catch (e) {
      if (e is ShellException) {
        _addLog(e.message);
      } else {
        _addLog(e.toString());
      }
    }
  }

  void _showModuleSettingsDialog() {
    if (_currentModuleId >= 0) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => ModuleSettings(_currentModuleId)))
          .then((value) {
        if (value != null && value is List) {
          _currentModuleSource = value[0];
          _currentModuleTarget = value[1];
          _addLog("Module Setting Success");
        }
      });
    }
  }
}
