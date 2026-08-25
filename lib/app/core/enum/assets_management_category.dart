import 'package:ts_admin/app/core/gen/assets.gen.dart';

enum AssetsCategory {
  trucks,
  trailers,
  devices,
}

extension AssetsCategoryExtension on AssetsCategory {
  String get displayName {
    switch (this) {
      case AssetsCategory.trucks:
        return "Trucks";
      case AssetsCategory.trailers:
        return "Trailers";
      case AssetsCategory.devices:
        return "Devices";
    }
  }

  String get apiValue {
    switch (this) {
      case AssetsCategory.trucks:
        return 'trucks';
      case AssetsCategory.trailers:
        return 'trailers';
      case AssetsCategory.devices:
        return 'user'; //! review this
    }
  }

  String get imagePath {
    switch (this) {
      case AssetsCategory.trucks:
        return Assets.icons.truckIcon;
      case AssetsCategory.trailers:
        return Assets.icons.trailerIcon;
      case AssetsCategory.devices:
        return Assets.icons.devicesIcon;
    }
  }
}
