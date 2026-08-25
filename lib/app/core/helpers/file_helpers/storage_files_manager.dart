import 'package:ts_admin/app/core/helpers/file_helpers/file_manager.dart';

class StorageFilesManager extends FileManager {
  @override
  String setDefaultExtension() {
    return "";
  }

  @override
  String setDirectory(String basePath) {
    //
    //
    // before changing please consider storage used,
    // and cache files disturbace
    // consider removing files from old folder
    return "$basePath/storage";
  }
}
