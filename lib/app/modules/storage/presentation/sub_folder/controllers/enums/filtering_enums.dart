enum ResourceTypeFilters {
  all,
  files,
  folders,
}

extension ResourceTypeFiltersExtension on ResourceTypeFilters {
  String get name {
    switch (this) {
      case ResourceTypeFilters.all:
        return 'All';
      case ResourceTypeFilters.files:
        return 'Files';
      case ResourceTypeFilters.folders:
        return 'Folders';
    }
  }
}

enum ResourceOwnershipFilters {
  any,
  myResources,
  sharedWithOther,
  sharedByOthers,
}

extension ResourceOwnershipFiltersExtension on ResourceOwnershipFilters {
  String get name {
    switch (this) {
      case ResourceOwnershipFilters.any:
        return 'Any';
      case ResourceOwnershipFilters.myResources:
        return 'My Resources';
      case ResourceOwnershipFilters.sharedWithOther:
        return 'Shared with Other\'s';
      case ResourceOwnershipFilters.sharedByOthers:
        return 'Shared by Other\'s';
    }
  }
}
