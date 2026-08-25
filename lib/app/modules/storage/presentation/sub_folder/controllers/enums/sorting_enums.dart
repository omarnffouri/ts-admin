enum ResourceSorts {
  newToOld,
  oldToNew,
  nameAZ,
  nameZA,
}

extension ResourceSortsExtension on ResourceSorts {
  String get name {
    switch (this) {
      case ResourceSorts.newToOld:
        return 'New to Old';
      case ResourceSorts.oldToNew:
        return 'Old to New';
      case ResourceSorts.nameAZ:
        return 'Name A-Z';
      case ResourceSorts.nameZA:
        return 'Name Z-A';
    }
  }
}
