import 'package:process_run/shell_run.dart';

class ShellUtil {
  static final Shell _shell = Shell();

  static Shell newInstance() {
    return _shell;
  }
}
