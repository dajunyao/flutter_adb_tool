import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class DropTargetCommon extends StatefulWidget {
  final Function(String path) dropPathCallback;
  final Function(String path)? tapPathCallback;
  final double width;
  final double height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String? presetPath;

  const DropTargetCommon({
    Key? key,
    this.margin,
    this.padding,
    this.presetPath,
    required this.width,
    required this.height,
    required this.dropPathCallback,
    this.tapPathCallback,
  }) : super(key: key);

  @override
  State<DropTargetCommon> createState() => _DropTargetCommonState();
}

class _DropTargetCommonState extends State<DropTargetCommon> {
  bool _dragging = false;
  String _currentPath = "";

  @override
  void initState() {
    super.initState();
    _currentPath = widget.presetPath ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.tapPathCallback != null) {
          try {
            XFile? res = await openFile(acceptedTypeGroups: [
              const XTypeGroup(extensions: ["apk"])
            ]);
            if (res != null) {
              widget.tapPathCallback?.call(res.path);
              setState(() {
                _currentPath = res.path;
              });
            }
            // ignore: empty_catches
          } catch (e) {}
        }
      },
      child: DropTarget(
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
            if ((detail?.files?.first?.path ?? "").isNotEmpty) {
              widget.dropPathCallback?.call(detail.files.first.path);
              setState(() {
                _currentPath = detail.files.first.path;
              });
            }
          },
          child: Container(
              width: widget.width,
              height: widget.height,
              alignment: Alignment.center,
              margin: widget.margin ?? EdgeInsets.zero,
              padding: widget.padding ?? EdgeInsets.zero,
              decoration: BoxDecoration(
                  color: _dragging ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (_currentPath.isNotEmpty)
                      ? Text(
                          _currentPath,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        )
                      : Container(),
                  const Text(
                    "+",
                    style: TextStyle(fontSize: 56, color: Colors.black),
                  )
                ],
              ))),
    );
  }
}
