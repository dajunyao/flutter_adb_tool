class ModuleId {
  static const int launcher = 0;
  static const int settings = 1;
  static const int vod_widget = 2;
  static const int system_ui = 3;
}

class ModuleName {
  static String getNameById(int id) {
    switch (id) {
      case ModuleId.launcher:
        return "Launcher";
      case ModuleId.settings:
        return "Settings";
      case ModuleId.vod_widget:
        return "VodWidget";
      case ModuleId.system_ui:
        return "SystemUI";
    }
    return "";
  }
}
