import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:process_run/shell_run.dart';
import 'package:test_flutter_cmd/consts/module_consts.dart';
import 'package:test_flutter_cmd/pages/main_board/install_package.dart';
import 'package:test_flutter_cmd/widgets/module_text_button.dart';
import 'package:test_flutter_cmd/pages/main_board/module_settings.dart';
import 'package:test_flutter_cmd/utils/AdbUtil.dart';
import 'package:test_flutter_cmd/utils/ShadowUtil.dart';
import 'package:test_flutter_cmd/utils/SharedPreferenceUtil.dart';
import 'package:test_flutter_cmd/utils/ShellUtil.dart';
import 'package:test_flutter_cmd/widgets/elevated_button_common.dart';

import '../../bean/cmd_log_bean.dart';
import 'cmd_log_item.dart';
import 'device_button.dart';
import 'module_select_drawer.dart';

class AdbToolMainBoard extends StatefulWidget {
  const AdbToolMainBoard({Key? key}) : super(key: key);

  @override
  State<AdbToolMainBoard> createState() => _AdbToolMainBoardState();
}

class _AdbToolMainBoardState extends State<AdbToolMainBoard>
    with SharedPreferenceUtil, SingleTickerProviderStateMixin {
  final List<CmdLogBean> _logList = [];
  final _shell = ShellUtil.getAdbShell();

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
          if (id == ModuleId.install) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const InstallPackage())).then((value) {
                if (value != null) {
                  _installSth(value);
                }
              });
            });
          } else {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              setState(() {
                _currentModuleId = id;
                _getPathByModuleId();
              });
            });
          }
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
                  Container(
                    height: _titleHeight,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Command Line Logs",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
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
                        Container(
                            margin: const EdgeInsets.only(right: 25, top: 25),
                            child: ElevatedButtonCommon(
                              onTap: () {
                                setState(() {
                                  _logList.clear();
                                });
                              },
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                            ))
                      ],
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
                  DeviceButton(_titleHeight, (text, isCmd) {
                    if (isCmd) {
                      _addCmd(text);
                    } else {
                      _addLog(text);
                    }
                  }),
                  const SizedBox(
                    height: 15,
                  ),
                  _currentModuleId == -1
                      ? Builder(
                          builder: (ctx) => ElevatedButtonCommon(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: const Text(
                                    "Choose target module",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                onTap: () {
                                  Scaffold.of(ctx).openEndDrawer();
                                },
                              ))
                      : Container(),
                  _currentModuleId == -1
                      ? Container()
                      : Expanded(child: _selectedModule())
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

  void _addCmd(String cmd) {
    CmdLogBean logBean = CmdLogBean(cmd, true);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _logList.insert(0, logBean);
      });
    });
  }

  void _addLog(String log) {
    CmdLogBean logBean = CmdLogBean(log, false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _logList.insert(0, logBean);
      });
    });
  }

  void _addShellLog(ShellException a) {
    if (a.result != null && a.result!.stdout is String) {
      _addLog(a.result?.stdout as String);
    } else {
      _addLog(a.message);
    }
  }

  Widget _selectedModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: ShadowUtil.getCommonShadow(),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  child: Text(
                ModuleName.getNameById(_currentModuleId),
                style: const TextStyle(color: Colors.black, fontSize: 16),
              )),
              Builder(
                  builder: (ctx) => Container(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            Scaffold.of(ctx).openEndDrawer();
                          },
                          style: ButtonStyle(backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.grey;
                            }
                            return Colors.white;
                          })),
                          child: Container(
                            child: const Icon(Icons.edit_note,
                                color: Colors.black),
                          ),
                        ),
                      ))
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        // _moduleButton("PWD"),
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
          case "PWD":
            _pwd();
            break;
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

  void _pwd() async {
    try {
      String cmd = "pwd";
      _addCmd(cmd);
      List<ProcessResult> results = await _shell.run(cmd);
      if (results.isNotEmpty) {
        _addLog(results.first.outText);
      }
    } catch (e) {
      if (e is ShellException) {
        _addShellLog(e);
      } else {
        _addLog(e.toString());
      }
    }
  }

  void _checkAndPush() async {
    if (_currentModuleSource.isEmpty || _currentModuleTarget.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Source / Target Apk Path not found, please click 'Module Setting'",
        style: TextStyle(fontSize: 16, color: Colors.white),
      )));
      return;
    }
    try {
      List<String> cmdRoot = AdbUtil.generateCmd("root");
      _addCmd(cmdRoot[1]);
      List<ProcessResult> resRoot = await _shell.run(cmdRoot[0]);
      if (resRoot.isNotEmpty) {
        _addLog(resRoot.first.outText);
      }

      List<String> cmdRemount = AdbUtil.generateCmd("remount");
      _addCmd(cmdRemount[1]);
      List<ProcessResult> resRemount = await _shell.run(cmdRemount[0]);
      if (resRemount.isNotEmpty) {
        _addLog(resRemount.first.outText);
      }

      List<String> cmdPush = AdbUtil.generateCmd(
          "push $_currentModuleSource $_currentModuleTarget");
      _addCmd(cmdPush[1]);
      List<ProcessResult> resPush = await _shell.run(cmdPush[0]);
      if (resPush.isNotEmpty) {
        _addLog(resPush.first.outText);
      }
    } catch (e) {
      if (e is ShellException) {
        _addShellLog(e);
      } else {
        _addLog(e.toString());
      }
    }
  }

  void _reboot() async {
    try {
      List<String> cmd = AdbUtil.generateCmd("reboot");
      _addCmd(cmd[1]);
      await _shell.run(cmd[0]);
    } catch (e) {
      if (e is ShellException) {
        _addShellLog(e);
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
          _savePathByModuleId();
        }
      });
    }
  }

  void _savePathByModuleId() async {
    String sourceKey =
        "${SharedPreferenceUtil.module_setting_source}#$_currentModuleId";
    await saveSharedString(sourceKey, _currentModuleSource);
    String targetKey =
        "${SharedPreferenceUtil.module_setting_target}#$_currentModuleId";
    await saveSharedString(targetKey, _currentModuleTarget);
  }

  void _installSth(String path) async {
    try {
      List<String> cmd = AdbUtil.generateCmd("install -t $path");
      _addCmd(cmd[1]);
      List<ProcessResult> res = await _shell.run(cmd[0]);
      if (res.isNotEmpty) {
        _addLog(res.first.outText);
      }
    } catch (e) {
      if (e is ShellException) {
        _addShellLog(e);
      } else {
        _addLog(e.toString());
      }
    }
  }
}
