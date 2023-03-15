class AdbUtil {
  static String currentDevice = "";

  static void setCurrentDevice(String device) {
    currentDevice = device;
  }

  static String adbFolderPath = "";

  static void setPath(String path) {
    adbFolderPath = path;
  }

  static List<String> generateCmd(String cmd, {bool needDevice = true}) {
    List<String> cmdList = [];
    if (currentDevice.isNotEmpty && needDevice) {
      cmdList.add("$adbFolderPath/adb -s $currentDevice $cmd");
      cmdList.add("adb -s $currentDevice $cmd");
      return cmdList;
    }

    cmdList.add("$adbFolderPath/adb $cmd");
    cmdList.add("adb $cmd");
    return cmdList;
  }
}
