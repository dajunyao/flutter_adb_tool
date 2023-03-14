import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_flutter_cmd/bean/cmd_log_bean.dart';

class CmdLogItem extends StatelessWidget {
  final CmdLogBean logBean;

  const CmdLogItem(this.logBean, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: logBean.content));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Copy Success",
          style: TextStyle(fontSize: 16, color: Colors.white),
        )));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          logBean.content,
          style: TextStyle(
              color: logBean.isCmd ? Colors.yellow : Colors.white,
              fontSize: 14),
        ),
      ),
    );
  }
}
