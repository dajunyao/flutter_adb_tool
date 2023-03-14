import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:process_run/shell_run.dart';
import 'package:test_flutter_cmd/pages/main_board/adb_tool_main_board.dart';
import 'package:test_flutter_cmd/pages/main_board/drop_target_common.dart';
import 'package:test_flutter_cmd/utils/AdbUtil.dart';
import 'package:test_flutter_cmd/utils/ShellUtil.dart';

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
  final _shell = ShellUtil.newInstance();

  void _checkAdbPath() async {
    try {
      var savedPath = await getSharedString("adb_path");
      if (savedPath.isEmpty) {
        _searchingForAdbPath();
        return;
      }
      AdbUtil.setPath(savedPath);
      ShellUtil.newAdbInstance(savedPath);
      _goToMainBoard();
      return;
    } catch (e) {
      debugPrint(e.toString());
    }
    _searchingForAdbPath();
  }

  var _searching = true;

  void _searchingForAdbPath() async {
    try {
      String? whichAdbRes = await which("adb");
      if (whichAdbRes != null && whichAdbRes.isNotEmpty) {
        String folderPath = whichAdbRes.substring(0, whichAdbRes.length - 3);
        await saveSharedString("adb_path", folderPath);
        AdbUtil.setPath(folderPath);
        ShellUtil.newAdbInstance(folderPath);
        _goToMainBoard();
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      _searching = false;
    });
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Please drop adb folder here...",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          DropTargetCommon(400, 200, (path) {
            _onGetPath(path);
          }, (path) {
            _onGetPath(path);
          })
        ],
      ),
    );
  }

  void _onGetPath(String path) {
    // TODO djy need test
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      path,
      style: TextStyle(fontSize: 16, color: Colors.white),
    )));
    setState(() {
      _searching = true;
    });
  }

  void _goToMainBoard() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const AdbToolMainBoard()));
  }
}
