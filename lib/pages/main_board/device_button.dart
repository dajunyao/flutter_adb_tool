import 'package:flutter/material.dart';
import 'package:process_run/shell_run.dart';
import 'package:test_flutter_cmd/utils/AdbUtil.dart';
import 'package:test_flutter_cmd/utils/ShadowUtil.dart';
import 'package:test_flutter_cmd/utils/ShellUtil.dart';

import '../../widgets/elevated_button_common.dart';

class DeviceButton extends StatefulWidget {
  final double height;
  final Function(String, bool) logBack;

  const DeviceButton(this.height, this.logBack, {Key? key}) : super(key: key);

  @override
  State<DeviceButton> createState() => _DeviceButtonState();
}

class _DeviceButtonState extends State<DeviceButton> {
  static const INIT = 0;
  static const SEARCHING = 1;
  static const NO_DEVICE = 2;
  static const GET_DEVICE = 3;
  static const ERROR = 4;

  int _status = INIT;

  final _shell = ShellUtil.getAdbShell();

  List<DropdownMenuItem<String>> _deviceList = [];

  @override
  Widget build(BuildContext context) {
    if (_status == INIT) {
      _searchForDevice();
    }
    return Row(
      children: [
        Expanded(
            child: Container(
                height: widget.height,
                alignment: Alignment.centerLeft,
                child: getLeft())),
        getRight()
      ],
    );
  }

  Widget getLeft() {
    switch (_status) {
      case INIT:
      case SEARCHING:
        return const Text(
          "Searching Devices...",
          style: TextStyle(fontSize: 20, color: Colors.black),
        );
      case NO_DEVICE:
        return const Text(
          "No device found",
          style: TextStyle(fontSize: 20, color: Colors.black),
        );
      case ERROR:
        return const Text(
          "Sth error",
          style: TextStyle(fontSize: 20, color: Colors.black),
        );
      case GET_DEVICE:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.black),
          child: DropdownButton(
            isExpanded: true,
            dropdownColor: Colors.blue,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            icon: Container(
              margin: const EdgeInsets.only(left: 5),
              child: const Icon(
                Icons.phone_android,
                size: 16,
                color: Colors.white,
              ),
            ),
            value: AdbUtil.currentDevice,
            items: _deviceList,
            onChanged: (value) {
              setState(() {
                AdbUtil.setCurrentDevice(value!);
                widget.logBack?.call("current device is $value", false);
              });
            },
          ),
        );
    }
    return Container();
  }

  Widget getRight() {
    if (_status != INIT && _status != SEARCHING) {
      return Container(
        height: widget.height,
        width: widget.height,
        margin: const EdgeInsets.only(left: 15),
        child: ElevatedButtonCommon(
          onTap: () {
            setState(() {
              _status = INIT;
            });
          },
          child: const Icon(
            Icons.refresh,
            color: Colors.white,
          ),
        ),
      );
    }
    return Container();
  }

  void _searchForDevice() async {
    _status = SEARCHING;
    _deviceList = [];
    try {
      String cmd = AdbUtil.generateCmd("devices", needDevice: false);
      widget.logBack?.call(cmd, true);
      var res = await _shell.run(cmd);
      if (res.isNotEmpty && res.first.exitCode == 0) {
        var line = res.outLines;
        var firstDevice = "";
        for (String l in line) {
          widget.logBack?.call(l, false);
          if (l.isEmpty || l == "List of devices attached") {
            continue;
          }
          List<String> splits = l.split("\t");
          _deviceList.add(DropdownMenuItem(
            value: splits[0],
            child: Text(
              splits[0],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ));
          if (firstDevice.isEmpty) {
            firstDevice = splits[0];
          }
        }
        if (firstDevice.isNotEmpty) {
          AdbUtil.setCurrentDevice(firstDevice);
          _status = GET_DEVICE;
          widget.logBack?.call("current device is $firstDevice", false);
        } else {
          _status = NO_DEVICE;
          widget.logBack?.call("No device attached", false);
        }
      } else {
        _status = ERROR;
        widget.logBack?.call(res.errText, false);
      }
    } catch (e) {
      _status = ERROR;
      if (e is ShellException) {
        widget.logBack?.call(e.message, false);
      } else {
        widget.logBack?.call(e.toString(), false);
      }
    }
    setState(() {});
  }
}
