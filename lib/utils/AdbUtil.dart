class AdbUtil {

  static String currentDevice = "";

  static void setCurrentDevice(String device){
    currentDevice = device;
  }

  static String adbFolderPath = "";

  static void setPath(String path) {
    adbFolderPath = path;
  }

  static String getPath() {
    return adbFolderPath;
  }

  static String generateCmd(String cmd, {bool needDevice = true}) {
    if (currentDevice.isNotEmpty && needDevice) {
      return "adb -s $currentDevice $cmd";
    }
    return "adb $cmd";
  }
}
