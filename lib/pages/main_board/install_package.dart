import 'package:flutter/material.dart';
import 'package:test_flutter_cmd/pages/main_board/drop_target_common.dart';

class InstallPackage extends StatefulWidget {
  const InstallPackage({Key? key}) : super(key: key);

  @override
  State<InstallPackage> createState() => _InstallPackageState();
}

class _InstallPackageState extends State<InstallPackage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Install"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: const Text(
              "Select or Drop Apk here...",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            child: DropTargetCommon(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              dropPathCallback: (path) {
                Navigator.pop(context, path);
              },
              tapPathCallback: (path) {
                Navigator.pop(context, path);
              },
            ),
          ))
        ],
      ),
    );
  }
}
