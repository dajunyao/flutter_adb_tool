import 'package:flutter/material.dart';
import 'package:test_flutter_cmd/pages/main_board/drop_target_common.dart';
import 'package:test_flutter_cmd/utils/SharedPreferenceUtil.dart';

class ModuleSettings extends StatefulWidget {
  final int moduleId;

  const ModuleSettings(this.moduleId, {Key? key}) : super(key: key);

  @override
  State<ModuleSettings> createState() => _ModuleSettingsState();
}

class _ModuleSettingsState extends State<ModuleSettings>
    with SharedPreferenceUtil {
  String _currentSource = "";

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Module Settings"),
        actions: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.only(right: 15),
              child: TextButton(
                onPressed: () {
                  if (_currentSource.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      "Please select Source apk ",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )));
                    return;
                  }
                  String target = _controller.text;
                  if (target.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      "Please select Target apk ",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )));
                    return;
                  }
                  Navigator.pop(context, [_currentSource, target]);
                },
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.black;
                  }
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.grey;
                  }
                })),
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Source Apk Path : ",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  DropTargetCommon(
                    MediaQuery.of(context).size.width,
                    200,
                    (path) {
                      _getSourcePath(path);
                    },
                    (path) {
                      _getSourcePath(path);
                    },
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Target Apk Path : ",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _controller,
                    ),
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  void _getSourcePath(String path) {
    _currentSource = path;
    String key =
        "${SharedPreferenceUtil.module_setting_source}${widget.moduleId}";
    saveSharedString(key, path);
  }
}
