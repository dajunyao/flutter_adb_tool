import 'package:process_run/shell_run.dart';

class ShellUtil {
  static final Shell _shell = Shell();

  static Shell newInstance() {
    return _shell;
  }

  static Shell? _adbShell;

  static Shell getAdbShell() {
    return _adbShell!;
  }

  static Shell newAdbInstance(String home) {
    _adbShell = Shell(workingDirectory: home);
    return _adbShell!;
  }
}
