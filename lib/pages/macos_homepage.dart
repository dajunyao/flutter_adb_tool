import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:test_flutter_cmd/pages/main_board/adb_tool_main_board.dart';

import '../utils/SharedPreferenceUtil.dart';

/**
 * homepage for macos
 *
 * using cmd to get adb path
 *
 */
class MacOSHomepage extends StatefulWidget {
  const MacOSHomepage({Key? key}) : super(key: key);

  @override
  State<MacOSHomepage> createState() => _MacOSHomepageState();
}

class _MacOSHomepageState extends State<MacOSHomepage>
    with SharedPreferenceUtil {
  void _checkAdbPath() async {
    var shell = Shell();
    try {
      var savedPath = await getSharedString("adb_path");
      if (savedPath.isEmpty) {
        _searchingForAdbPath();
        return;
      }
      var res = await shell.runExecutableArguments(savedPath, ["version"]);
      if (res.exitCode == 0) {
        _goToMainBoard(savedPath);
        return;
      } else {
        await saveSharedString("adb_path", "");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    _searchingForAdbPath();
  }

  var _searching = true;

  void _searchingForAdbPath() async {
    var shell = Shell();
    try {
      var whichAdbRes = await shell.runExecutableArguments("which", ["adb"]);
      if (whichAdbRes.exitCode != 0) {
        setState(() {
          _searching = false;
        });
      } else {
        var path = whichAdbRes.outLines.first;
        await saveSharedString("adb_path", path);
        _goToMainBoard(path);
        return;
      }
    } catch (e) {
      setState(() {
        _searching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_searching) {
      _checkAdbPath();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tools on Macos"),
      ),
      body: _searching
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _dropPathWidget(),
    );
  }

  var _dragging = false;

  Widget _dropPathWidget() {
    return Center(
      child: Row(
        children: [
          const Text("Please drop adb folder here..."),
          DropTarget(
              onDragEntered: (detail) {
                setState(() {
                  _dragging = true;
                });
              },
              onDragExited: (detail) {
                setState(() {
                  _dragging = false;
                });
              },
              onDragDone: (detail) {
                setState(() {
                  _searching = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(detail.files.first.path)));
              },
              child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                      color: _dragging ? Colors.lightBlueAccent : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.lightBlueAccent))))
        ],
      ),
    );
  }

  void _goToMainBoard(String path) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => AdbToolMainBoard(path)));
  }
}
